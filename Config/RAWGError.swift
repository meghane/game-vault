//
//  RAWGError.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import Foundation

//API error-catching
enum RAWGError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
}

