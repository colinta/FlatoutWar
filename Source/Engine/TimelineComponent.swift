//
//  TimelineComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TimelineComponent: Component {

    private struct RecurringEvent {
        var countdown: CGFloat
        let generator: () -> CGFloat
        let startAt: CGFloat
        let until: ConditionBlock
        var lastRun: CGFloat
        let block: Block
    }

    private struct Event {
        let scheduledTime: CGFloat
        let block: Block
    }

    private struct ConditionEvent {
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

    func at(scheduledTime: CGFloat, block: Block) {
        addEvent(Event(scheduledTime: scheduledTime, block: block))
    }

    func after(scheduledTime: CGFloat, block: Block) {
        addEvent(Event(scheduledTime: time + scheduledTime, block: block))
    }

    func when(condition: ConditionBlock, block: Block) {
        addEvent(ConditionEvent(condition: condition, block: block))
    }

    func every(interval: CGFloat, startAt: CGFloat = 0, times: Int, block: Block) {
        var c = times
        let wrappedBlock: Block = {
            block()
            c -= 1
        }
        let untilBlock: ConditionBlock = { return c <= 0 }
        _every({ return interval }, startAt: startAt, until: untilBlock, block: wrappedBlock)
    }

    func every(interval: CGFloat, startAt: CGFloat = 0, block: Block) {
        _every({ return interval }, startAt: startAt, until: { return false }, block: block)
    }

    func every(interval: CGFloat, startAt: CGFloat = 0, untilTime: CGFloat, block: Block) {
        let untilBlock = { return self.time > untilTime }
        _every({ return interval }, startAt: startAt, until: untilBlock, block: block)
    }

    func every(interval: CGFloat, startAt: CGFloat = 0, until untilBlock: ConditionBlock, block: Block) {
        _every({ return interval }, startAt: startAt, until: untilBlock, block: block)
    }

    func every(interval: ClosedInterval<CGFloat>, startAt: CGFloat = 0, untilTime: CGFloat? = nil, block: Block) {
        let untilBlock: ConditionBlock
        if let untilTime = untilTime {
            untilBlock = { return self.time > untilTime }
        }
        else {
            untilBlock = { return false }
        }
        every(interval, startAt: startAt, until: untilBlock, block: block)
    }

    func every(interval: ClosedInterval<CGFloat>, startAt: CGFloat = 0, times: Int, block: Block) {
        guard times > 0 else { return }

        let min = interval.start
        let max = interval.end
        var c = times
        let wrappedBlock: Block = {
            block()
            c -= 1
        }
        let untilBlock: ConditionBlock = { return c <= 0 }
        _every({ return rand(min: min, max: max) }, startAt: startAt, until: untilBlock, block: wrappedBlock)
    }

    func every(interval: ClosedInterval<CGFloat>, startAt: CGFloat = 0, until untilBlock: ConditionBlock, block: Block) {
        let min = interval.start
        let max = interval.end
        _every({ return rand(min: min, max: max) }, startAt: startAt, until: untilBlock, block: block)
    }

    private func _every(generator: () -> CGFloat, startAt: CGFloat = 0, until untilBlock: ConditionBlock, block: Block) {
        let entry: RecurringEvent = RecurringEvent(countdown: 0, generator: generator, startAt: startAt, until: untilBlock, lastRun: 0, block: block)
        addEvent(entry)
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

        for var event in self.recurringEvents {
            if event.until() {
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
