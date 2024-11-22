//
//  RAWGClient.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import Foundation

//class setup
class RAWGClient {
    static let shared = RAWGClient()
    private let baseURL = "https://api.rawg.io/api/"
    private let apiKey = "4286de6535b0405c8a5d648c35b6ddee"
    
    //fetching info from the API
    func fetch<T: Decodable>(_ endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint)!
        
        //adds the API key to all requests
        var queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        components.queryItems = queryItems
        
        //prints the final URL
        print("🔗 Final URL: \(components.url?.absoluteString ?? "invalid URL")")
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        //prints raw response data
        print("📦 Raw response data: \(String(data: data, encoding: .utf8) ?? "invalid data")")
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
