//  Copyright © 2016 Compass. All rights reserved.

import Foundation
import XCTest
@testable import Snail

class FailTests: XCTestCase {
    enum TestError: Error {
        case test
    }

    private var subject: Observable<String>?
    private var strings: [String]?
    private var error: Error?
    private var done: Bool?

    override func setUp() {
        super.setUp()
        subject = Fail(TestError.test)
        strings = []
        error = nil
        done = nil

        subject?.subscribe(
            queue: nil,
            onNext: { [weak self] in self?.strings?.append($0) },
            onError: { self.error = $0 },
            onDone: { self.done = true }
        )
    }

    func testOnErrorIsRun() {
        XCTAssertEqual((error as? TestError), TestError.test)
    }

    func testOnNextIsNotRun() {
        subject?.on(.next("1"))
        XCTAssertEqual(strings?.count, 0)
    }

    func testOnDoneIsNotRun() {
        XCTAssertNil(done)
    }

    func testFiresStoppedEventOnSubscribe() {
        var newError: Error?
        done = nil

        subject?.subscribe(
            onError: { error in newError = error },
            onDone: { self.done = true }
        )

        XCTAssertNotNil(newError as? TestError)
        XCTAssertEqual(newError as? TestError, error as? TestError)
        XCTAssertNil(done)
    }
}
