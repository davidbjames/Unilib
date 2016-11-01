//
//  RxOperators.swift
//  Unilib
//
//  Created by David James on 10/10/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation
import RxSwift

extension ObserverType {
    
    /// Convenience method to force an emission to run on the next
    /// run loop. This method assumes main queue.
    /// Caution: Behaviors that depend on the side-effect of running
    /// on the next runloop may indicate a code smell or structural problem.
    public func onNextRunloop(_ element: E) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.onNext(element)
        }
    }
}

extension ObservableType {
    
    /// Retry the source observable if an error is emitted.
    /// This is simply a better named alias to retry.
    public func retryOnError() -> Observable<E> {
        return self.retry()
    }
    
    /// Retry the source observable if an error is emitted,
    /// up to maximum number of retries.
    /// This is simply a better named alias to retry.
    public func retryOnError(_ maxAttempts:Int) -> Observable<E> {
        return self.retry(maxAttempts)
    }
}
