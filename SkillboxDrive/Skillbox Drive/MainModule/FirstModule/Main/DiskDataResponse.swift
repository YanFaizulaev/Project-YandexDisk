//
//  DiskDataResponse.swift
//  Skillbox Drive
//
//  Created by Bandit on 25.01.2023.
//

import Foundation

struct DiskDataResponse: Decodable {
    let total_space : Int?
    let used_space : Int?
}

