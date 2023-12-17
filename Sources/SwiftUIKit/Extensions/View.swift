import SwiftUI

extension View {
    
    @ViewBuilder
    public func screenLock(
        active: Bool = true,
        title: String = "Screen Locked",
        description: String = "",
        lockWhenAppEntersBackground: Bool = true,
        startFlowImmediately: Bool = true,
        backgroundType bgType: ScreenLockBackground = .customColor(Color(uiColor: .systemBackground))
    ) -> some View {
        ZStack {
            self
                .blur(radius: active ? bgType.blurValue() : 0)
            
            if active {
                ScreenLockView(
                    title: title,
                    description: description,
                    lockWhenAppEntersBackground: lockWhenAppEntersBackground,
                    startFlowImmediately: startFlowImmediately,
                    backgroundType: bgType
                )
            }
        }
    }
}
