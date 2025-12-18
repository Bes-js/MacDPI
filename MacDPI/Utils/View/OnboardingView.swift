import SwiftUI

// MARK: - Data Model
struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
}

struct OnboardingView: View {
    var onFinished: () -> Void
    
    // Kurumsal İçerik (İngilizce)
    let items: [OnboardingItem] = [
        OnboardingItem(
            title: "Welcome to MacDPI",
            description: "Experience a seamless, unrestricted internet. MacDPI creates a bridge between you and the content you love, bypassing DPI restrictions effortlessly.",
            icon: "network"
        ),
        OnboardingItem(
            title: "High Performance",
            description: "Powered by the robust SpoofDPI core. Enjoy lightning-fast connectivity with minimal latency. Designed for professionals who value speed.",
            icon: "speedometer"
        ),
        OnboardingItem(
            title: "Privacy First",
            description: "Your data stays yours. No logs, no tracking, no third-party servers. Just a pure, local utility working directly on your machine.",
            icon: "lock.shield"
        )
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // 1. Clean Background (Subtle Gradient)
            LinearGradient(
                gradient: Gradient(colors: [Color(nsColor: .windowBackgroundColor), Color(nsColor: .controlBackgroundColor)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 2. Top Bar (Skip Button)
                
                // 3. Sliding Content Area
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(0..<items.count, id: \.self) { index in
                            OnboardingCardView(item: items[index], isCurrent: currentPage == index)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                    .offset(x: -CGFloat(currentPage) * geometry.size.width)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                }
                
                // 4. Bottom Controls (Indicators & Button)
                HStack {
                    // Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.primary : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.default, value: currentPage)
                        }
                    }
                    
                    Spacer()
                    
                    // Primary Action Button
                    Button(action: {
                        if currentPage < items.count - 1 {
                            withAnimation { currentPage += 1 }
                        } else {
                            onFinished()
                        }
                    }) {
                        Text(currentPage == items.count - 1 ? "Get Started" : "Next")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 100)
                            .padding(.vertical, 10)
                            .background(Color.accentColor) // Sistemin vurgu rengi (Mavi vs.)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .frame(width: 600, height: 450)
    }
}

// MARK: - Single Card View
struct OnboardingCardView: View {
    let item: OnboardingItem
    let isCurrent: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            // Modern Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .frame(width: 120, height: 120)
                
                Image(systemName: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.primary)
                    .symbolEffect(.bounce, value: isCurrent) // macOS 14+ için animasyon (yoksa statik durur)
            }
            .padding(.top, 20)
            
            VStack(spacing: 12) {
                Text(item.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(item.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 400) // Metnin çok yayılmasını engelle
                    .lineSpacing(4)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .opacity(isCurrent ? 1 : 0) // Sadece aktif sayfa görünsün (geçişte üst üste binmesin)
        .animation(.easeIn(duration: 0.3), value: isCurrent)
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onFinished: {})
            .preferredColorScheme(.light) // Light mod testi
        
        OnboardingView(onFinished: {})
            .preferredColorScheme(.dark) // Dark mod testi
    }
}
