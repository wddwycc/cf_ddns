//
//  cf.swift
//  cf_ddns
//
//  Created by duan on 2018/12/16.
//

import Foundation
import RxSwift


struct Config: Codable {
    let zone: String
    let recordType: String
    let recordName: String
    let email: String
    let apiKey: String
}

fileprivate func fetchConfig() throws -> Config {
    let env = ProcessInfo.processInfo.environment
    let jsonData = try JSONSerialization.data(withJSONObject: env, options: .prettyPrinted)
    return try JSONDecoder().decode(Config.self, from: jsonData)
}

struct CFDNSUpdatePayload: Codable {
    let type: String
    let name: String
    let content: String
}

struct CFDNSRecord: Codable {
    let id: String
    let type: String
    let name: String
    let content: String
}

struct CFResp<T: Codable>: Codable {
    let success: Bool
    let result: T
}

enum CFRequestError: Error {
    case failed
    case noMatchedDNSRecord

    var localizedDescription: String {
        switch self {
        case .failed: return "CloudFlare request failed"
        case .noMatchedDNSRecord: return "Cannot find matched DNS Record on CloudFlare"
        }
    }
}

// Ref: https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records
fileprivate func fetchRecord() -> Observable<CFDNSRecord> {
    let config: Config
    do {
        config = try fetchConfig()
    } catch { return Observable.error(error) }

    let APIEntry = "https://api.cloudflare.com/client/v4/zones/\(config.zone)/dns_records"
    let prarms = ["name": config.recordName, "type": config.recordType]
    let headers = [
        "Content-Types": "application/json",
        "X-Auth-Email": config.email,
        "X-Auth-Key": config.apiKey,
    ]
    let req = genReq(url: APIEntry, params: prarms, headers: headers)
    return sendReq(req, decodeWith: CFResp<[CFDNSRecord]>.self)
        .map {
            guard $0.success else { throw CFRequestError.failed }
            guard let rv = $0.result.first else { throw CFRequestError.noMatchedDNSRecord }
            return rv
        }
}

// Ref: https://api.cloudflare.com/#dns-records-for-a-zone-update-dns-record
fileprivate func updateRecord(record: CFDNSRecord, ip: String) -> Observable<CFDNSRecord> {
    let config: Config
    do {
        config = try fetchConfig()
    } catch { return Observable.error(error) }

    let APIEntry = "https://api.cloudflare.com/client/v4/zones/\(config.zone)/dns_records"
    let headers = [
        "Content-Types": "application/json",
        "X-Auth-Email": config.email,
        "X-Auth-Key": config.apiKey,
    ]
    let payload = CFDNSUpdatePayload(type: record.type, name: record.name, content: ip)
    let req = genReq("PUT", url: "\(APIEntry)/\(record.id)", params: nil, headers: headers, payload: payload)
    return sendReq(req, decodeWith: CFResp<CFDNSRecord>.self)
        .map {
            guard $0.success else { throw CFRequestError.failed }
            return $0.result
        }
}


/// Update CloudFlare DNS Record's IP
///
/// - Parameter ip: ip to update
/// - Returns: updated DNS record item
func syncCF(ip: String) -> Observable<CFDNSRecord> {
    return fetchRecord()
        .flatMap { updateRecord(record: $0, ip: ip) }
}
