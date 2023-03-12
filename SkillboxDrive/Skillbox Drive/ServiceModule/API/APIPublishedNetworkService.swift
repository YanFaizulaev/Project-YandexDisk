//
//  APIPublishedNetworkService.swift
//  Skillbox Drive
//
//  Created by Bandit on 13.02.2023.
//

import UIKit

class APIPublishedNetworkService: APIYandex {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPublishedFiles(_ limit: Int, completion: @escaping (Result<_embedded, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/public")
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "preview_crop", value: "true"),
            URLQueryItem(name: "preview_size", value: "50x50")
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        print("<<< MARK: 1.1 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
    func fetchDeleteActiveLink(_ path: String, completion: @escaping (Result<Response, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/unpublish")
        components?.queryItems = [
            URLQueryItem(name: "path", value: path)
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        print("<<< MARK: 1.2 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
}

extension APIPublishedNetworkService {
    
//    struct PublishedFilesModelResponse: Decodable {
//        let items: [PublishedDiskFile]?
//        let limit: Int?
//    }
//
//    struct PublishedDiskFile: Decodable {
//        let name: String?
//        let preview: String?
//        let created: String?
//        let modified: String?
//        let path: String?
//        let md5: String?
//        let type: String?
//        let mime_type: String?
//        let size: Int?
//
//    }
    
    struct Response: Decodable {
        let href : String?
        let method : String?
        let templated : Bool?
    }
    
}
