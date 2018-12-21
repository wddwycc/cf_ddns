import Foundation
import LoggerAPI

import RxSwift
import HeliumLogger


let logger = HeliumLogger(.info)
logger.format = "[(%date)] [(%type)] (%msg)"
Log.logger = logger

extension ObservableType {
    func catchErrorJustPrint() -> Observable<E> {
        return catchError { err in
            Log.error("Sync failed, error: \(err.localizedDescription)")
            return .never()
        }
    }
}

let task = Observable<Int>.interval(60, scheduler: MainScheduler.instance)
    .startWith(0)
    .flatMapLatest { _ in findMyIP().catchErrorJustPrint() }
    .flatMap { syncCF(ip: $0).catchErrorJustPrint() }
    .subscribe(onNext: { record in
        Log.info("Sync success, ip now: \(record.content)")
    })

RunLoop.main.run()
