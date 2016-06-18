//
//  ezlangTests.swift
//  ezlangTests
//
//  Created by Andriy Puhach on 11/19/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import XCTest
@testable import ezlang

extension Int {
    func times(f: ()->Void) -> Void {
        for _ in (0..<self){
            f()
        }
    }
}

class ezlangTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserUniqueRandomUdid(){
        var users: Set = Set<User>()
        20.times{
            users.insert(User.getMockUser())
        }
        assert(users.count == 20)
    }
    
    func testDebuggingArrayToString(){
        assert(Array2D<Character>(rows: 2, columns: 2, item: "1").toString() == "\n1 1 \n1 1 ")
    }
    
    func testStringRemoveHalfLetters(){
        let str = "word".removeHalfOfTheLetters()
        print(str)
        assert(str.characters.count == 4)
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

