
import Cocoa

extension NSScreen {
    static func mainScreenScaleFactor() -> CGFloat{
        if let screen = NSScreen.main{
            return screen.backingScaleFactor
        }
        return 1.0
    }
}
