import SwiftUI
import SwiftData

struct DNSProvider: Identifiable {
    let id = UUID()
    let name: String
    let ip: String
    let iconName: String
    let isCustom: Bool
}

struct DNSSettingsView: View {
   
    @Environment(\.modelContext) private var modelContext
    @Query private var services: [Services]
    
    var activeService: Services? {
        services.first
    }
    
    @State private var showCustomSheet = false
    @State private var tempCustomAddress: String = ""
    @State private var tempCustomPort: String = ""
    
    let dnsProviders: [DNSProvider] = [
        DNSProvider(name: "Use Google", ip: "8.8.8.8", iconName: "g.circle.fill", isCustom: false),
        DNSProvider(name: "Use Cloudflare", ip: "1.1.1.1", iconName: "cloud.fill", isCustom: false),
        DNSProvider(name: "Use Quad9", ip: "9.9.9.9", iconName: "9.circle.fill", isCustom: false),
        DNSProvider(name: "Use NextDNS", ip: "45.90.28.0", iconName: "shield.fill", isCustom: false),
        DNSProvider(name: "Use Yandex", ip: "77.88.8.8", iconName: "y.circle.fill", isCustom: false),
        DNSProvider(name: "Use AdGuard", ip: "94.140.14.14", iconName: "checkmark.shield.fill", isCustom: false),
        DNSProvider(name: "Use Mullvad", ip: "100.64.0.1", iconName: "lock.shield.fill", isCustom: false),
        DNSProvider(name: "Use OpenDNS", ip: "208.67.222.222", iconName: "o.circle.fill", isCustom: false),
        DNSProvider(name: "Use Custom", ip: "Custom", iconName: "house.fill", isCustom: true)
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    let containerColor = Color(nsColor: .controlBackgroundColor)
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("DNS")
                    .font(.system(size: 20, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Specifies the DNS server address to use for resolving domain names.")
                    .font(.system(size: 12, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(dnsProviders) { provider in
                  
                    let currentIP = activeService?.dns?.address ?? ""
                    
                    DNSCardView(provider: provider, currentDBIP: currentIP) {
                       
                        if provider.isCustom {
                            tempCustomAddress = activeService?.dns?.address ?? ""
                            tempCustomPort = String(activeService?.dns?.port ?? 53)
                            showCustomSheet = true
                        } else {
                            updateStandardDNS(provider: provider)
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(containerColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            if services.isEmpty {
                let defaultService = Services()
                modelContext.insert(defaultService)
            }
        }
        .sheet(isPresented: $showCustomSheet) {
            CustomDNSInputView(
                isPresented: $showCustomSheet,
                customAddress: $tempCustomAddress,
                customPort: $tempCustomPort,
                onSave: {
                    updateCustomDNS()
                }
            )
        }
    }
    
    func updateStandardDNS(provider: DNSProvider) {
        guard let dnsConfig = activeService?.dns else { return }
        
        withAnimation {
            dnsConfig.service = provider.name
            dnsConfig.address = provider.ip
            dnsConfig.port = 53
        }
    }
    
    func updateCustomDNS() {
        guard let dnsConfig = activeService?.dns else { return }
        
        withAnimation {
            dnsConfig.service = "Custom"
            dnsConfig.address = tempCustomAddress
            dnsConfig.port = Int(tempCustomPort) ?? 53
        }
    }
}

struct DNSCardView: View {
    let provider: DNSProvider
    let currentDBIP: String
    var onTap: () -> Void
    
    var isSelected: Bool {
        if provider.isCustom {
            let standardIPs = ["8.8.8.8", "1.1.1.1", "9.9.9.9", "45.90.28.0", "77.88.8.8", "94.140.14.14", "100.64.0.1", "208.67.222.222"]
            return !standardIPs.contains(currentDBIP)
        } else {
            return currentDBIP == provider.ip
        }
    }
    
    var body: some View {
        Button(action: { onTap() }) {
            VStack(spacing: 6) {
                HStack(alignment: .top) {
                    Image(systemName: provider.iconName)
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(isSelected ? .white : .gray)
                }
                .frame(height: 18)
                
                Text(provider.name)
                    .font(.system(size: 16, design: .default))
                    .foregroundColor(isSelected ? .white : .primary)
                    .padding(.top, 5)
                
                Text(provider.isCustom ? "Custom Address" : "(\(provider.ip))")
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct CustomDNSInputView: View {
    @Binding var isPresented: Bool
    @Binding var customAddress: String
    @Binding var customPort: String
    var onSave: () -> Void
    
    let containerColor = Color(nsColor: .controlBackgroundColor)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom DNS")
                .font(.system(size: 20, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Enter your custom DNS server details.")
                .font(.system(size: 12, design: .default))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 5) {
                Text("Address").font(.caption).foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 4)
                
                TextField("127.0.0.1", text: $customAddress)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .frame(width: 250)
            
            VStack(spacing: 5) {
                Text("Port").font(.caption).foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 4)
                
                TextField("53", text: $customPort)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .frame(width: 250)
            
            HStack(spacing: 15) {
                Button("Cancel") { isPresented = false }
                    .keyboardShortcut(.cancelAction)
                
                Button("Save") {
                    onSave()
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 10)
        }
        .padding(30)
        .frame(width: 320, height: 350)
        .background(containerColor)
    }
}
