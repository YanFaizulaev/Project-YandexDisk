//
//  YDisk+CustomProperties.swift
//
//  Copyright (c) 2015, Clemens Auer
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

    public enum PatchCustomPropertiesResult {
        case Done(YandexDiskResource)
        case Failed(NSError!)
    }

    /// Assign custom property to file or folder
    ///
    /// :param: path        The path on which to set the custom property.
    ///   For example: `.Disk("/bar/photo.png")`.
    /// :param: name        The name of the custom property.
    ///   For example: `"copyright"`.
    /// :param: value       The value of the custom property.
    ///   It has to be an property list compatible object/structure.
    ///   ( `NSString`, `NSData`, `NSArray`, or `NSDictionary` ).
    ///   For example: `"Creative Commons 4"`.
    /// :param: handler     Optional.
    /// :returns: `PatchCustomPropertiesResult` future.
    ///
    /// API reference: **missing**
    public func setCustomProperty(path:Path, name: String, value: AnyObject, handler:((result:PatchCustomPropertiesResult) -> Void)? = nil) -> Result<PatchCustomPropertiesResult> {
        return patchCustomProperties(path, properties: [name: value], handler: handler)
    }

    /// Remove custom property from file or folder
    ///
    /// :param: path        The path on which to remove the custom property.
    ///   For example: `.Disk("/bar/photo.png")`.
    /// :param: name        The name of the custom property.
    ///   For example: `"copyright"`.
    /// :param: handler     Optional.
    /// :returns: `PatchCustomPropertiesResult` future.
    ///
    /// API reference: **missing**
    public func removeCustomProperty(path:Path, name: String, handler:((result:PatchCustomPropertiesResult) -> Void)? = nil) -> Result<PatchCustomPropertiesResult> {
        return setCustomProperty(path, name: name, value: NSNull(), handler: handler)
    }

    /// Patch custom property of file or folder
    ///
    /// :param: path        The path on which to set the custom property.
    ///   For example: `.Disk("/bar/photo.png")`.
    /// :param: properties  A dictionart of names and values which should be set.
    ///   Values have to be an property list compatible object/structure.
    ///   ( `NSString`, `NSData`, `NSArray`, or `NSDictionary` ).
    ///   To remove a property, set the value to `NSNull`.
    /// :param: handler     Optional.
    /// :returns: `PatchCustomPropertiesResult` future.
    ///
    /// API reference: **missing**
    public func patchCustomProperties(path:Path, var properties: NSDictionary, handler:((result:PatchCustomPropertiesResult) -> Void)? = nil) -> Result<PatchCustomPropertiesResult> {
        let result = Result<PatchCustomPropertiesResult>(handler: handler)

        var url = "\(baseURL)/v1/disk/resources?path=\(path.toUrlEncodedString)"

        let error = { result.set(.Failed($0)) }

        if properties["custom_properties"] == nil {
            properties = ["custom_properties": properties]
        }
        var anyError: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(properties, options: NSJSONWritingOptions.PrettyPrinted, error: &anyError)
        if anyError != nil {
            error(anyError)
            return result
        }

        session.jsonTaskWithURL(url, method: "PATCH", body: data, errorHandler: error) {
            (jsonRoot, response)->Void in

            let (href, method, templated) = YandexDisk.hrefMethodTemplatedWithDictionary(jsonRoot)

            switch response.statusCode {
            case 200:
                if let rootItem = SimpleResource.resourceFromDictionary(jsonRoot) {
                    return result.set(.Done(rootItem))
                }
                fallthrough
            default:
                return error(NSError(domain: "YDisk", code: response.statusCode, userInfo: ["response":response, "json":jsonRoot]))
            }
        }.resume()

        return result
    }
}
