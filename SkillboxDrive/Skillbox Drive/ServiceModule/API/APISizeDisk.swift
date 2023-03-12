//
//  APISizeDisk.swift
//  Skillbox Drive
//
//  Created by Bandit on 14.02.2023.
//

import UIKit

class APISizeDisk: APIYandex {
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchSizeDisk(completion: @escaping (Result<DiskDataResponse, APIError>) -> Void ) {
        let token = UserDefaults.standard.tokenUser
        let components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk")
        let url = components?.url
        var request = URLRequest(url: url!)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        print("<<< MARK: 1.0 URL - \(String(describing: url))")

        perform(request: request, completion: parseDecodable(completion: completion))
    }
    
}

//extension APISizeDisk {
    
//    struct DiskDataResponse: Decodable {
//        let total_space : Int?
//        let used_space : Int?
//    }
    
//}
