import Foundation
import LoggerAPI

import RxSwift
import HeliumLogger


HeliumLogger.use(.info)

let dispatchGroup = DispatchGroup()
dispatchGroup.enter()

let task = findMyIP()
    .flatMap { syncCF(ip: $0) }
    .subscribe(onNext: { record in
        Log.info("Sync success, ip now: \(record.content)")
    }, onError: { err in
        Log.error("Sync failed, error: \(err.localizedDescription)")
        dispatchGroup.leave()
    }, onCompleted: {
        dispatchGroup.leave()
    })

dispatchGroup.notify(queue: DispatchQueue.main) {
    exit(EXIT_SUCCESS)
}
dispatchMain()
