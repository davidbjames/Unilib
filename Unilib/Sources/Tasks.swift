//
//  Tasks.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation
import RxSwift

public enum TaskError : Error {
    case genericError(Error?)
}

public protocol Task {
    associatedtype Element
    var options:TaskOptions? { get set }
    func create() -> Observable<Element>
}

public protocol SingleTask : Task {
    associatedtype Single
    func single() -> Observable<Single>
}

public struct TaskOptions: OptionSet {
    public let rawValue:Int
    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
    public static let withDependencies = TaskOptions(rawValue: 1 << 0)
}

public protocol Dependency {
    associatedtype Result
    func fulfill() -> Observable<Result>
}




// Rule not used, yet. Rules should have logical entry points, and not just adhoc wherever in the command you feel like.
// A rule could be:
//  - whether the command is fired in the first place
//    i.e. it just goes straight to .error operator
//  - whether the observable should fire .next or .error

public protocol Rule {
    associatedtype Condition
    func evaluate(condition: Condition) -> Any?
}

public protocol Conditional {
    associatedtype Rule
    var rule:Rule { get set }
}
