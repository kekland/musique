import Foundation

@objc public class NSObjectObserver : NSObject {
    @objc public init(observable: NSObject, keyPath: NSString, callback: @escaping () -> Void) {
        self.observable = observable;
        self.keyPath = keyPath as String;
        self.callback = callback;
        self.isObserving = true;
        
        super.init()
        
        observable.addObserver(self, forKeyPath: self.keyPath, context: nil)
    }
    
    @objc public func stopObserving() {
        if(!self.isObserving) {return;}
        
        observable.removeObserver(self, forKeyPath: keyPath)
        self.isObserving = false;
    }
    
    deinit {
        stopObserving();
    }
    
    private let observable: NSObject;
    private let keyPath: String;
    private let callback: () -> Void;
    private var isObserving: Bool;
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        callback();
    }
}
