import SwiftUI
import ServiceManagement

struct IPAPIResponse: Codable {
    let query: String
    let isp: String
    let country: String
    let city: String
    let regionName: String
    let timezone: String
    let org: String
}

struct GeneralSettingsView: View {
    @AppStorage("isWorking") var isWorking = false
    
    @State private var connectionStatus: String = "Inactive"
    @State private var ispName: String = "Loading..."
    @State private var colocationCenter: String = "Loading..."
    @State private var connectionType: String = "Checking..."
    @State private var publicIP: String = "Loading..."
    @State private var localIP: String = "Loading..."
    @State private var deviceModel: String = "Loading..."
    @State private var timezone: String = "Loading..."
    @State private var org: String = "Loading..."
    @State private var macAddress: String = "Loading..."
    
    
    let containerColor = Color(nsColor: .controlBackgroundColor)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
           
            VStack(alignment: .leading, spacing: 16) {
                
               
                VStack(alignment: .leading, spacing: 8) {
                    Text("Connectivity information")
                        .font(.headline)
                        .underline()
                    
                    InfoRow(key: "Connection:", value: connectionStatus)
                    InfoRow(key: "ISP name:", value: ispName)
                    InfoRow(key: "Org:", value: org)
                    InfoRow(key: "Colocation center:", value: colocationCenter)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your device")
                        .font(.headline)
                        .underline()
                    
                    InfoRow(key: "Connection type:", value: connectionType)
                    InfoRow(key: "Timezone", value: timezone)
                    InfoRow(key: "Public IP:", value: publicIP, isConfidential: true)
                    InfoRow(key: "Local IP:", value: localIP, isConfidential: true)
                    InfoRow(key: "Mac address:", value: macAddress, isConfidential: true)
                    
                }
                
                Divider()
            
                InfoRow(key: "Device Model:", value: deviceModel)
                
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
            
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Text("Version (2025.12.1)")
                        .font(.callout)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/Bes-js/MacDPI") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                     Text("Github Repository")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/Bes-js/MacDPI/releases") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                     Text("Releases")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .task {
            loadData()
        }
    }
    
    
    func loadData() {
        
        self.deviceModel = SystemUtils.getMacModelIdentifier()
        SystemUtils.checkConnectionType { type in
            self.connectionType = type
        }
        self.macAddress = SystemUtils.getMacAddress()
        self.localIP = SystemUtils.getLocalIPAddress()
        SystemUtils.fetchIPInfo { result in
            if let data = result {
                self.publicIP = data.query
                self.ispName = data.isp
                self.colocationCenter = "\(data.country) / \(data.city)"
                self.timezone = data.timezone
                self.org = data.org
            } else {
                self.publicIP = "Error"
            }
        }
        
    }
    
}
 
struct InfoRow: View {
    let key: String
    let value: String
    var isConfidential: Bool = false
    
    @State private var isRevealed: Bool = false
    
    var body: some View {
        HStack {
            Text(key)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
                .blur(radius: (isConfidential && !isRevealed) ? 5 : 0)
                .opacity((isConfidential && !isRevealed) ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isRevealed)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isConfidential {
                        isRevealed.toggle()
                    }
                }
                .onHover { inside in
                    if isConfidential {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                .help(isConfidential ? "Click to reveal / hide" : "")
        }
    }
}

