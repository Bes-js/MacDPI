import SwiftUI

struct CloseButton: View {
    @State private var isHovering = false
    @State private var isPressing = false
    
    let longPressDuration: Double = 2.5
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: isPressing ? 1.0 : 0.0)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .foregroundColor(.red)
                .rotationEffect(.degrees(-90))
                .frame(width: 24, height: 24)
                .animation(.linear(duration: isPressing ? longPressDuration : 0.1), value: isPressing)
                .opacity(isPressing ? 1 : 0)
            
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isPressing ? .red : (isHovering ? .red.opacity(0.8) : .white.opacity(0.6)))
                .scaleEffect(isPressing ? 1.2 : (isHovering ? 1.1 : 1.0))
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovering)
                .contentShape(Rectangle())
        }
        .frame(width: 14, height: 14)
        .help("Pressing for quit")
        .onTapGesture {
          
            if !isPressing {
                AppDelegate.shared.togglePopover(nil)
            }
        }
        .onLongPressGesture(minimumDuration: longPressDuration, pressing: { pressing in
            isPressing = pressing
            
        }, perform: {
            NSApplication.shared.terminate(nil)
        })
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
