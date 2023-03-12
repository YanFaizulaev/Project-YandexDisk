//
//  YDisk+Operations.swift
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

    public enum OperationsResult {
        case Status(String)
        case Failed(NSError!)
    }

    /// Operation status.
    ///
    /// :param: opId        Operation Id for which the status should be checked.
    ///   if `true` delete files with matching names and write the moved files.
    ///   if `false` specifies not to overwrite the files and to cancel moving.
    /// :param: handler     Optional.
    /// :returns: `OperationsResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/operations.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/operations-docpage/`_.
    public func operationStatusWithId(opId:String, handler:((result:OperationsResult) -> Void)? = nil) -> Result<OperationsResult> {
        var requestUrl = "\(baseURL)/v1/disk/operations/\(opId)"
        return operationStatusWithHref(requestUrl, handler: handler)
    }

    /// Operation status.
    ///
    /// :param: href        HREF as provided in .InProcess() responses.
    ///   if `true` delete files with matching names and write the moved files.
    ///   if `false` specifies not to overwrite the files and to cancel moving.
    /// :param: handler     Optional.
    /// :returns: `OperationsResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/operations.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/operations-docpage/`_.
    public func operationStatusWithHref(href:String, handler:((result:OperationsResult) -> Void)? = nil) -> Result<OperationsResult> {
        let result = Result<OperationsResult>(handler: handler)

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(href, errorHandler: error) {
            (jsonRoot, response)->Void in

            switch response.statusCode {
            case 200:
                if let str = jsonRoot["status"] as? String {
                    return result.set(.Status(str))
                } else {
                    return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["message":"Missing 'status' in json reply."]))
                }
            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
            }
        }.resume()

        return result
    }
}
