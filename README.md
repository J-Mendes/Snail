# 🐌 snail ![CircleCI](https://circleci.com/gh/UrbanCompass/Snail/tree/master.svg?style=shield&circle-token=02af7805c3430ec7945e0895b2108b4d9b348e85) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![codecov.io](https://codecov.io/gh/UrbanCompass/snail/branch/master/graphs/badge.svg)

[![SNAIL](https://img.youtube.com/vi/u4QAnCFd4iw/0.jpg)](https://www.youtube.com/watch?v=u4QAnCFd4iw)

## Creating Observables

```swift
let observable = Observable<thing>()
```

## Subscribing to Observables

### Using closures
```swift
observable.subscribe(
    onNext: { thing in ... }, // do something with thing
    onError: { error in ... }, // do something with error
    onDone: { ... } //do something when it's done
)
```

Closures are optional too...

```swift
observable.subscribe(
    onNext: { thing in ... } // do something with thing
)
```

```swift
observable.subscribe(
    onError: { error in ... } // do something with error
)
```

### Using raw event
```swift
observable.subscribe { event in
    switch event {
    case .next(let thing):
        // do something with thing
    case .error(let error):
        // do something with error
    case .done:
        // do something when it's done
    }
}
```

## Creating Observables Variables

```swift
let variable = Variable<whatever>(some initial value)
```

```swift
let optionalString = Variable<String?>(nil)
optionalString.asObservable().subscribe(
    onNext: { string in ... } // do something with value changes
)

optionalString.value = "something"
```

```swift
let int = Variable<Int>(12)
int.asObservable().subscribe(
    onNext: { int in ... } // do something with value changes
)

int.value = 42
```

## Miscellaneous Observables

```swift
let just = Just(1) // always returns the initial value (1 in this case)

enum TestError: Error {
  case test
}
let failure = Fail(TestError.test) //always fail with error

let n = 5
let replay = Replay(n) // replays the last N events when a new observer subscribes
```

## Subscribing to Control Events

```swift
let control = UIControl()
control.controlEvent(.touchUpInside).subscribe(
  onNext: { ... }  // do something with thing
)

let button = UIButton()
button.tap.subscribe(
  onNext: { ... }  // do something with thing
)
```

## Queues

You can specify which queue an observables will be notified on by using `.subscribe(queue: <desired queue>)`. If you don't specify, then the observable will be notified on the same queue that the observable published on.

There are 3 scenarios:

1. You don't specify the queue. Your observer will be notified on the same thread as the observable published on.

2. You specified `main` queue AND the observable published on the `main` queue. Your observer will be notified synchronously on the `main` queue.

3. You specified a queue. Your observer will be notified async on the specified queue.


## Weak self

To avoid retain cycles and/or crashes, always use `[weak self]` when self is needed by an observer

```swift
observable.subscribe(onNext: { [weak self] in
    // use self? as needed.
})
```

### Examples

Subscribing on `DispatchQueue.main`

```swift
observable.subscribe(queue: .main,
    onNext: { thing in ... }
)

observable.subscribe(queue: .main) { event in
    ...
}
```
