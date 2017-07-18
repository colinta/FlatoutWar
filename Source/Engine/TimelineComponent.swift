////
///  TimelineComponent.swift
//

let DefaultDelay: CGFloat = 3

class TimelineComponent: Component {
    struct CancellableWrapper {
        let timeline: TimelineComponent

        func every(_ interval: ClosedRange<CGFloat>, start: TimeDescriptor = .after(0), block: @escaping Block) -> Block {
            let event = timeline.every(interval, start: start, block: block)
            return { self.timeline.removeEvent(event)}
        }

        func at(_ scheduledTime: TimeDescriptor, block: @escaping Block) -> Block {
            let event = Event(scheduledTime: scheduledTime.toTime(timeline.time), block: block)
            timeline.addEvent(event)
            return { self.timeline.removeEvent(event) }
        }

        func after(time scheduledTime: CGFloat, block: @escaping Block) -> Block {
            let event = Event(scheduledTime: timeline.time + scheduledTime, block: block)
            timeline.addEvent(event)
            return { self.timeline.removeEvent(event) }
        }

        func when(_ condition: @escaping ConditionBlock, block: @escaping Block) -> Block {
            let event = ConditionEvent(condition: condition, block: block)
            timeline.addEvent(event)
            return { self.timeline.removeEvent(event) }
        }

    }

    lazy var cancellable: CancellableWrapper = { return CancellableWrapper(timeline: self) }()

    enum TimeDescriptor: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
        init(integerLiteral time: Int) {
            self = .at(CGFloat(time))
        }
        init(floatLiteral time: Float) {
            self = .at(CGFloat(time))
        }
        static func Delayed(_ dt: CGFloat = 0) -> TimeDescriptor {
            return .after(dt + DefaultDelay)
        }

        case at(CGFloat)
        case after(CGFloat)
        case now

