//
//  APIPresenter.swift
//  Skillbox Drive
//
//  Created by Bandit on 14.02.2023.
//

import UIKit

class APIPresenter: APIYandex {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPresenter(_ path: String?, completion: @escaping (Result<ResponsePresenter, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: path)
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        print("<<< MARK: 2.1.0 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
    func fetchURLFile(_ path: String, completion: @escaping (Result<Response, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/download")
        components?.queryItems = [
            URLQueryItem(name: "path", value: path)
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print("<<< MARK: 2.1.1 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
    func fetchLine(_ path: String, completion: @escaping (Result<Response, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/publish")
        components?.queryItems = [
            URLQueryItem(name: "path", value: path)
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        print("<<< MARK: 2.1.2 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
    func fetchDelite(_ path: String, completion: @escaping (Result<Response, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: path),
            URLQueryItem(name: "permanently", value: "false")
        ]
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        print("<<< MARK: 2.1.3 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
}

extension APIPresenter {
    
    // MARK: -
//    struct ResponsePresenter: Decodable {
//        let public_public_key : String?
//        let _embedded : Embedded?
//        let name : String?
//        let created : String?
//        let custom_properties : Custom_properties?
//        let public_url : String?
//        let modified : String?
//        let path : String?
//        let type : String?
//    }
//
//    struct Embedded : Decodable {
//        let sort : String?
//        let path : String?
//        let items : [Items]?
//        let limit : Int?
//        let offset : Int?
//    }
//
//    struct Custom_properties : Decodable {
//        let foo : String?
//        let bar : String?
//    }
//
//    struct Items : Decodable {
//        let path : String?
//        let type : String?
//        let name : String?
//        let modified : String?
//        let created : String?
//    }
    
    // MARK: -
    struct Response: Decodable {
        let href : String?
        let method : String?
        let templated : Bool?
    }
    
}
