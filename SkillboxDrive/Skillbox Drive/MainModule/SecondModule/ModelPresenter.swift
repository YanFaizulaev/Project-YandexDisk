//
//  ModelPresenter.swift
//  Skillbox Drive
//
//  Created by Bandit on 14.02.2023.
//

import Foundation

struct ResponsePresenter: Decodable {
    let public_public_key : String?
    let _embedded : _embedded?
    let name : String?
    let created : String?
    let public_url : String?
    let modified : String?
    let path : String?
    let type : String?
}

struct _embedded : Decodable {
    let sort : String?
    let path : String?
    var items : [Items?]
    let limit : Int?
    let offset : Int?
}

struct Items : Decodable {
    var name: String?
    let preview: String?
    let created: String?
    let modified: String?
    var path: String?
    let type: String?
    let mime_type: String?
    let size: Int?
    let file: String? 
}
