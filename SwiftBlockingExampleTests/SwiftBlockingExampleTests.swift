//
//  SwiftBlockingExampleTests.swift
//  SwiftBlockingExampleTests
//
//  Created by steve on 2016-12-06.
//  Copyright © 2016 steve. All rights reserved.
//

import XCTest

class SwiftBlockingExampleTests: XCTestCase {
  
  // Using OperationQueue
  func testCurrentQIsTheMainQ() {
    let mainQ = DispatchQueue.main
    XCTAssertTrue(mainQ == OperationQueue.current?.underlyingQueue)
  }
  
  func testBackgroundQIsNotTheMainQ() {
    let bgQ = DispatchQueue.global()
    XCTAssertFalse(bgQ == OperationQueue.main)
  }
  
  func testBackgroundSerialQSync() {
    let bgSerialQ = DispatchQueue(label: "com.steve.concurrency")
    
    bgSerialQ.sync {
      print(#line)
    }
    
    print(#line)
    
    let workItem1 = DispatchWorkItem { 
      print(#line)
    }
    
    bgSerialQ.sync(execute: workItem1)
    
    let workItem2 = DispatchWorkItem {
      print(#line)
    }
    
    bgSerialQ.sync(execute: workItem2)
    
    print(#line)
  }
  
  func testBackgroundSerialQaSync() {
    let bgSerialQ = DispatchQueue(label: "com.steve.concurrency")
    
    bgSerialQ.async {
      print(#line)
    }
    
    print(#line)
    
    let workItem1 = DispatchWorkItem {
      print(#line)
    }
    
    bgSerialQ.async(execute: workItem1)
    
    let workItem2 = DispatchWorkItem {
      print(#line)
    }
    
    bgSerialQ.async(execute: workItem2)
    
    print(#line)
  }

  
}
