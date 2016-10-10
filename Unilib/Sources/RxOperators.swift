//
//  RxOperators.swift
//  Unilib
//
//  Created by David James on 10/10/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation
import RxSwift

// TODO: Install RxSwiftExt and remove these redundant extensions
// (however, keep this file so you can write your own extensions, looks easy)

extension Observable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - parameter predicate: predicate determines whether element distinct
     
     - returns: An observable sequence only containing the distinct contiguous elements, based on predicate, from the source sequence.
     */
    public func distinct(_ predicate: @escaping (Element) throws -> Bool) -> Observable<E> {
        var cache = [Element]()
        return flatMap { element -> Observable<Element> in
            if try cache.contains(where: predicate) {
                return Observable<Element>.empty()
            } else {
                cache.append(element)
                return Observable<Element>.just(element)
            }
        }
    }
}

extension Observable where Element: Hashable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = Set<Element>()
        return flatMap { element -> Observable<Element> in
            if cache.contains(element) {
                return Observable<Element>.empty()
            } else {
                cache.insert(element)
                return Observable<Element>.just(element)
            }
        }
    }
}

extension Observable where Element: Equatable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = [Element]()
        return flatMap { element -> Observable<Element> in
            if cache.contains(element) {
                return Observable<Element>.empty()
            } else {
                cache.append(element)
                return Observable<Element>.just(element)
            }
        }
    }
}
