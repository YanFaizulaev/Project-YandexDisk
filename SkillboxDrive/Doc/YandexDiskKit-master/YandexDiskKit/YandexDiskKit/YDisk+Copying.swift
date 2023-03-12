//
//  YDisk+Copying.swift
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

    public enum CopyResult {
        case Done(href:String, method:String, templated:Bool)
        case InProcess(href:String, method:String, templated:Bool)
        case Failed(NSError!)
    }

    /// Copy file or folder
    ///
    /// :param: path        The path to the copy of the resource that is being created.
    ///   For example: `.Disk("/bar/photo.png")`.
    /// :param: fromPath    The path to the resource to copy.
    ///   For example: `.Disk("/foo/photo.png")`.
    /// :param: overwrite   Optional.
    ///   if `true` delete files with matching names and write the copied files.
    ///   if `false` specifies not to overwrite the files and to cancel copying.
    /// :param: handler     Optional.
    /// :returns: `CopyResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/copy.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/copy-docpage/`_.
    public func copyPath(path:Path, fromPath:Path, overwrite:Bool?=nil, handler:((result:CopyResult) -> Void)? = nil) -> Result<CopyResult> {
        let result = Result<CopyResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/resources/copy?path=\(path.toUrlEncodedString)&from=\(fromPath.toUrlEncodedString)"

        url.appendOptionalURLParameter("overwrite", value:overwrite)

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
