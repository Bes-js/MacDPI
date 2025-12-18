import SwiftUI

struct SettingsButton: View {
    @State private var isHovering = false
    var openSettings: () -> Void
    
    var body: some View {
        Button(action: {
            openSettings()
        }) {
            HStack(spacing: 2) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 14))
                    .help("Settings")
            }
            .foregroundColor(isHovering ? .white : .white.opacity(0.6))
            .scaleEffect(isHovering ? 1.1 : 1.0)
            .brightness(isHovering ? 0.05 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovering)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}



