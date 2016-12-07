import Foundation

class Timer {
  private static var startTime:Date?
  static func start() {
    startTime = Date()
    print(#line, "start: \(startTime!)")
  }
  static func stop() {
    guard let startTime = startTime else {
      print(#line, "Must create startTime first")
      return
    }
    let stopTime = Date()
    let duration = Date().timeIntervalSince(startTime)
    print(#line, "stop: \(stopTime)")
    print(#line, "duration: \(duration)")
    self.startTime = nil
  }
}
