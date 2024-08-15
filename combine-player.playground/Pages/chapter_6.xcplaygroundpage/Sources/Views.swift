import SwiftUI
import Combine

struct EventValueView: View {
    let index: Int
    var body: some View {
        Text("\(self.index)")
            .padding(3.0)
            .frame(width: 28.0, height: 28.0)
            .allowsTightening(true)
            .minimumScaleFactor(0.1)
            .foregroundColor(.white)
            .background(Circle().fill(Color.blue))
            .fixedSize()
    }
}

struct EventCompletedView: View {
    var body: some View {
        Rectangle()
            .frame(width: 4, height: 38.0)
            .offset(x: 0, y: -3)
            .foregroundColor(.gray)
    }
}

struct EventFailureView: View {
    var body: some View {
        Text("X")
            .padding(3.0)
            .frame(width: 28.0, height: 28.0)
            .foregroundColor(.white)
            .background(Circle().fill(Color.red))
    }
}

struct EventView: View {
    let event: CombineEvent
    
    var body: some View {
        switch self.event.event {
        case .value:
            return AnyView(EventValueView(index: self.event.index))
        case .completion:
            return AnyView(EventCompletedView())
        case .failure:
            return AnyView(EventFailureView())
        }
    }
}

struct SimultaneousEventsView: View {
    let events: [CombineEvent]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(0 ..< self.events.count) {
                EventView(event: self.events[$0])
            }
        }
    }
}

extension SimultaneousEventsView: Identifiable {
    var id: Int { return events[0].groupTime }
}

public struct TimelineView: View {
    @ObservedObject var time = DisplayTimer()
    let holder: EventsHolder
    let title: String
    
    var groupedEvents: [CombineEvents] {
        let d = Dictionary<Int, [CombineEvent]>(grouping: self.holder.events) { $0.groupTime }
        return d.keys.sorted().map { CombineEvents(events: d[$0]!.sorted { $0.index < $1.index })}
    }
    
    public init(title: String) {
        self.title = title
        self.holder = EventsHolder()
    }
    
    public init(title: String, events: [CombineEvent]) {
        self.title = title
        self.holder = EventsHolder(events: events)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.gray)
                    .offset(x: 0, y: 14)
                ForEach(groupedEvents) { group in
                    SimultaneousEventsView(events: group.events)
                        .offset(x: CGFloat(group.time) * 30.0 - self.time.current - 32, y: 0)
                }
            }
            .frame(minHeight: 32)
            .onReceive(time.objectWillChange, perform: { _ in
                if self.holder.events.contains(where: { $0.event != .value }) {
                    self.time.stop(after: 0.5)
                }
            })
        }
    }
    
    func capture<T,F>(publisher: AnyPublisher<T,F>) {
        let observer = AnySubscriber(receiveSubscription: { subscription in
            subscription.request(.unlimited)
        }, receiveValue: { (value: T) -> Subscribers.Demand in
            self.holder.capture(.value)
            return .unlimited
        }, receiveCompletion: { (completion: Subscribers.Completion<F>) in
            switch completion {
            case .finished:
                self.holder.capture(.completion)
            case .failure(let failure):
                self.holder.capture(.failure)
            }
        })
        publisher
            .subscribe(on: DispatchQueue.main)
            .subscribe(observer)
    }
}

public extension Publisher {
    func displayEvents(in view: TimelineView) {
        view.capture(publisher: self.eraseToAnyPublisher())
    }
}
