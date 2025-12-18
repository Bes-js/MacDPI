import SwiftUI

struct GpsToggle: View {
    @Binding var isOn: Bool
    var status: ConnectionStatus
    var size: CGFloat = 110
    
    var body: some View {
        Button(action: {
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                if status != .connecting {
                    isOn.toggle()
                }
            }
        }) {
            ZStack {
                Image("gps")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isOn ? .gray.opacity(0.3) : .red.opacity(0.8))
                    .frame(width: size, height: size)
                    .shadow(color: isOn ? .clear : .red.opacity(0.5), radius: 10)
                
                Image("gps.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundStyle(
                        LinearGradient(
                            colors: status == .connecting ?
                            [
                                Color(red: 1.0, green: 0.8, blue: 0.0),
                                Color(red: 1.0, green: 0.6, blue: 0.0)
                            ] :
                            [
                               
                                Color(red: 0.2, green: 0.8, blue: 0.2),
                                Color(red: 0.6, green: 1.0, blue: 0.6)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .mask(
                        GeometryReader { geo in
                            VStack {
                                Spacer()
                                Rectangle()
                                    .frame(height: isOn ? geo.size.height : 0)
                            }
                        }
                    )
                    .shadow(color: status == .connecting ? Color.orange.opacity(0.6) : status == .connected ? Color.green.opacity(0.6) : .clear, radius: 15, x: 0, y: 0)
                    .opacity(isOn ? 1 : 0)
            }
            .scaleEffect(isOn ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.5), value: status)
        }
        .buttonStyle(.plain)
    }
}
