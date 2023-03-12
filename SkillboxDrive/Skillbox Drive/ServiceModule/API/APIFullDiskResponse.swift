//
//  APIFullDiskResponse.swift
//  Skillbox Drive
//
//  Created by Bandit on 14.02.2023.
//

import UIKit

class APIFullDiskResponse: APIYandex {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchFullDiskResponse(_ path: String?,_ limit: Int, completion: @escaping (Result<ResponsePresenter, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: path != nil ? path : "disk:/"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "preview_crop", value: "true"),
            URLQueryItem(name: "preview_size", value: "50x50"),
            URLQueryItem(name: "sort", value: "-created")
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        print("<<< MARK: 3.0 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
}

//extension APIFullDiskResponse {
    
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
    
//    struct Response: Decodable {
//        let href : String?
//        let method : String?
//        let templated : Bool?
//    }
//}
