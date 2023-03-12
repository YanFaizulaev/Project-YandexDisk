//
//  YDisk+Deleting.swift
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

    public enum DeletionResult {
        case Done
        case InProcess(href:String, method:String, templated:Bool)
        case Failed(NSError!)
    }

    /// Empties the trash.
    ///
    /// :param: handler     Optional.
    /// :returns: `DeletionResult` future.
    ///
    /// API reference resources:
    ///   `english http://api.yandex.com/disk/api/reference/trash-delete.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/trash-delete-docpage/`_.
    public func emptyTrash(handler:((result:DeletionResult) -> Void)? = nil) -> Result<DeletionResult> {
        return deletePath(.Trash(""), handler: handler)
    }

    /// Delete file or folder
    ///
    /// :param: path        The path to the resource to delete. For example, `/foo/photo.png`.
    /// :param: permanently Optional.
    ///   if `true` the file or folder is deleted without being put in the Trash.
    ///   if 'false' the deleted file or folder is moved to the Trash.
    /// :param: handler     Optional.
    /// :returns: `DeletionResult` future.
    ///
    /// API reference for ordinary resources:
    ///   `english http://api.yandex.com/disk/api/reference/delete.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/delete-docpage/`_.
    /// API reference for trashed resources:
    ///   `english http://api.yandex.com/disk/api/reference/trash-delete.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/trash-delete-docpage/`_.
    public func deletePath(path:Path, permanently:Bool?=nil, handler:((result:DeletionResult) -> Void)? = nil) -> Result<DeletionResult> {
        let result = Result<DeletionResult>(handler: handler)

        var url : String

        switch path {
        case .App, .Disk:
            url = "\(baseURL)/v1/disk/resources?path=\(path.toUrlEncodedString)"

            url.appendOptionalURLParameter("permanently", value:permanently)
        case .Trash:
            url = "\(baseURL)/v1/disk/trash/resources/?path=\(path.toUrlEncodedString)"

            assert(permanently==nil, "Trash resources do not support parameter \'permanently\'.")
        }

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, method:"DELETE", errorHandler: error) {
            (jsonRoot, response)->Void in

            switch response.statusCode {
            case 202:
                return result.set(.InProcess(YandexDisk.hrefMethodTemplatedWithDictionary(jsonRoot)))

            case 204:
                return result.set(.Done)

            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
            }
        }.resume()

        return result
    }
}
