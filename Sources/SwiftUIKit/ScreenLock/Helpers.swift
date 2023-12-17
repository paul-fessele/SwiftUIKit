import SwiftUI

public enum ScreenLockBackground {
    case customBlur(Double)
    case customColor(Color)
    
    func blurValue() -> Double {
        switch self {
        case .customBlur(let double):
            return double < 5 ? 5 : double
        case .customColor(let color):
            return 0
        }
    }
    
    func colorValue() -> Color {
        switch self {
        case .customBlur(let double):
            return .clear
        case .customColor(let color):
            return color
        }
    }
}
