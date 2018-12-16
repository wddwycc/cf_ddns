//
//  network.swift
//  cf_ddns
//
//  Created by duan on 2018/12/16.
//

import Foundation
import RxSwift


enum RequestError: Error {
    case decodeError
    case unknown

    var localizedDescription: String {
        switch self {
        case .decodeError:
            return "Server returned unknown data"
        case .unknown:
            return "Unkonwn error"
        }
    }
}

func genReq(_ method: String = "GET", url: String,
            params: [String: String]? = nil, headers: [String: String]? = nil) -> URLRequest {
    let url_: URL
    if let params = params {
        var urlComps = URLComponents(string: url)!
        urlComps.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        url_ = urlComps.url!
    } else {
        url_ = URL(string: url)!
    }
    var req = URLRequest(url: url_)
    req.httpMethod = method
    if let headers = headers {
        for (k, v) in headers {
            req.addValue(v, forHTTPHeaderField: k)
        }
    }
    return req
}

func genReq<T: Codable>(_ method: String = "GET", url: String,
                        params: [String: String]? = nil, headers: [String: String]? = nil,
                        payload: T) -> URLRequest {
    var req = genReq(method, url: url, params: params, headers: headers)
    req.httpBody = try? JSONEncoder().encode(payload)
    return req
}

func sendReq(_ req: URLRequest) -> Observable<Void> {
    return Observable.create({ (observer) -> Disposable in
        let task = URLSession.shared.dataTask(with: req) { (data, resp, err) in
            guard
                let resp = resp as? HTTPURLResponse,
                200..<300 ~= resp.statusCode
            else {
                observer.onError(err ?? RequestError.unknown)
                return
            }
            observer.onNext(())
            observer.onCompleted()
        }
        task.resume()
        return Disposables.create {
            task.cancel()
        }
    })
}

func sendReq<T: Codable>(_ req: URLRequest, decodeWith: T.Type) -> Observable<T> {
    return Observable.create({ (observer) -> Disposable in
        let task = URLSession.shared.dataTask(with: req) { (data, resp, err) in
            guard
                let resp = resp as? HTTPURLResponse,
                200..<300 ~= resp.statusCode,
                let data = data
            else {
                observer.onError(err ?? RequestError.unknown)
                return
            }
            do {
                let rv = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(rv)
                observer.onCompleted()
            } catch {
                observer.onError(RequestError.decodeError)
            }
        }
        task.resume()
        return Disposables.create {
            task.cancel()
        }
    })
}
