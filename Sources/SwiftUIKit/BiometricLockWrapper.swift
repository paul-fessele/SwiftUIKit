import SwiftUI

public struct BiometricLockWrapper<Content: View>: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var unlocked: Bool = false
    @State private var lockWhenAppEntersBackground: Bool = false
    private let contentView: Content
    
    public init(
        unlocked: Bool,
        lockWhenAppEntersBackground: Bool,
        @ViewBuilder contentView: () -> Content
    ) {
        self.contentView = contentView()
        self.unlocked = unlocked
        self.lockWhenAppEntersBackground = lockWhenAppEntersBackground
    }
    
    public var body: some View {
        contentView
            .onChange(of: scenePhase, initial: false, scenePhaseChanged)
            .overlay(alignment: .center) {
                if !unlocked {
                    VStack(alignment: .center, spacing: 50) {
                        Spacer()
                        
                        Text("Use FaceID to unlock this view")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Button(action: unlock) {
                            Text("Unlock")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .padding(12)
                                .padding(.horizontal, 8)
                                .background(.white, in: .capsule)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(.black, ignoresSafeAreaEdges: .all)
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                }
            }
    }
    
    private func unlock() {
        withAnimation {
            unlocked.toggle()
        }
    }
    
    private func scenePhaseChanged(oldPhase: ScenePhase, newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            if lockWhenAppEntersBackground {
                unlocked = false
            }
        default:
            break
        }
    }
}
