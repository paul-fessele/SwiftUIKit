import SwiftUI
import LocalAuthentication

public struct ScreenLockView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var unlocked: Bool = false
    @State private var lockWhenAppEntersBackground: Bool = false
    @State private var startFlowImmediately: Bool = true
    @State private var showContent: Bool = false
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var backgroundType: ScreenLockBackground = .customColor(Color(uiColor: .systemBackground))
    
    private let laContext: LAContext
    
    public init(
        title: String,
        description: String,
        lockWhenAppEntersBackground: Bool,
        startFlowImmediately: Bool,
        backgroundType bgType: ScreenLockBackground
    ) {
        self.laContext = .init()
        self.lockWhenAppEntersBackground = lockWhenAppEntersBackground
        self.startFlowImmediately = startFlowImmediately
        self.showContent = !startFlowImmediately
        self.backgroundType = backgroundType
        self.title = title
        
        if description.isEmpty {
            switch laContext.biometryType {
            case .touchID:
                self.description = "Use TouchID to unlock this screen"
            case .faceID:
                self.description = "Use FaceID to unlock this screen"
            default:
                self.description = "Use your password to unlock this screen"
            }
        } else {
            self.description = description
        }
    }
    
    public var body: some View {
        ZStack {
            backgroundType
                .colorValue()
                .ignoresSafeArea(edges: .all)
            
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                
                Text(title)
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    
                Text(description)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button(action: authenticate) {
                    Text("Unlock")
                        .font(.headline)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .padding(12)
                        .padding(.horizontal, 12)
                        .background(.primary, in: .capsule)
                        .padding(.top, 80)
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, alignment: .center)
            .opacity(showContent ? 1 : 0)
        }
        .onChange(of: scenePhase, initial: false, scenePhaseChanged)
        .onAppear(perform: { if startFlowImmediately { authenticate() } })
        .opacity(unlocked ? 0 : 1)
    }
    
    private func scenePhaseChanged(oldPhase: ScenePhase, newPhase: ScenePhase) {
        switch newPhase {
        case .inactive:
            if lockWhenAppEntersBackground {
                unlocked = false
            }
        case .active:
            if startFlowImmediately && !unlocked {
                authenticate()
            }
        default:
            break
        }
    }
    
    private func authenticate() {
        var error: NSError?
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            let localizedReason = "Authentication is required to access sensitive data"
            
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReason) { success, error in
                if success {
                    unlocked = true
                } else {
                    unlocked = false
                    showContent = true
                }
            }
        } else {
            unlocked = false
            title = "Authentication not possible"
            description = "Please enable biometric authentication for this app in the settings"
        }
    }
}
