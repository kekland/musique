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

  @objc public func setNextTrackCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.nextTrackCommand.isEnabled = true
    commandCenter.nextTrackCommand.addTarget { event in
      callback()
      return .success
    }
  }

  @objc public func setPreviousTrackCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.previousTrackCommand.isEnabled = true
    commandCenter.previousTrackCommand.addTarget { event in
      callback()
      return .success
    }
  }

  @objc public func setSeekForwardCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.seekForwardCommand.isEnabled = true
    commandCenter.seekForwardCommand.addTarget { event in
      callback()
      return .success
    }
  }

  @objc public func setSeekBackwardCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.seekBackwardCommand.isEnabled = true
    commandCenter.seekBackwardCommand.addTarget { event in
      callback()
      return .success
    }
  }

  @objc public func setTogglePlayPauseCommandCallback(_ callback: @escaping () -> Void) {
    commandCenter.togglePlayPauseCommand.isEnabled = true
    commandCenter.togglePlayPauseCommand.addTarget { event in
      callback()
      return .success
    }
  }
}
