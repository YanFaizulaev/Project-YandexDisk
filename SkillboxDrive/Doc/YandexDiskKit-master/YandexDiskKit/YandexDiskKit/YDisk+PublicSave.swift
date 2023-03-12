//
//  YDisk+PublicSave.swift
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

    public enum PublicSaveResult {
        case Done(href:String, method:String, templated:Bool)
        case InProcess(href:String, method:String, templated:Bool)
        case Failed(NSError!)
    }

    /// Downloads a public resource to Yandex Disk.
    ///
    /// :param: key         Public key for a stored resource.
    /// :param: path        Optional. The path within the public folder.
    ///   You should specify if the value of the `key` parameter passes the key to the public folder that the desired file is located in.
    /// :param: name        Optional. The name to save the file under in the "Downloads" folder.
    /// :param: handler     Optional.
    /// :returns: `PublicSaveResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/public.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/public-docpage/`_.
    public func savePublicToDisk(key public_key: String, name: String?=nil, path: String?=nil, handler:((result:PublicSaveResult) -> Void)? = nil) -> Result<PublicSaveResult> {
        let result = Result<PublicSaveResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/public-resources/save-to-disk/?public_key=\(public_key.urlEncoded())"

        url.appendOptionalURLParameter("name", value:name)
        url.appendOptionalURLParameter("path", value:path)

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, method:"POST", errorHandler: error) {
            (jsonRoot, response)->Void in

            let (href, method, templated) = YandexDisk.hrefMethodTemplatedWithDictionary(jsonRoot)

            switch response.statusCode {
            case 201:
                return result.set(.Done(href:href, method:method, templated:templated))

            case 202:
                return result.set(.InProcess(href:href, method:method, templated:templated))

            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
            }
        }.resume()

        return result
    }
}
