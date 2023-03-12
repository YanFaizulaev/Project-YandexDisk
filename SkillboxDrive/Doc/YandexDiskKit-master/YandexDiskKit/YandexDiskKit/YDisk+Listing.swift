//
//  YDisk+Listing.swift
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

    public enum ListingResult {
        case File(YandexDiskResource)
        case Listing(dir:YandexDiskResource, limit:Int, offset:Int, total:Int, path:Path, sort:SortKey?, items:[YandexDiskResource] )
        case Failed(NSError!)
    }

    /// List metainfo for file or folder.
    ///
    /// :param: path            The path to the desired resource. For example: `.Disk("/foo/bar.txt")`, `.App("file.ext")`, or `.Trash("/")`.
    /// :param: sort            Optional. The attribute used for sorting the list of resources in the folder.
    /// :param: limit           Optional. The number of resources in the folder that should be described in the response (for example, for paginated output).
    /// :param: offset          Optional. The number of resources from the top of the list that should be skipped in the response (for example, for paginated output).
    /// :param: preview_size    Optional. Requested size for the previews.
    /// :param: preview_crop    Optional. If true, preview will be cropped to square.
    /// :param: handler         Optional.
    /// :returns: `ListingResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/meta.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/meta-docpage/`_.
    public func listPath(path:Path, sort:SortKey?=nil, limit:Int?=nil, offset:Int?=nil, preview_size:PreviewSize?=nil, preview_crop:Bool?=nil, handler:((listing:ListingResult) -> Void)? = nil) -> Result<ListingResult> {

        var url : String

        switch path {
        case .App, .Disk:
            url = "\(baseURL)/v1/disk/resources?path=\(path.toUrlEncodedString)"
        case .Trash:
            url = "\(baseURL)/v1/disk/trash/resources/?path=\(path.toUrlEncodedString)"
        }

        url.appendOptionalURLParameter("sort", value:sort)
        url.appendOptionalURLParameter("limit", value:limit)
        url.appendOptionalURLParameter("offset", value:offset)
        url.appendOptionalURLParameter("preview_size", value:preview_size)
        url.appendOptionalURLParameter("preview_crop", value:preview_crop)

        return _listURL(url, handler:handler)
    }

    func _listURL(url:String, handler:((listing:ListingResult) -> Void)? = nil) -> Result<ListingResult> {
        let result = Result<ListingResult>(handler: handler)

        let error = { result.set(.Failed($0)) }

        session.jsonTaskWithURL(url, errorHandler: error) {
            (jsonRoot, response)->Void in

            switch response.statusCode {
            case 200:
                var rootItem = SimpleResource.resourceFromDictionary(jsonRoot)

                if let rootItem = rootItem {
                    switch rootItem.type {
                    case .File:
                        return result.set(.File(rootItem))

                    case .Directory:

                        if let embedded = jsonRoot["_embedded"] as? NSDictionary,
                            path_str = embedded["path"] as? String,
                            sort_str = embedded["sort"] as? String,
                            limit_nr = embedded["limit"] as? NSNumber,
                            offset_nr = embedded["offset"] as? NSNumber,
                            total_nr = embedded["total"] as? NSNumber,
                            items = SimpleResource.resourcesFromArray(embedded["items"] as? NSArray)
                        {
                            let path    = Path.pathWithString(path_str)
                            let limit   = limit_nr.integerValue
                            let offset  = offset_nr.integerValue
                            let total   = total_nr.integerValue
                            let sort    = SortKey(rawValue: sort_str)
                            return result.set(.Listing(dir: rootItem, limit: limit, offset: offset, total: total, path: path, sort: sort, items: items))
                        } else {
                            return error(NSError(domain: "YDisk", code: response.statusCode, userInfo:
                                ["message":"incomplete JSON response", "json":jsonRoot]))
                        }
                    }
                } else {
                    return error(NSError(domain: "YDisk", code: response.statusCode, userInfo:
                        ["message":"incomplete JSON response", "json":jsonRoot]))
                }

            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response]))
            }
        }.resume()

        return result
    }
}
