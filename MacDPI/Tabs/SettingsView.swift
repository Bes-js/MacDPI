import SwiftUI


struct SettingsView: View {
    
    @State private var selectedTab: String = "General"
    @State private var previousTab: String = "General"

    var body: some View {
        TabView(selection: $selectedTab) {
            
            GeneralSettingsView()
                .id(selectedTab)
                .tabItem {
                    Image(systemName: "gear")
                    Text("General")
                }
                .tag("General")
            
            ConnectionSettingsView()
                .id(selectedTab)
                .tabItem {
                    Image(systemName: "network")
                    Text("Connection")
                }
                .tag("Connection")
            
            DNSSettingsView()
                .id(selectedTab)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("DNS")
                }.tag("DNS")
            
            PatternSettingsView()
                .id(selectedTab)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Pattern")
                }.tag("Pattern")
            
            AdvancedSettingsView()
                .id(selectedTab)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Advanced")
                }.tag("Advanced")
            
            Color.clear
                .tabItem {
                    Label("Support", systemImage: "envelope")
                }
                .tag("Support")
        }
        .onChange(of: selectedTab) { _,newValue in
                    if newValue == "Support" {
                      
                        if let url = URL(string: "https://buymeacoffee.com/beykant") {
                            NSWorkspace.shared.open(url)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            selectedTab = previousTab
                        }
                    } else {
                        previousTab = newValue
                    }
                }
            .tabViewStyle(.automatic)
            .tint(.white)
            .frame(width: 670, height: 420)
            .padding()
    }
}

