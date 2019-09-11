//
//  Arrays_Tests.swift
//  Unilib
//
//  Created by David James on 5/28/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import XCTest
@testable import Unilib

class Arrays_Tests: XCTestCase {
    
    var arrayOfEquatables:Array<MyEquatable>!
    var arrayOfInts:Array<Int>! // Hashable
    var arrayOfHashables:Array<MyHashable>!
    
    struct MyEquatable : Equatable {
        let i:Int
        public static func == (lhs:MyEquatable, rhs:MyEquatable) -> Bool {
            return lhs.i == rhs.i
        }
    }
    
    struct MyHashable : Hashable {
        let i:Int
        let j:Int
        func hash(into hasher: inout Hasher) {
            hasher.combine(i)
            hasher.combine(j)
        }
        // hash value no longer used
        // hash combiner ^^ does it for you.
//        var hashValue: Int {
//            return i.hashValue ^ (j.hashValue &* 987654433)
            // 1800% slower due to collisions.
            // return i.hashValue ^ j.hashValue
//        }
        public static func == (lhs:MyHashable, rhs:MyHashable) -> Bool {
            guard lhs.hashValue == rhs.hashValue else { return false }
            return lhs.i == rhs.i && lhs.j == rhs.j
        }
    }
    
    override func setUp() {
        super.setUp()
        
        arrayOfEquatables = []
        arrayOfInts = [] // Hashable
        arrayOfHashables = []
        
        for i in 0...10000 {
            arrayOfEquatables.append(MyEquatable(i: i))
            arrayOfInts.append(i)
            arrayOfHashables.append(MyHashable(i: i, j:i+1))
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func test__removingDuplicates__performance_of_Equatable_using_struct() {
//        self.measure {
//            _ = self.arrayOfEquatables.removingDuplicates()
//        }
//    }
//    
//    func test_removingDuplicates__performance_of_Hashable_using_int() {
//        self.measure {
//            _ = self.arrayOfInts.removingDuplicates()
//        }
//    }
    
    func test__removingDuplicates__peformance_of_Hashable_using_struct() {
        self.measure {
            _ = self.arrayOfHashables.removingDuplicates()
        }
    }
    
    // Set-based filtering
    
//    func test__removingHashableDuplicates__performance_of_Hashable_using_int() {
//        self.measure {
//            _ = self.arrayOfInts.removingDuplicates()
//        }
//    }
//    
//    func test__removingHashableDuplicates__peformance_of_Hashable_using_struct() {
//        self.measure {
//            _ = self.arrayOfHashables.removingDuplicates()
//        }
//    }

}
