//
//  Tasks.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation
import RxSwift

/// Abstract unit of work that takes options (and anything else
/// required for it's performance viz. "command pattern") and
/// ultimately returns an Observable for the action it performs.
public protocol Task {
    associatedtype Element
    var options:TaskOptions? { get set }
    func create() -> Observable<Element>
}



/// Options specific to handling a Task
public struct TaskOptions: OptionSet {
    public let rawValue:Int
    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
    public static let withDependencies = TaskOptions(rawValue: 1 << 0)
}



/// Abstract entity that represents a dependency that can either
/// be fulfilled with the expected Result type OR throw an Error
public protocol Dependency {
    associatedtype Result
    func fulfill() -> Observable<Result>
}
