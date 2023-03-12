//
//  YDisk+Trash.swift
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

    public enum RestoreResult {
        case Done(href:String, method:String, templated:Bool)
        case InProcess(href:String, method:String, templated:Bool)
        case Failed(NSError!)
    }

    /// Restores resource from trash.
    ///
    /// :param: path        The path to the resource to restore is relative to the Trash root directory.
    ///   For example: `.Trash("/bar/photo.png")`.
    /// :param: name        Optional. The new name of the resource being restored. For example, `"selfie.png"`
    /// :param: overwrite   Optional.
    ///   if `true` the name is already used be another resource, it will be overwritten.
    ///   if 'false' and the name is already used, the operation will fail.
    /// :param: handler     Optional.
    /// :returns: `RestoreResult` future.
    ///
    /// API reference for ordinary resources:
    ///   `english http://api.yandex.com/disk/api/reference/trash-restore.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/trash-restore-docpage/`_.
    ///
    /// Note: If the file being restored was previously located inside a folder that does not exist at the time of the request,
    ///   a folder with the same name will be created in the appropriate location.
    /// Warning: If `name` is not a plain file/folder name but a path like string,
    ///   the result will be unexpected. In such cases no error is returned, but
    ///   the last path component is used as name.
    public func restorePath(path:Path, name:String?=nil, overwrite:Bool?=nil, handler:((result:RestoreResult) -> Void)? = nil) -> Result<RestoreResult> {
        let result = Result<RestoreResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/trash/resources/restore?path=\(path.toUrlEncodedString)"

        url.appendOptionalURLParameter("name", value:name)
        url.appendOptionalURLParameter("overwrite", value:overwrite)

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, method:"PUT", errorHandler: error) {
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
