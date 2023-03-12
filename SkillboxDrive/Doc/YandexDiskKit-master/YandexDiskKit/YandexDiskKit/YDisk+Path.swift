//
//  YDisk+Path.swift
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

public func <(l:YandexDisk.Path, r:YandexDisk.Path) -> Bool {
    switch (l, r) {
    case let (.App(lstring), .App(rstring)):
        return lstring < rstring
    case let (.Disk(lstring), .Disk(rstring)):
        return lstring < rstring
    case let (.Trash(lstring), .Trash(rstring)):
        return lstring < rstring
    case (.App, .Disk), (.App, .Trash), (.Disk, .Trash):
        return true
    default:
        return false
    }
}

public func ==(l:YandexDisk.Path, r:YandexDisk.Path) -> Bool {
    switch (l, r) {
    case let (.App(lstring), .App(rstring)):
        return lstring == rstring
    case let (.Disk(lstring), .Disk(rstring)):
        return lstring == rstring
    case let (.Trash(lstring), .Trash(rstring)):
        return lstring == rstring
    default:
        return false
    }
}

extension YandexDisk {

    public enum Path : Printable, Equatable {
        case App(String)
        case Disk(String)
        case Trash(String)

        private static func stringWithoutTrainingSlash(path: String) -> String {
            if path.hasSuffix("/") {
                return prefix(path, count(path)-1)
            } else {
                return path
            }
        }

        public static func appPathWithString(var path: String) -> YandexDisk.Path {
            if path.hasPrefix("app:/") {
                path = path[advance(path.startIndex, 5)..<path.endIndex]
            }
            path = stringWithoutTrainingSlash(path)
            return YandexDisk.Path.App(path)
        }

        public static func diskPathWithString(var path: String) -> YandexDisk.Path {
            if path.hasPrefix("disk:/") {
                path = path[advance(path.startIndex, 6)..<path.endIndex]
            }
            path = stringWithoutTrainingSlash(path)
            return YandexDisk.Path.Disk(path)
        }

        public static func trashPathWithString(var path: String) -> YandexDisk.Path {
            if path.hasPrefix("trash:/") {
                path = path[advance(path.startIndex, 7)..<path.endIndex]
            }
            path = stringWithoutTrainingSlash(path)
            return YandexDisk.Path.Trash(path)
        }

        public static func pathWithString(path: String) -> YandexDisk.Path {
            switch path {
            case let path where path.hasPrefix("app:/"):
                return appPathWithString(path)
            case let path where path.hasPrefix("disk:/"):
                return diskPathWithString(path)
            case let path where path.hasPrefix("trash:/"):
                return trashPathWithString(path)
            default:
                return diskPathWithString(path)
            }
        }

        public var stringValue : String {
            switch self {
            case .App(let string):
                return "app:/\(string)"
            case .Disk(let string):
                return "disk:/\(string)"
            case .Trash(let string):
                return "trash:/\(string)"
            }
        }

        var toUrlEncodedString : String {
            return self.stringValue.urlEncoded()
        }

        /// Required by protocol Printable
        public var description: String {
            return self.stringValue
        }
    }

}
