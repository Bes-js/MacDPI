import SwiftUI

struct InstallationView: View {
    var onComplete: () -> Void
    
    @State private var statusMessage: String = "Checking system…"
    @State private var isBusy: Bool = false
    @State private var hasBrew = false
    @State private var hasSpoof = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            Image(systemName: "gear.badge.checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.blue)
            
            Text("MacDPI Setup Wizard")
                .font(.title)
                .bold()
            
            Text("The following components must be installed for the application to run.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Image(systemName: hasBrew ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(hasBrew ? .green : .gray)
                    
                    VStack(alignment: .leading) {
                        Text("Homebrew Package Manager")
                            .font(.headline)
                        Text(hasBrew ? "Installed" : "Missing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if !hasBrew {
                        Button("Install") {
                            installBrew()
                        }
                        .disabled(isBusy)
                    }
                }
                
                HStack {
                    Image(systemName: hasSpoof ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(hasSpoof ? .green : .gray)
                    
                    VStack(alignment: .leading) {
                        Text("SpoofDPI Core")
                            .font(.headline)
                        Text(hasSpoof ? "Installed" : "Missing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if !hasBrew {
                        Text("Homebrew First")
                            .font(.caption)
                            .foregroundColor(.orange)
                    } else if !hasSpoof {
                        Button("Install") {
                            installSpoof()
                        }
                        .disabled(isBusy)
                    }
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            Spacer()
            
            if isBusy {
                HStack {
                    ProgressView()
                        .scaleEffect(0.5)
                    Text(statusMessage)
                        .font(.caption)
                }
            } else {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if hasBrew && hasSpoof {
                Button(action: {
                    onComplete()
                }) {
                    Text("Complete Setup and Start")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.green)
            }
        }
        .padding(40)
        .frame(width: 500, height: 600)
        .onAppear {
            checkLocalStatus()
        }
    }
    
    
    func checkLocalStatus() {
        hasBrew = DependencyManager.shared.isHomebrewInstalled()
        hasSpoof = DependencyManager.shared.isSpoofDPIInstalled()
        
        if hasBrew && hasSpoof {
            statusMessage = "All requirements are ready!"
        } else if !hasBrew {
            statusMessage = "Please install Homebrew first."
        } else {
            statusMessage = "Homebrew is ready, now install SpoofDPI."
        }
    }
    
    func installBrew() {
        isBusy = true
        statusMessage = "Waiting for administrator permission… Please enter your password."
        
        DependencyManager.shared.installHomebrew { success, msg in
            isBusy = false
            if success {
                statusMessage = "Homebrew installed successfully!"
                checkLocalStatus()
            } else {
                statusMessage = "An error occurred: \(msg)"
            }
        }
    }
    
    func installSpoof() {
        isBusy = true
        statusMessage = "Downloading SpoofDPI…"
        
        DependencyManager.shared.installSpoofDPI { success, msg in
            isBusy = false
            if success {
                statusMessage = "Installation successful!"
                checkLocalStatus()
            } else {
                statusMessage = "An error occurred: \(msg)"
            }
        }
    }
}
