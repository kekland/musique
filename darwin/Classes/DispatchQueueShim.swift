import Foundation

@objc public class DispatchQueueShim: NSObject {
  @objc public static var main: DispatchQueue {
    return DispatchQueue.main
  }
}
