//
//  YDisk+Metainfo.swift
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

extension YandexDisk {

    public enum MetainfoResult {
        case Done(total_space: Int, used_space: Int, trash_size: Int, system_folders:[String:Path])
        case Failed(NSError!)
    }

    /// Recieves meta info about the disk
    ///
    /// :param: handler     Optional.
    /// :returns: `MetainfoResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/capacity.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/capacity-docpage/`_.
    public func metainfo(handler:((result:MetainfoResult) -> Void)? = nil) -> Result<MetainfoResult> {
        let result = Result<MetainfoResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/"

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, errorHandler: error) {
            (jsonRoot, response)->Void in

            switch response.statusCode {
            case 200:
                if let system_folders_dict = jsonRoot["system_folders"] as? NSDictionary,
                    total_space = (jsonRoot["total_space"] as? NSNumber)?.integerValue,
                    used_space = (jsonRoot["used_space"] as? NSNumber)?.integerValue,
                    trash_size = (jsonRoot["trash_size"] as? NSNumber)?.integerValue
                {
                    var system_folders = Dictionary<String, Path>()
                    for (key, value) in system_folders_dict {
                        if let key = key as? String,
                            value = value as? String
                        {
                            system_folders[key] = Path.pathWithString(value)
                        }
                    }
                    return result.set(.Done(total_space:total_space, used_space:used_space, trash_size:trash_size, system_folders:system_folders))
                } else {
                    fallthrough
                }

            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response, "json":jsonRoot]))
            }
        }.resume()

        return result
    }
}
