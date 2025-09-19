import Foundation
import MediaPlayer

@objc public class MPRemoteCommandCenterListener: NSObject {
  @objc override public init() {
    self.commandCenter = MPRemoteCommandCenter.shared()
    super.init()
  }

  deinit {
    commandCenter.playCommand.removeTarget(nil)
    commandCenter.pauseCommand.removeTarget(nil)
  }

  private let commandCenter: MPRemoteCommandCenter

  @objc public func setPlayCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget { event in
      callback()
      return .success
    }
  }

  @objc public func setPauseCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget { event in
      callback()
      return .success
    }
  }
}
