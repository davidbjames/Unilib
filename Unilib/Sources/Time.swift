//
//  Time.swift
//  Unilib
//
//  Created by David James on 11/1/16.
//  Copyright © 2016-2021 David B James. All rights reserved.
//

import Foundation

/// Delay the excecution of some body of work.
/// This typically pushes execution to the
/// beginning of the next run loop and should
/// not be overly depended on.
/// Passing "nil" will cause the work to be
/// executed immediately. (This is not the same
/// as passing 0.0, which will cause this to
/// be run on the next run loop.)
public func delay(_ delay:TimeInterval? = 0.1, _ closure:@escaping ()->()) {
    if let delay = delay {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    } else {
        closure()
    }
}

// MARK:- Benchmarking

// DEV NOTE: Benchmarking is not useful with tiny durations
// as it returns non-representable numbers.
// Benchmarking here is meant for longer running operations.
// Also, DispatchTime.now().uptimeNanoseconds / 1_000_000_000
// results in the same precision problems as CF, when calculating
// tiny durations.

/// Benchmark the time it takes for an operation
/// to run, printing that time to the console.
///
/// Optionally, provide `label` to prepend to console.
public func benchmark(label:String? = nil, _ operation: ()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = Double(CFAbsoluteTimeGetCurrent() - startTime)
    if let label = label {
        print(label, timeElapsed)
        appendBenchmarkTimes(label:label, time:timeElapsed)
    } else {
        print(timeElapsed)
    }
}

/// Benchmark the time it takes for an operation
/// to run, printing that time to the console and
/// returning the result of the operation.
///
/// Optionally, provide `label` to prepend to console.
@discardableResult
public func benchmark<T>(label:String? = nil, _ operation:@autoclosure ()->T) -> T {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = operation()
    let timeElapsed = Double(CFAbsoluteTimeGetCurrent() - startTime)
    if let label = label {
        print(label, timeElapsed)
        appendBenchmarkTimes(label:label, time:timeElapsed)
    } else {
        print(timeElapsed)
    }
    return result
}

/// Benchmark the time it takes for an operation
/// to run, printing that time to the console and
/// returning the result of the operation or nil.
///
/// Optionally, provide `label` to prepend to console.
@discardableResult
public func benchmark<T>(label:String? = nil, _ operation:@autoclosure ()->T?) -> T? {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = operation()
    let endTime = CFAbsoluteTimeGetCurrent()
    let timeElapsed = Double(endTime - startTime)
    if let label = label {
        print(label, timeElapsed)
        appendBenchmarkTimes(label:label, time:timeElapsed)
    } else {
        print(timeElapsed)
    }
    return result
}

private var benchmarkTimes:[String:[Double]] = [:]

private func appendBenchmarkTimes(label:String, time:Double) {
    if let existing = benchmarkTimes[label] {
        benchmarkTimes[label] = existing + [time]
    } else {
        benchmarkTimes[label] = [time]
    }
}

/// Print out the sum of the time and average of the labeled
/// benchmark for each run, or optionally pass `cumulative`
/// to accumulate all the runs within the app session.
public func benchmarkResult(_ label:String, cumulative:Bool = false) {
    delay {
        guard let times = benchmarkTimes[label] else {
            print("Benchmark result called with no data.")
            return
        }
        let sum = times.reduce(0.0, { $0 + $1 })
        print("Benchmark result for \(label). Sum\(cumulative ? " (cumulative)" : ""):", sum, "Average:", sum / times.count)
        if !cumulative {
            benchmarkTimes[label] = nil
        }
    }
}
