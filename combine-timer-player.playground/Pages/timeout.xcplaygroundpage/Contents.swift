//: [Previous](@previous)

import SwiftUI
import Combine
import PlaygroundSupport

enum TimeoutError: Error {
    case timedOut
}

let subject = PassthroughSubject<Void, TimeoutError>()

let timeOutSubject = subject.timeout(.seconds(5), scheduler: DispatchQueue.main, customError: {.timeout})

let timeline = TimelineView(title: "Button taps")

let view = VStack(spacing: 100) {
    Button(action: { subject.send() }) {
        Text("Press me within 5 seconds")
    }
    timeline
}

timeOutSubject.displayEvents(in: timeline)

PlaygroundPage.current.setLiveView(view)

//: [Next](@next)
