//
//  YDisk+PublicList.swift
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

    /// List metainfo for public file or folder.
    ///
    /// :param: key             Key to a public resource, or the public link to a resource.
    /// :param: path            Optional. Relative path to a resource in a public folder.
    ///   You can request metainformation for any resource in a folder by specifying the key of the same published folder in the public_key parameter.
    ///   For example, to see what's in the `/foo` folder inside a published folder, pass the parameter `/foo`.
    /// :param: sort            Optional. The attribute used for sorting the list of resources in the folder.
    /// :param: limit           Optional. The number of resources in the folder that should be described in the response (for example, for paginated output).
    /// :param: offset          Optional. The number of resources from the top of the list that should be skipped in the response (for example, for paginated output).
    /// :param: preview_size    Optional. Requested size for the previews.
    /// :param: preview_crop    Optional. If true, preview will be cropped to square.
    /// :param: handler         Optional.
    /// :returns: `ListingResult` future.
    ///
    /// API reference:
    ///   `english http://api.yandex.com/disk/api/reference/public.xml`_,
    ///   `russian https://tech.yandex.ru/disk/api/reference/public-docpage/`_.
    public func listPublic(key public_key:String, path:String?=nil, sort:SortKey?=nil, limit:Int?=nil, offset:Int?=nil, preview_size:PreviewSize?=nil, preview_crop:Bool?=nil, handler:((listing:ListingResult) -> Void)? = nil) -> Result<ListingResult> {

        var url = "\(baseURL)/v1/disk/public/resources?public_key=\(public_key.urlEncoded())"

        url.appendOptionalURLParameter("path", value:path)
        url.appendOptionalURLParameter("sort", value:sort)
        url.appendOptionalURLParameter("limit", value:limit)
        url.appendOptionalURLParameter("offset", value:offset)
        url.appendOptionalURLParameter("preview_size", value:preview_size)
        url.appendOptionalURLParameter("preview_crop", value:preview_crop)

        return _listURL(url, handler: handler)
    }
}
