import Foundation
import RxSwift


let dispatchGroup = DispatchGroup()
dispatchGroup.enter()

let task = findMyIP()
    .flatMap { syncCF(ip: $0) }
    .subscribe(onNext: { record in
        print("Sync success, ip now: \(record.content)")
    }, onError: { err in
        print("Update failed, error: \(err.localizedDescription)")
        dispatchGroup.leave()
    }, onCompleted: {
        dispatchGroup.leave()
    })

dispatchGroup.notify(queue: DispatchQueue.main) {
    exit(EXIT_SUCCESS)
}
dispatchMain()
