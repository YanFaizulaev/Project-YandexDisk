//
//  YDisk+LastUploaded.swift
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

    public enum LastUploadedResult {
        case Listing(limit:Int, items:[YandexDiskResource] )
        case Failed(NSError!)
    }

    public enum MediaType : String, Printable {
        case Audio = "audio"
        case Backup = "backup"
        case Book = "book"
        case Compressed = "compressed"
        case Data = "data"
        case Development = "development"
        case DiskImage = "diskimage"
        case Document = "document"
        case Encoded = "encoded"
        case Executable = "executable"
        case Flash = "flash"
        case Font = "font"
        case Image = "image"
        case Settings = "setings"
        case Spreadsheet = "spreadsheet"
        case Text = "text"
        case Unknown = "unknown"
        case Video = "video"
        case Web = "web"

        /// Required by protocol Printable
        public var description: String {
            return self.rawValue
        }
    }

    /// List latest uploaded files.
    ///
    /// :param: limit           Optional. The number of recently uploaded files that should be described in the response (for example, for paginated output).
    /// :param: type            Optional. The type of files to included in the list. Each file type is detected by Disk when uploading.
    /// :param: preview_size    Optional. Requested size for the previews.
    /// :param: preview_crop    Optional. If true, preview will be cropped to square.
    /// :param: handler         Optional.
    /// :returns: `LastUploadedResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/recent-upload.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/recent-upload-docpage/`_.
    public func lastUploaded(limit:Int? = nil, type:MediaType? = nil, preview_size:PreviewSize?=nil, preview_crop:Bool?=nil, handler:((listing:LastUploadedResult) -> Void)? = nil) -> Result<LastUploadedResult> {
        let result = Result<LastUploadedResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/resources/last-uploaded"

        url.appendOptionalURLParameter("limit", value:limit)
        url.appendOptionalURLParameter("media_type", value:type)
        url.appendOptionalURLParameter("preview_size", value:preview_size)
        url.appendOptionalURLParameter("preview_crop", value:preview_crop)

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, errorHandler: error) {
            (jsonRoot, response)->Void in

            switch response.statusCode {
            case 200:

                let limit = (jsonRoot["limit"] as? NSNumber)?.integerValue ?? 0
                if let elements = SimpleResource.resourcesFromArray(jsonRoot["items"] as? NSArray) {
                    return result.set(.Listing(limit: limit, items: elements))
                }
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["message":"incomplete JSON response", "json":jsonRoot]))

            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
            }
        }.resume()

        return result
    }
}
