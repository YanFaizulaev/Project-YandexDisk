//
//  YDisk+Version.swift
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

    public enum APIVersionResult {
        case Done(build: String, version: String)
        case Failed(NSError!)
    }

    /// Yandex Disk API version and build implemented.
    ///
    /// This returns the highest version of yandex disk API which is fully implemented in this SDK.
    ///
    /// :returns: The tuple `(build: String, version: String)`
    public func apiVersionImplemented() -> (build: String, version: String) {
        return (build: "2.6.37", version: "v1")
    }

    /// Yandex Disk backend API version and build.
    ///
    /// :param: handler     Optional.
    /// :returns: `APIVersionResult` future.
    ///
    /// API reference: *undocumented*
    public func apiVersion(handler:((result:APIVersionResult) -> Void)? = nil) -> Result<APIVersionResult> {
        let result = Result<APIVersionResult>(handler: handler)

        var url = "\(baseURL)/"

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, errorHandler: error) {
            (jsonRoot, response)->Void in

            switch response.statusCode {
            case 200:
                if let build = jsonRoot["build"] as? String,
                    version = jsonRoot["api_version"] as? String
                {
                    return result.set(.Done(build: build, version: version))
                } else {
                    return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response, "json":jsonRoot]))
                }

            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
            }
        }.resume()

        return result
    }
}