        func toTime(_ now: CGFloat) -> CGFloat {
            switch self {
            case let .at(t):
                return t
            case let .after(dt):
                return now + dt
            case .now:
                return now
            }
        }
    }

    class RecurringEvent: FinishableEvent {
        let uuid = NSUUID()
        var countdown: CGFloat
        let generator: () -> CGFloat
        let startAt: CGFloat
        let until: ConditionBlock
        var lastRun: CGFloat = 0
        let block: Block
        var finallyBlock: Block = {}

        init(countdown: CGFloat, generator: @escaping () -> CGFloat, startAt: CGFloat, until: @escaping ConditionBlock, block: @escaping Block) {
            self.countdown = countdown
            self.generator = generator
            self.startAt = startAt
            self.until = until
            self.block = block
        }

        convenience init() {
            self.init(countdown: 0, generator: { return 0 }, startAt: 0, until: { return false }, block: {})
        }
    }

    class Event: FinishableEvent {
        let uuid = NSUUID()
        let scheduledTime: CGFloat
        let block: Block
        var finallyBlock: Block = {}

        init(scheduledTime: CGFloat, block: @escaping Block) {
            self.scheduledTime = scheduledTime
            self.block = block
        }
    }

    class ConditionEvent: FinishableEvent {
        let uuid = NSUUID()
        let condition: ConditionBlock
        let block: Block
        var finallyBlock: Block = {}

        init(condition: @escaping ConditionBlock, block: @escaping Block) {
            self.condition = condition
            self.block = block
        }
    }

    var time: CGFloat = 0

    typealias StopRecurringBlock = Block

    private var running = false
    private var events: [Event] = []
    private var recurringEvents: [RecurringEvent] = []
    private var conditionEvents: [ConditionEvent] = []
    private var newEvents: [Event] = []
    private var newRecurringEvents: [RecurringEvent] = []
    private var newConditionEvents: [ConditionEvent] = []

    override func reset() {
        super.reset()
        events.removeAll()
        recurringEvents.removeAll()
        conditionEvents.removeAll()
        newEvents.removeAll()
        newRecurringEvents.removeAll()
        newConditionEvents.removeAll()
    }

    private func removeEvent(_ event: Event) {
        newEvents.removeMatches { $0.uuid == event.uuid }
        events.removeMatches { $0.uuid == event.uuid }
    }
    private func removeEvent(_ event: RecurringEvent) {
        newRecurringEvents.removeMatches { $0.uuid == event.uuid }
        recurringEvents.removeMatches { $0.uuid == event.uuid }
    }
    private func removeEvent(_ event: ConditionEvent) {
        newConditionEvents.removeMatches { $0.uuid == event.uuid }
        conditionEvents.removeMatches { $0.uuid == event.uuid }
    }

    private func addEvent(_ event: Event) {
        if running {
            newEvents << event
        }
        else {
            events << event
        }
    }

    private func addEvent(_ event: RecurringEvent) {
        if running {
            newRecurringEvents << event
        }
        else {
            recurringEvents << event
        }
    }

    private func addEvent(_ event: ConditionEvent) {
        if running {
            newConditionEvents << event
        }
        else {
            conditionEvents << event
        }
    }

    @discardableResult
    func at(_ scheduledTime: TimeDescriptor, block: @escaping Block) -> Event {
        let event = Event(scheduledTime: scheduledTime.toTime(time), block: block)
        addEvent(event)
        return event
    }

    @discardableResult
    func after(time scheduledTime: CGFloat, block: @escaping Block) -> Event {
        let event = Event(scheduledTime: time + scheduledTime, block: block)
        addEvent(event)
        return event
    }

    @discardableResult
    func when(_ condition: @escaping ConditionBlock, block: @escaping Block) -> ConditionEvent {
        let event = ConditionEvent(condition: condition, block: block)
        addEvent(event)
        return event
    }

    @discardableResult
    func every(_ interval: CGFloat, start: TimeDescriptor = .after(0), block: @escaping Block) -> RecurringEvent {
        return _every({ return interval }, start: start, until: { return false }, block: block)
    }

    @discardableResult
    func every(_ interval: CGFloat, start: TimeDescriptor = .after(0), times: Int, block: @escaping Block) -> RecurringEvent {
        var c = times
        let wrappedBlock: Block = {
            block()
            c -= 1
        }
        let untilBlock: ConditionBlock = { return c <= 0 }
        return _every({ return interval }, start: start, until: untilBlock, block: wrappedBlock)
    }

    @discardableResult
    func every(_ interval: CGFloat, start: TimeDescriptor = .after(0), until untilBlock: @escaping ConditionBlock, block: @escaping Block) -> RecurringEvent {
        return _every({ return interval }, start: start, until: untilBlock, block: block)
    }

    @discardableResult
    func every(_ interval: ClosedRange<CGFloat>, start: TimeDescriptor = .after(0), block: @escaping Block) -> RecurringEvent {
        return every(interval, start: start, until: { return false}, block: block)
    }

    @discardableResult
    func every(_ interval: ClosedRange<CGFloat>, start: TimeDescriptor = .after(0), times: Int, block: @escaping Block) -> RecurringEvent {
        guard times > 0 else { return RecurringEvent() }

        let min = interval.lowerBound
        let max = interval.upperBound
        var c = times
        let wrappedBlock: Block = {
            block()
            c -= 1
        }
        let untilBlock: ConditionBlock = { return c <= 0 }
        return _every({ return rand(min: min, max: max) }, start: start, until: untilBlock, block: wrappedBlock)
    }

    @discardableResult
    func every(_ interval: ClosedRange<CGFloat>, start: TimeDescriptor = .after(0), until untilBlock: @escaping ConditionBlock, block: @escaping Block) -> RecurringEvent {
        let min = interval.lowerBound
        let max = interval.upperBound
        return _every({ return rand(min: min, max: max) }, start: start, until: untilBlock, block: block)
    }

    private func _every(_ generator: @escaping () -> CGFloat, start: TimeDescriptor = .after(0), until untilBlock: @escaping ConditionBlock, block: @escaping Block) -> RecurringEvent {
        let entry: RecurringEvent = RecurringEvent(countdown: 0, generator: generator, startAt: start.toTime(time), until: untilBlock, block: block)
        addEvent(entry)

        return entry
    }

    func stop() {
        self.enabled = false
    }

    override func update(_ dt: CGFloat) {
        running = true
        time += dt

        for event in self.events {
            if time >= event.scheduledTime {
                event.block()
                event.finallyBlock()
            }
            else {
                newEvents << event
            }
        }
        self.events = newEvents
        newEvents.removeAll()

        for event in self.recurringEvents {
            if event.until() {
                event.finallyBlock()
                continue
            }

            if time < event.startAt {
                newRecurringEvents << event
                continue
            }

            if event.lastRun + dt >= event.countdown {
                event.block()
                event.lastRun = 0
                event.countdown = event.generator()
                newRecurringEvents << event
            }
            else {
                event.lastRun += dt
                newRecurringEvents << event
            }
        }
        self.recurringEvents = newRecurringEvents
        newRecurringEvents.removeAll()

        for event in self.conditionEvents {
            if event.condition() {
                event.block()
                event.finallyBlock()
            }
            else {
                newConditionEvents << event
            }
        }
        self.conditionEvents = newConditionEvents
        newConditionEvents.removeAll()

        running = false
    }

}

protocol FinishableEvent: class {
    var finallyBlock: Block { get set }
}

infix operator ~~> : AdditionPrecedence

func ~~>(event: FinishableEvent, finallyBlock: @escaping Block) {
    event.finallyBlock = finallyBlock
}
