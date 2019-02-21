//  Copyright © 2016 Compass. All rights reserved.

import Foundation
import Dispatch

public protocol ObservableType {
    associatedtype T
    func subscribe(queue: DispatchQueue?, onNext: ((Self.T) -> Void)?, onError: ((Error) -> Void)?, onDone: (() -> Void)?)
    func on(_ event: Event<T>)
    func on(_ queue: DispatchQueue) -> Observable<Self.T>
    func removeSubscribers()
    func block() -> (result: Self.T?, error: Error?)
    func throttle(_ delay: TimeInterval) -> Observable<Self.T>
    func debounce(_ delay: TimeInterval) -> Observable<Self.T>
    func forward(to: Observable<Self.T>)
}
