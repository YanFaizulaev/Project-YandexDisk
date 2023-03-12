//
//  YDisk+Uploading.swift
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

    public enum UploadResult {
        case Done
        case InProcess(href:String, method:String, templated:Bool)
        case Failed(NSError!)
    }

    /// Uploads a file to Yandex Disk.
    ///
    /// Uploads the file at sourceURL to Yandex Disk. This should either be a file URL, in which
    /// case the file will be uploaded to the location given by the Disk API. Otherwise sourceURL
    /// should point to a publically available resoure in internet from where Yandex servers will
    /// fetch the file for you.
    ///
    /// :param: sourceURL   File or web URL of the file which should be stored to Yandex Disk.
    /// :param: toPath      Path under which the file should be stored.
    /// :param: overwrite   Optional. If an existing file should be overwritten or not.
    /// :param: handler     Optional.
    /// :returns: `UploadResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/upload.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/upload-docpage/`_.
    ///   and `https://tech.yandex.ru/disk/api/reference/upload-ext-docpage/`_
    public func uploadURL(sourceURL:NSURL, toPath path:Path, overwrite:Bool?=nil, handler:((result:UploadResult) -> Void)? = nil) -> Result<UploadResult> {
        let result = Result<UploadResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/resources/upload?path=\(path.toUrlEncodedString)"

        assert(sourceURL.fileURL || overwrite == nil, "Current version of the API supports 'overwrite' only for file uploads.")
        url.appendOptionalURLParameter("overwrite", value:overwrite)

        let error = { result.set(.Failed($0)) }

        if sourceURL.fileURL {
            session.jsonTaskWithURL(url, errorHandler: error) {
                (jsonRoot, response)->Void in

                let (href, method, templated) = YandexDisk.hrefMethodTemplatedWithDictionary(jsonRoot)

                let request = NSMutableURLRequest()
                request.URL = NSURL(string: href)
                request.HTTPMethod = method

                self.transferSession.uploadTaskWithRequest(request, fromFile: sourceURL) {
                    (data, resopnse, trasferError)->Void in

                    if trasferError != nil {
                        return error(trasferError)
                    }
                    return result.set(.Done)
                }.resume()
            }.resume()
        } else {
            url += "&url=\(sourceURL.description.urlEncoded())"

            session.jsonTaskWithURL(url, method:"POST", errorHandler: error) {
                (jsonRoot, response)->Void in

                let (href, method, templated) = YandexDisk.hrefMethodTemplatedWithDictionary(jsonRoot)

                switch response.statusCode {
                case 202:
                    return result.set(.InProcess(href:href, method:method, templated:templated))

                default:
                    return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
                }
            }.resume()
        }

        return result
    }
}
