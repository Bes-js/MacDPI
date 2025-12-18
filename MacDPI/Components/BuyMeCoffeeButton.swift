import SwiftUI

struct BuyMeCoffeeButton: View {
    @State private var isHovering = false
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "https://www.buymeacoffee.com/beykant") {
                NSWorkspace.shared.open(url)
            }
        }) {
            HStack(spacing: 2) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 14))
                    .help("Donation")
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
