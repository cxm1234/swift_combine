
//: [Previous](@previous)

import SwiftUI
import Combine
import PlaygroundSupport

let valuesPerSecond = 1.0
let collectTimeStride = 4
let collectMaxCount = 2

let sourcePublisher = PassthroughSubject<Date, Never>()
let collectedPubliser = sourcePublisher
    .collect(
        .byTime(DispatchQueue.main, .seconds(collectTimeStride)),
        options: nil
    )
    .flatMap { dates in dates.publisher }

let collectedPubliser2 = sourcePublisher
    .collect(
        .byTimeOrCount(DispatchQueue.main, .seconds(collectTimeStride), collectMaxCount)
    )
    .flatMap { dates in dates.publisher }

let subscription = Timer
    .publish(every: 1.0 / valuesPerSecond, on: .main , in: .common)
    .autoconnect()
    .subscribe(sourcePublisher)

let sourceTimeline = TimelineView(title: "Emitted values:")
let collectedTimeline = TimelineView(title: "Collected values (every \(collectTimeStride)s):")
let collectedTimeline2 = TimelineView(title: "Collected values (at most \(collectMaxCount) every \(collectTimeStride)s):")

let view = VStack(spacing: 40) {
    sourceTimeline
    collectedTimeline
    collectedTimeline2
}
    .padding()

PlaygroundPage.current.setLiveView(view)

sourcePublisher.displayEvents(in: sourceTimeline)
collectedPubliser.displayEvents(in: collectedTimeline)
collectedPubliser2.displayEvents(in: collectedTimeline2)

//: [Next](@next)




