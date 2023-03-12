//
//  YDisk.swift
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

/// A Class that provides access to the Yandex Disk REST API
///
/// Background session support:
/// 
/// To use a dedicated background session for up- and downloads, assign meaningful values to:
/// - transferSessionIdentifier
/// - transferSessionDelegate
///
/// optionally it is possible to specify the queue in which background transfers are processed.
/// - transferSessionQueue
///
public class YandexDisk {

    public let token : String
    public let baseURL = "https://cloud-api.yandex.net:443"

    /// MARK: - URL Session related

    var additionalHTTPHeaders : [String:String] {
        return [
            "Accept"        :   "application/json",
            "Authorization" :   "OAuth \(token)",
            "User-Agent"    :   "Yandex Disk swift SDK"]
    }

    public lazy var session : NSURLSession = {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = self.additionalHTTPHeaders
        sessionConfig.HTTPShouldUsePipelining = true

        let _session = NSURLSession(configuration: sessionConfig)
        return _session
    }()

    private var _transferSession : NSURLSession?
    public var transferSession : NSURLSession {
        if _transferSession != nil {
            return _transferSession!
        } else if transferSessionIdentifier != nil && transferSessionDelegate != nil {
            let transferSessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(transferSessionIdentifier!)
            transferSessionConfig.HTTPAdditionalHeaders = additionalHTTPHeaders
            transferSessionConfig.HTTPShouldUsePipelining = true

            let queue = transferSessionQueue ?? NSOperationQueue.mainQueue()
            _transferSession = NSURLSession(configuration: transferSessionConfig, delegate: transferSessionDelegate, delegateQueue: queue)
            return _transferSession!
        } else {
            return session
        }
    }

    public var transferSessionIdentifier: String?
    public var transferSessionDelegate: NSURLSessionDownloadDelegate?
    public var transferSessionQueue : NSOperationQueue?

    public init(token:String) {
        self.token = token
    }

}
