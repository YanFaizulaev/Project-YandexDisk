//
//  APIEdit.swift
//  Skillbox Drive
//
//  Created by Bandit on 14.02.2023.
//

import UIKit

class APIEdit: APIYandex {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchEdit(from: String, path: String, completion: @escaping (Result<Response, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/move")
        components?.queryItems = [
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "path", value: path),
//            URLQueryItem(name: "overwrite", value: "true")
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        print("<<< MARK: 2.2 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
}

extension APIEdit {
    
    // MARK: -
    struct Response: Decodable {
        let href : String?
        let method : String?
        let templated : Bool?
    }
    
}
