//
//  YDisk+PreviewSize.swift
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

    public enum PreviewSize : Printable {
        case S
        case M
        case L
        case XL
        case XXL
        case XXXL
        case Width(width: UInt)
        case Height(height: UInt)
        case Size(width: UInt, height: UInt)

        public var stringValue : String {
            switch self {
            case .S:    return "S"
            case .M:    return "M"
            case .L:    return "L"
            case .XL:   return "XL"
            case .XXL:  return "XXL"
            case .XXXL: return "XXXL"
            case let .Width(width: w): return "\(w)x"
            case let .Height(height: h):   return "x\(h)"
            case let .Size(width: w, height: h):    return "\(w)x\(h)"
            }
        }

        /// Required by protocol Printable
        public var description: String {
            return self.stringValue
        }
    }
}
