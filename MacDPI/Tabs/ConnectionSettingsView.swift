import SwiftUI
import SwiftData

struct ConnectionSettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var services: [Services]
    
    var activeService: Services? {
        services.first
    }
    
    @State private var useDefaultAddress: Bool = true
    @State private var address: String = "127.0.0.1"
    
    @State private var useDefaultPort: Bool = true
    @State private var port: String = "8080"
    
    let defaultAddress = "127.0.0.1"
    let defaultPort = "8080"
    
    let containerColor = Color(nsColor: .controlBackgroundColor)
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            ProxySettingSection(
                title: "Address",
                description: "Sets the local address the proxy server listeners on.",
                defaultValueLabel: "Use default (127.0.0.1)",
                isDefault: $useDefaultAddress,
                textValue: $address,
                defaultValue: defaultAddress
            )
            
            ProxySettingSection(
                title: "Port",
                description: "Sets the local port the proxy server listeners on.",
                defaultValueLabel: "Use default (8080)",
                isDefault: $useDefaultPort,
                textValue: $port,
                defaultValue: defaultPort
            )
            
            Spacer().frame(height: 10)
            
            Button(action: {
                saveSettings()
            }) {
                Text("Save Changes")
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .frame(width: 200)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
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
            loadSettings()
        }
    }

    
    func loadSettings() {
        if let proxyConfig = activeService?.proxy {
            useDefaultAddress = proxyConfig.useDefaultAddress
            address = proxyConfig.address
            
            useDefaultPort = proxyConfig.useDefaultPort
            port = String(proxyConfig.port)
        } else {
             if services.isEmpty {
                 let newService = Services()
                 modelContext.insert(newService)
             }
        }
    }
    
    func saveSettings() {
        guard let proxyConfig = activeService?.proxy else { return }
        
        withAnimation {
            proxyConfig.useDefaultAddress = useDefaultAddress
            proxyConfig.address = address
            
            proxyConfig.useDefaultPort = useDefaultPort
            proxyConfig.port = Int(port) ?? 8080
        }
        
        print("Proxy Ayarları Kaydedildi: \(address):\(port)")
    }
}

struct ProxySettingSection: View {
    let title: String
    let description: String
    let defaultValueLabel: String
    
    @Binding var isDefault: Bool
    @Binding var textValue: String
    let defaultValue: String
    
    var body: some View {
        VStack(spacing: 10) {

            Text(title)
                .font(.system(size: 20, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 12, design: .default))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                withAnimation {
                    isDefault.toggle()
                    if isDefault {
                        textValue = defaultValue
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isDefault ? "checkmark.app.fill" : "checkmark.app")
                        .foregroundColor(isDefault ? .white : .gray)
                        .font(.system(size: 16))
                    
                    Text(defaultValueLabel)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(.plain)
            
            TextField("", text: $textValue)
                .textFieldStyle(.plain)
                .padding(10)
                .background(Color.white.opacity(0.05))
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .disabled(isDefault)
                .opacity(isDefault ? 0.5 : 1.0)
                .foregroundColor(.white)
        }
    }
}
