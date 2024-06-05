//
//  NetworkError.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import Foundation

enum NetworkError: Error{
    case invalidURL
    case parsingError
    case dataNotFound
}

extension NetworkError:LocalizedError{
    var errorDescription :String?{
        switch self{
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "invalidURL")
        case .parsingError:
            return NSLocalizedString("Parsing Error", comment: "parsingError")
        case .dataNotFound:
            return NSLocalizedString("DataNot Found", comment: "dataNotFound")
        }
    }
}
