//
//  APIAuthorize.swift
//  Skillbox Drive
//
//  Created by Bandit on 15.02.2023.
//

import UIKit
import WebKit

class APIAuthorize {
    
    private let clientId = "e0abaa5dd5c741319f1dda58af34f8b0"
    
    var request: URLRequest? {
        guard var components = URLComponents(string: "https://oauth.yandex.ru/authorize?") else
        { return nil }
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientId)")
        ]
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
