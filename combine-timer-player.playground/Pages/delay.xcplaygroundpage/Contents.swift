//: [Previous](@previous)

import SwiftUI
import Combine
import PlaygroundSupport

let valuesPerSecond = 1.0
let delayInSeconds = 1.5

let sourcePubliser = PassthroughSubject<Date, Never>()

let delayedPubliser = sourcePubliser.delay(for: .seconds(delayInSeconds), scheduler: DispatchQueue.main)

let subscription = Timer
    .publish(every: 1.0 / valuesPerSecond, on: .main
             , in: .common)
    .autoconnect()
    .subscribe(sourcePubliser)

let sourceTimeline = TimelineView(title: "Emitted values (\(valuesPerSecond) per sec.):")

let delayedTimeline = TimelineView(title: "Delayed values (with a \(delayInSeconds)s delay):")

let view = VStack(spacing: 50) {
    sourceTimeline
    delayedTimeline
}

sourcePubliser.displayEvents(in: sourceTimeline)
delayedPubliser.displayEvents(in: delayedTimeline)

PlaygroundPage.current.setLiveView(view)

//: [Next](@next)
