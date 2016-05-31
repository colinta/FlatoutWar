//
//  TimelineComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let DefaultDelay: CGFloat = 3

class TimelineComponent: Component {
    struct CancellableWrapper {
        let timeline: TimelineComponent

        func at(scheduledTime: TimeDescriptor, block: Block) -> Block {
            let event = Event(scheduledTime: scheduledTime.toTime(timeline.time), block: block)
            timeline.addEvent(event)
            return { self.timeline.removeEvent(event) }
        }


        func after(scheduledTime: CGFloat, block: Block) -> Block {
            let event = Event(scheduledTime: timeline.time + scheduledTime, block: block)
            timeline.addEvent(event)
            return { self.timeline.removeEvent(event) }
        }


        func when(condition: ConditionBlock, block: Block) -> Block {
            let event = ConditionEvent(condition: condition, block: block)
            timeline.addEvent(event)
            return { self.timeline.removeEvent(event) }
        }

    }

    lazy var cancellable: CancellableWrapper = { return CancellableWrapper(timeline: self) }()

    enum TimeDescriptor: IntegerLiteralConvertible, FloatLiteralConvertible {
        init(integerLiteral time: Int) {
            self = At(CGFloat(time))
        }
        init(floatLiteral time: Float) {
            self = At(CGFloat(time))
        }
        static func Delayed(dt: CGFloat = 0) -> TimeDescriptor {
            return After(dt + DefaultDelay)
        }

        case At(CGFloat)
        case After(CGFloat)
        case Now

        func toTime(now: CGFloat) -> CGFloat {
            switch self {
            case let .At(t):
                return t
            case let .After(dt):
                return now + dt
            case .Now:
                return now
            }
        }
    }

    class RecurringEvent {
        let uuid = NSUUID()
        var countdown: CGFloat
        let generator: () -> CGFloat
        let startAt: CGFloat
        let until: ConditionBlock
        var lastRun: CGFloat = 0
        let block: Block
        var finallyBlock: Block

        init(countdown: CGFloat, generator: () -> CGFloat, startAt: CGFloat, until: ConditionBlock, block: Block, finallyBlock: Block) {
            self.countdown = countdown
            self.generator = generator
            self.startAt = startAt
            self.until = until
            self.block = block
            self.finallyBlock = finallyBlock
        }

        convenience init() {
            self.init(countdown: 0, generator: { return 0 }, startAt: 0, until: { return false }, block: {}, finallyBlock: {})
        }
    }

    struct Event {
        let uuid = NSUUID()
        let scheduledTime: CGFloat
        let block: Block
    }

    struct ConditionEvent {
        let uuid = NSUUID()
        let condition: ConditionBlock
        let block: Block
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

    private func removeEvent(event: Event) {
        newEvents.removeMatches { $0.uuid == event.uuid }
        events.removeMatches { $0.uuid == event.uuid }
    }
    private func removeEvent(event: RecurringEvent) {
        newRecurringEvents.removeMatches { $0.uuid == event.uuid }
        recurringEvents.removeMatches { $0.uuid == event.uuid }
    }
    private func removeEvent(event: ConditionEvent) {
        newConditionEvents.removeMatches { $0.uuid == event.uuid }
        conditionEvents.removeMatches { $0.uuid == event.uuid }
    }

    private func addEvent(event: Event) {
        if running {
            newEvents << event
        }
        else {
            events << event
        }
    }

    private func addEvent(event: RecurringEvent) {
        if running {
            newRecurringEvents << event
        }
        else {
            recurringEvents << event
        }
    }

    private func addEvent(event: ConditionEvent) {
        if running {
            newConditionEvents << event
        }
        else {
            conditionEvents << event
        }
    }

    func at(scheduledTime: TimeDescriptor, block: Block) {
        addEvent(Event(scheduledTime: scheduledTime.toTime(time), block: block))
    }

    func after(scheduledTime: CGFloat, block: Block) {
        addEvent(Event(scheduledTime: time + scheduledTime, block: block))
    }

    func when(condition: ConditionBlock, block: Block) {
        addEvent(ConditionEvent(condition: condition, block: block))
    }

    func every(interval: CGFloat, start: TimeDescriptor = .After(0), times: Int, finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        var c = times
        let wrappedBlock: Block = {
            block()
            c -= 1
        }
        let untilBlock: ConditionBlock = { return c <= 0 }
        return _every({ return interval }, start: start, until: untilBlock, finally: finallyBlock, block: wrappedBlock)
    }

    func every(interval: CGFloat, start: TimeDescriptor = .After(0), finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        return _every({ return interval }, start: start, until: { return false }, finally: finallyBlock, block: block)
    }

    func every(interval: CGFloat, start: TimeDescriptor = .After(0), untilTime: CGFloat, finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        let untilBlock = { return self.time > untilTime }
        return _every({ return interval }, start: start, until: untilBlock, finally: finallyBlock, block: block)
    }

    func every(interval: CGFloat, start: TimeDescriptor = .After(0), until untilBlock: ConditionBlock, finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        return _every({ return interval }, start: start, until: untilBlock, finally: finallyBlock, block: block)
    }

    func every(interval: ClosedInterval<CGFloat>, start: TimeDescriptor = .After(0), untilTime: CGFloat? = nil, finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        let untilBlock: ConditionBlock
        if let untilTime = untilTime {
            untilBlock = { return self.time > untilTime }
        }
        else {
            untilBlock = { return false }
        }
        return every(interval, start: start, until: untilBlock, finally: finallyBlock, block: block)
    }

    func every(interval: ClosedInterval<CGFloat>, start: TimeDescriptor = .After(0), times: Int, finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        guard times > 0 else { return RecurringEvent() }

        let min = interval.start
        let max = interval.end
        var c = times
        let wrappedBlock: Block = {
            block()
            c -= 1
        }
        let untilBlock: ConditionBlock = { return c <= 0 }
        return _every({ return rand(min: min, max: max) }, start: start, until: untilBlock, finally: finallyBlock, block: wrappedBlock)
    }

    func every(interval: ClosedInterval<CGFloat>, start: TimeDescriptor = .After(0), until untilBlock: ConditionBlock, finally finallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        let min = interval.start
        let max = interval.end
        return _every({ return rand(min: min, max: max) }, start: start, until: untilBlock, finally: finallyBlock, block: block)
    }

    private func _every(generator: () -> CGFloat, start: TimeDescriptor = .After(0), until untilBlock: ConditionBlock, finally optFinallyBlock: Block? = nil, block: Block) -> RecurringEvent {
        let finallyBlock: Block
        if let block = optFinallyBlock {
            finallyBlock = block
        }
        else {
            finallyBlock = {}
        }
        let entry: RecurringEvent = RecurringEvent(countdown: 0, generator: generator, startAt: start.toTime(time), until: untilBlock, block: block, finallyBlock: finallyBlock)
        addEvent(entry)

        return entry
    }

    func stop() {
        self.enabled = false
    }

    override func update(dt: CGFloat) {
        running = true
        time += dt

        for event in self.events {
            if time >= event.scheduledTime {
                event.block()
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

infix operator ~~> {
    associativity left
    precedence 150
}

func ~~>(event: TimelineComponent.RecurringEvent, finallyBlock: Block) {
    event.finallyBlock = finallyBlock
}
