//
//  YDisk+Resource.swift
//
//  Copyright (c) 2014-2015, Clemens Auer
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import Foundation
import CoreData

public enum YandexDiskResourceType : String, Printable {
    case File = "file"
    case Directory = "dir"

    /// Required by protocol Printable
    public var description: String {
        return self.rawValue
    }
}

public protocol YandexDiskResource : Printable {

    var type : YandexDiskResourceType { get }
    var path : YandexDisk.Path { get }
    var name: String { get }
    var created: NSDate { get }
    var modified: NSDate { get }
    var size: NSNumber? { get }
    var md5: String? { get }
    var mime_type: String? { get }
    var media_type: String? { get }
    var preview: String? { get }
    var public_key: String? { get }
    var public_url: String? { get }
    var origin_path: String? { get }
    var custom_properties: NSDictionary? { get }

}

extension YandexDisk {
    
    public class SimpleResource : NSObject, YandexDiskResource {

        public let type : YandexDiskResourceType
        public let name : String
        public let path : YandexDisk.Path
        public let created : NSDate
        public let modified : NSDate
        public let size : NSNumber?
        public let md5 : String?
        public let mime_type : String?
        public let media_type : String?
        public let preview : String?
        public let public_key : String?
        public let public_url : String?
        public let origin_path: String?
        public let custom_properties: NSDictionary?

        private static let dateformatter = NSDateFormatter.iso8601dateFormatter()

        init(type: YandexDiskResourceType, name: String, path: YandexDisk.Path, created: NSDate, modified: NSDate, dictionary props: NSDictionary) {
            self.type = type
            self.name = name
            self.path = path
            self.created = created
            self.modified = modified

            // the following properties are optional and can be absent
            size = (props["size"] as? NSNumber)?.integerValue
            preview = props["preview"] as? String
            mime_type = props["mime_type"] as? String
            md5 = props["md5"] as? String
            public_key = props["public_key"] as? String
            public_url = props["public_url"] as? String
            origin_path = props["origin_path"] as? String
            media_type = props["media_type"] as? String
            custom_properties = props["custom_properties"] as? NSDictionary
        }

        class func resourceFromDictionary(properties:NSDictionary?) -> YandexDiskResource? {
            // According to API documentationthe following properties are
            // required, so we will fail if they are not existing

            if let props = properties,
                str = props["type"] as? String,
                type = YandexDiskResourceType(rawValue: str),
                name = props["name"] as? String,
                path_str = props["path"] as? String,
                created_str = props["created"] as? String,
                modified_str = props["modified"] as? String
            {
                let path = Path.pathWithString(path_str)
                let created = dateformatter.dateFromString(created_str) ?? NSDate(timeIntervalSince1970: 0)
                let modified = dateformatter.dateFromString(modified_str) ?? NSDate(timeIntervalSince1970: 0)

                return SimpleResource(type: type, name: name, path: path, created: created, modified: modified, dictionary: props)
            }
            return nil
        }

        class func resourcesFromArray(array:NSArray?) -> [YandexDiskResource]? {

            var elements: [YandexDiskResource] = []

            if let items = array {
                for item in items {
                    if let element = SimpleResource.resourceFromDictionary(item as? NSDictionary) {
                        elements += [element]
                    } else {
                        return nil
                    }
                }
                return elements
            }
            return nil
        }
        

        /// Required by protocol Printable
        override public var description: String {
        if let s = size {
            return "f \(name) \t\(s) bytes \t\(mime_type ?? String())"
        } else {
            return "d \(name)"
            }
        }
    }

}