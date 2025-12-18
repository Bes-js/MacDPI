import SwiftUI
import SwiftData
import ServiceManagement

struct AdvancedSettingsView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var services: [Services]
    
    var activeService: Services? {
        services.first
    }
    
    @AppStorage("launchAtLogin") var launchAtLogin = false
    @State private var dnsIPv4Only: Bool = false
    @State private var dnsOverHTTPS: Bool = false
    @State private var systemProxy: Bool = false
    @State private var useProxy: Bool = false
    
    @State private var timeoutValue: Int = 25
    @State private var clientHelloChunkSize: Int = 6

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    let containerColor = Color(nsColor: .controlBackgroundColor)

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 40) {
                    
                    SettingsToggleItem(
                        title: "DNS IPv4 Only",
                        description: "Use IPv4 DNS servers only.",
                        isOn: $dnsIPv4Only
                    )
                    
                    SettingsToggleItem(
                        title: "DNS Over HTTPS",
                        description: "Use DNS over HTTPS.",
                        isOn: $dnsOverHTTPS
                    )
                    
                    SettingsToggleItem(
                        title: "System Proxy",
                        description: "Use system proxy settings.",
                        isOn: $systemProxy
                    )
                    
                    SettingsToggleItem(
                        title: "Launch At Login",
                        description: "Starts the app at login.",
                        isOn: $launchAtLogin
                    )
                    
                    SettingsNumberItem(
                        title: "Timeout",
                        description: "Set the timeout for DNS queries. (Sec)",
                        value: $timeoutValue,
                        range: 1...300
                    )
                    
                    SettingsNumberItem(
                        title: "Client Hello Chunk Size",
                        description: "Set the size of the client hello chunk.",
                        value: $clientHelloChunkSize,
                        range: 1...100
                    )
                }
                .padding(40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .onChange(of: dnsIPv4Only) { _, _ in updateDB() }
        .onChange(of: dnsOverHTTPS) { _, _ in updateDB() }
        .onChange(of: systemProxy) { _, _ in updateDB() }
        .onChange(of: timeoutValue) { _, _ in updateDB() }
        .onChange(of: clientHelloChunkSize) { _, _ in updateDB() }
        .onChange(of: launchAtLogin) { oldValue, newValue in
                    toggleLaunchAtLogin(open: newValue)
                }
    }
    
    func loadSettings() {
        let currentStatus = SMAppService.mainApp.status == .enabled
                if launchAtLogin != currentStatus {
                    launchAtLogin = currentStatus
                }
        
        if services.isEmpty {
            modelContext.insert(Services())
            return
        }
        
        if let config = activeService?.advanced {
            dnsIPv4Only = config.dnsIPv4Only
            dnsOverHTTPS = config.dnsOverHttps
            systemProxy = config.systemProxy
            timeoutValue = Int(config.timeout) ?? 25
            clientHelloChunkSize = Int(config.clientHelloChunkSize) ?? 6
        }
    }
    
    func updateDB() {
        guard let config = activeService?.advanced else { return }
        
        config.dnsIPv4Only = dnsIPv4Only
        config.dnsOverHttps = dnsOverHTTPS
        config.systemProxy = systemProxy
        config.timeout = String(timeoutValue)
        config.clientHelloChunkSize = String(clientHelloChunkSize)
    }
}


struct SettingsToggleItem: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.regular)
        }
    }
}

struct SettingsNumberItem: View {
    let title: String
    let description: String
    @Binding var value: Int
    var range: ClosedRange<Int> = 0...999
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 0) {
                Button(action: {
                    if value > range.lowerBound { value -= 1 }
                }) {
                    Image(systemName: "minus")
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundColor(value > range.lowerBound ? .white : .gray.opacity(0.3))
                
                Divider().frame(height: 20).background(Color.white.opacity(0.2))
                
                TextField("", value: $value, formatter: formatter)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(width: 50)
                
                Divider().frame(height: 20).background(Color.white.opacity(0.2))
                
                Button(action: {
                    if value < range.upperBound { value += 1 }
                }) {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundColor(value < range.upperBound ? .white : .gray.opacity(0.3))
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
    }
}



func toggleLaunchAtLogin(open: Bool) {
    let service = SMAppService.mainApp
    
    do {
        if open {
            if service.status == .enabled { return }
            try service.register()
        } else {
            if service.status == .notRegistered { return }
            try service.unregister()
        }
    } catch { }
}
