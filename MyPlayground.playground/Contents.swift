import UIKit

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Timer stuff
public func duration(_ block: () -> ()) -> TimeInterval {
  let startTime = Date()
  block()
  return Date().timeIntervalSince(startTime)
}

// Initializing Q's

// .userInitiated global dispatch queue
let globalQ = DispatchQueue.global(qos: .userInitiated)

let userCreatedBgConcurrentQ = DispatchQueue(label: "user_created_global_q", qos: .userInteractive, attributes: .concurrent)

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

// Without GCD
//duration {
//  task1()
//  task2()
//}

// With GCD

//duration {
//  globalQ.async {
//    task1()
//  }
//  globalQ.async {
//    task2()
//  }
//}

// User Created or Private Serial Q's (Remember the default initializer creates a serial Q)

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
//let privateConcurrentQ = DispatchQueue(label: "com.steve.t", attributes: .concurrent)
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

class Timer {
  
  private static var startTime: Date?
  
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

//DispatchQueue.global().async {
//  Timer.start()
//  sleep(2)
//  DispatchQueue.main.async {
//    print(#line, "update UI")
//    Timer.stop()
//  }
//}
//print(#line, "should execute before line 109")

// DispatchGroup
// Can be used to submit multiple different work items and track when they all complete. Handy when progress can’t be made until all of the specified tasks are complete.

//let myGroup = DispatchGroup()

//globalQ.async(group: myGroup) {
//  sleep(1)
//  print(#line, "task 1")
//}
//
//mainQ.async(group: myGroup) {
//  sleep(1)
//  print(#line, "task 2")
//}
//
//globalQ.async(group: myGroup) {
//  sleep(1)
//  print(#line, "task 3")
//}
//
//myGroup.notify(queue: defaultQ) {
//  print(#line, "All items complete")
//}


// Using (NS)OperationQueue

//let operationQ = OperationQueue()
//
//let op1 = BlockOperation {
//  sleep(1)
//  print(#line, "block after sleep goes last")
//}
//
//let op2 = BlockOperation(block: {
//  print(#line, "block without sleep gets executed first")
//})
//
//operationQ.addOperations([op1, op2], waitUntilFinished: true)
//
//print(#line, "waitUntilFinished blocks until all operations have finished. So it affects this line!")


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
