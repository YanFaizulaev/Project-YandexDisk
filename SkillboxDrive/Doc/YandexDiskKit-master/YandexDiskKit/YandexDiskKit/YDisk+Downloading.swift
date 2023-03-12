//
//  YDisk+Downloading.swift
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

    public enum DownloadResult {
        case Done
        case Failed(NSError!)
    }

    /// Downloads a resource from Yandex Disk.
    ///
    /// :param: path        Path to the resource which should be downloaded from Yandex Disk.
    /// :param: toURL       Local file path under which the file should be stored.
    /// :param: handler     Optional.
    /// :returns: `DownloadResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/content.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/content-docpage/`_.
    public func downloadPath(path:Path, toURL:NSURL, handler:((result:DownloadResult) -> Void)? = nil) -> Result<DownloadResult> {
        let url = "\(baseURL)/v1/disk/resources/download?path=\(path.toUrlEncodedString)"
        return _downloadURL(url, toURL: toURL, handler: handler)
    }

    func _downloadURL(url:String, toURL:NSURL, handler:((result:DownloadResult) -> Void)? = nil) -> Result<DownloadResult> {
        let result = Result<DownloadResult>(handler: handler)

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, errorHandler: error) {
            (jsonRoot, response)->Void in

            let (href, method, templated) = YandexDisk.hrefMethodTemplatedWithDictionary(jsonRoot)

            let request = NSMutableURLRequest()
            request.URL = NSURL(string: href)
            request.HTTPMethod = method

            self.transferSession.downloadTaskWithRequest(request) {
                (url, response, trasferError)->Void in

                if trasferError != nil {
                    return error(trasferError)
                }

                if let url = url {
                    let fm = NSFileManager.defaultManager()
                    var fmerror : NSError?

                    fm.copyItemAtURL(url, toURL: toURL, error: &fmerror)

                    if fmerror != nil {
                        return error(fmerror)
                    }
                }
                return result.set(.Done)
            }.resume()
        }.resume()

        return result
    }
}
