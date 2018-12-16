//
//  ipcheck.swift
//  cf_ddns
//
//  Created by duan on 2018/12/16.
//

import Foundation
import RxSwift


fileprivate let APIEntry = "https://api-ipv4.ip.sb/jsonip"
fileprivate struct APIResp: Codable {
    let ip: String
}

func findMyIP() -> Observable<String> {
    let req = genReq(url: APIEntry)
    return sendReq(req, decodeWith: APIResp.self).map { $0.ip }
}
