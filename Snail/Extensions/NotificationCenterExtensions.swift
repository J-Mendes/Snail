//  Copyright © 2016 Compass. All rights reserved.

import Foundation

extension NotificationCenter {
    private static var observableKey = "ObservableKey"

    func observableHandler(_ notification: NSNotification) {
        if let observable = objc_getAssociatedObject(self, &NotificationCenter.observableKey) as? Observable<NSNotification> {
            observable.on(.next(notification))
        }
    }

    func observeEvent(_ name: NSNotification.Name?) -> Observable<NSNotification> {
        let observable = Observable<NSNotification>()
        objc_setAssociatedObject(self, &NotificationCenter.observableKey, observable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addObserver(self, selector: #selector(observableHandler(_:)), name: name, object: nil)
        return observable
    }
}
