import UIKit

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Timer stuff
public func duration(_ block: () -> ()) -> TimeInterval {
  let startTime = Date()
  block()
  return Date().timeIntervalSince(startTime)
}

class Timer {
  private static var startTime:Date?
  static func start() {
    startTime = Date()
    print(#line, "start: \(startTime!)")
  }
  static func stop() {
    guard let startTime = startTime else {
      print(#line, "Must run start first")
      return
    }
    let stopTime = Date()
    let duration = Date().timeIntervalSince(startTime)
    print(#line, "stop: \(stopTime)")
    print(#line, "duration: \(duration)")
    self.startTime = nil
  }
}


// Initializing Q's 

// .userInitiated global dispatch queue
let userInitiatedQ = DispatchQueue.global(qos: .userInitiated)

//.default global dispatch queue
let defaultQ = DispatchQueue.global()

// main queue
let mainQ = DispatchQueue.main


func task1() {
  print(#line, "started")
  sleep(1)
  print(#line, "finished")
}

func task2() {
  print(#line, "started")
  print(#line, "finished")
}

// without GCD
//duration {
//  task1()
//  task2()
//}

// with GCD

//duration {
//  userInitiatedQ.async {
//    task1()
//  }
//  userInitiatedQ.async {
//    task2()
//  }
//}

// User Created or Private Serial Q's
//let privateBgQ = DispatchQueue(label: "com.steve.t")
//
//duration {
//  privateBgQ.async {
//    task1()
//  }
//  privateBgQ.async {
//    task2()
//  }
//}

// Private Concurrent Q
let privateConcurrentQ = DispatchQueue(label: "com.steve.t", attributes: .concurrent)
//
//duration {
//  privateConcurrentQ.async {
//    task1()
//  }
//  privateConcurrentQ.async {
//    task2()
//  }
//}


// most common pattern

//DispatchQueue.global().async {
//  Timer.start()
//  sleep(2)
//  DispatchQueue.main.async {
//    print(#line, "update UI")
//    Timer.stop()
//  }
//}

// DispatchGroup
// Can be used to submit multiple different work items and track when they all complete. Handy when progress can’t be made until all of the specified tasks are complete.

//let myGroup = DispatchGroup()
//
//userInitiatedQ.async(group: myGroup) {
//  sleep(1)
//  print(#line, "task 1")
//}
//
//mainQ.async(group: myGroup) {
//  sleep(1)
//  print(#line, "task 2")
//}
//
//userInitiatedQ.async(group: myGroup) {
//  sleep(1)
//  print(#line, "task 3")
//}
//
//myGroup.notify(queue: defaultQ) {
//  print(#line, "All items complete")
//}


// Using OperationQueue

//let operationQ = OperationQueue()
//let op1 = BlockOperation { 
//  sleep(1)
//  print(#line, "block after sleep")
//}
//
//let op2 = BlockOperation(block: {
//  print(#line, "block without sleep")
//})
//
//operationQ.addOperations([op1, op2], waitUntilFinished: true)
//
//print(#line, "wait until finish affects this line")


// Creating a dependency such that op1 finishes execution before op2 proceeds

//let operationQ = OperationQueue()
//let op1 = BlockOperation {
//  print(#line, "block before sleep")
//  sleep(1)
//  print(#line, "block after sleep")
//}
//
//let op2 = BlockOperation(block: {
//  print(#line, "block without sleep")
//})
//
//op2.addDependency(op1)
//
//operationQ.addOperations([op1, op2], waitUntilFinished: false)
//
//print(#line, "waitUntilFinished affects this line")






























//PlaygroundPage.current.finishExecution()
