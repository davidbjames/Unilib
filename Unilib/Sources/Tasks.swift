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

/// A Task that normally returns an aggregate response (either as
/// a single emission of an array or as multiple emmisions) that 
/// will return the first of that aggregate. (Note that rx.single
/// handles the latter but not the former.)
public protocol SingleTask : Task {
    associatedtype Single
    func single() -> Observable<Single>
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




// Rule not used, yet. Rules should have logical entry points, and not just adhoc wherever in the command you feel like.
// A rule could be:
//  - whether the command is fired in the first place
//    i.e. it just goes straight to .error operator
//  - whether the observable should fire .next or .error

/*
public protocol Rule {
    associatedtype Condition
    func evaluate(condition: Condition) -> Any?
}

public protocol Conditional {
    associatedtype Rule
    var rule:Rule { get set }
}
*/
