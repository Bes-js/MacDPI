import SwiftUI
import SwiftData
import AppKit
import Combine
import Foundation
import UserNotifications

enum ConnectionStatus: String {
    case disconnected = "Disconnected"
    case connecting = "Connecting..."
    case connected = "Connected"
}

class AppState: ObservableObject {
    @Published var isWorking: Bool {
            didSet {
                UserDefaults.standard.set(isWorking, forKey: "isWorking")
            }
        }
    @Published var status: ConnectionStatus = .disconnected
    
    init() {
        self.isWorking = UserDefaults.standard.bool(forKey: "isWorking")
    }
    
}

@main
struct MacDPIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /*
    init() {
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
                UserDefaults.standard.synchronize()
            }
        }
     */
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @Published var status: ConnectionStatus = .disconnected
    
    var isToggleOn: Bool {
        get { status == .connected || status == .connecting }
        set { }
    }

    static var shared: AppDelegate!
    
    @Query private var servicesList: [Services]
    private let dpiEngine = DPIEngine()

    
    var statusItem: NSStatusItem?
    var installationWindow: NSWindow?
    var onboardingWindow: NSWindow?
    var popover = NSPopover()
    var settingsWindow: NSWindow?
    var appState = AppState()
    var cancellables = Set<AnyCancellable>()
    var breathingTimer: Timer?
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Services.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted { }
            }
        
        
        AppDelegate.shared = self
        
        if DependencyManager.shared.areDependenciesReady() == false {
            openInstallationWindow()
            return
        }
        
        
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            openOnboardingWindow()
        } else {
            setupMenuBar()
            
            if appState.isWorking {
                toggleConnection(targetState: true)
            }
        }
    }
    
    @MainActor
    func toggleConnection(targetState: Bool) {
        
        if targetState {
            
            self.appState.status = .connecting
            self.startBreathingAnimation(baseColor: .systemYellow)
            self.updateButtonTitle(color: .systemYellow)
            
            
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000)
                
                let context = sharedModelContainer.mainContext
                let descriptor = FetchDescriptor<Services>()
                let config = (try? context.fetch(descriptor))?.first ?? Services()
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                let success = await dpiEngine.startDPI(with: config)
                
                await MainActor.run {
                    if success {
                        self.appState.status = .connected
                        self.startBreathingAnimation(baseColor: .systemGreen)
                        self.updateButtonTitle(color: .systemGreen)
                        self.appState.isWorking = true
                    } else {
                        self.appState.status = .disconnected
                        self.appState.isWorking = false
                        self.stopBreathingAnimation()
                        self.updateButtonTitle(color: .systemRed)
                    }
                }
            }
            
        } else {
            
            let context = sharedModelContainer.mainContext
            let descriptor = FetchDescriptor<Services>()
            let config = (try? context.fetch(descriptor))?.first ?? Services()
            
            DispatchQueue.main.async {
                self.appState.status = .disconnected
                self.appState.isWorking = false
                self.stopBreathingAnimation()
                self.updateButtonTitle(color: .systemRed)
            }
            
            Task {
                await dpiEngine.stopDPI(with: config)
            }
        }
    }


    
    func openOnboardingWindow() {
            NSApp.setActivationPolicy(.regular)
            
            let onboardingView = OnboardingView { [weak self] in
                self?.finishOnboarding()
            }
            
            let hostingController = NSHostingController(rootView: onboardingView)
            
            let windowSize = NSSize(width: 600, height: 450)
            
            let window = NSWindow(
                contentRect: NSRect(origin: .zero, size: windowSize),
                styleMask: [.titled, .closable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.isMovableByWindowBackground = true
            window.contentViewController = hostingController
            window.isReleasedWhenClosed = false
            window.center()
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            
            self.onboardingWindow = window
        }
  
        func finishOnboarding() {
            
            onboardingWindow?.close()
            onboardingWindow = nil
        
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            
            setupMenuBar()
        }
    
    func setupMenuBar() {

        if let window = installationWindow {
            window.close()
            installationWindow = nil
        }
        
        NSApp.setActivationPolicy(.accessory)
        
        let menuView = MacDPIView(openSettings: openSettingsWindow)
            .environmentObject(appState)
            .modelContainer(sharedModelContainer)

        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: menuView)
        popover.contentViewController?.view.wantsLayer = true
        popover.contentSize = NSSize(width: 300, height: 230)
        popover.contentViewController?.view.layer?.backgroundColor = NSColor(Color("Background")).cgColor
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            if let image = NSImage(named: "gps") {
                image.size = NSSize(width: 18, height: 18)
                image.isTemplate = true
                button.image = image
            }
            
            let font = NSFont.systemFont(ofSize: 13, weight: .bold)
            let attributedString = NSMutableAttributedString(string: "MacDPI")
            attributedString.addAttributes([.foregroundColor: NSColor.labelColor, .font: font], range: NSRange(location: 0, length: 3))
            attributedString.addAttributes([.foregroundColor: NSColor.red, .font: font], range: NSRange(location: 3, length: 3))
            button.attributedTitle = attributedString
            
            button.imagePosition = .imageLeft
            button.font = .systemFont(ofSize: 13, weight: .bold)
            button.action = #selector(togglePopover(_:))
        }
        
        appState.$isWorking
            .sink { [weak self] connected in
                DispatchQueue.main.async {
                    let imageName = connected ? "gps.fill" : "gps"
                    if let image = NSImage(named: imageName) {
                        image.size = NSSize(width: 18, height: 18)
                        image.isTemplate = true
                        self?.statusItem?.button?.image = image
                    }
                    
                    if connected {
                        self?.startBreathingAnimation(baseColor: .systemGreen)
                    } else {
                        self?.stopBreathingAnimation()
                        self?.updateButtonTitle(color: .systemRed, shadow: nil)
                        
                    }
                }
            }
            .store(in: &cancellables)
            
    }

    func openInstallationWindow() {
        
        let installationView = InstallationView { [weak self] in
            self?.setupMenuBar()
        }
        
        let hostingController = NSHostingController(rootView: installationView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.center()
        window.title = "MacDPI Installation"
        window.contentViewController = hostingController
        window.isReleasedWhenClosed = false
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        
        self.installationWindow = window
    }
    
    

    func startBreathingAnimation(baseColor: NSColor) {
        breathingTimer?.invalidate()
    
        let startTime = Date()
        
        breathingTimer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let currentTime = Date().timeIntervalSince(startTime)
            let speed: Double = 2.5
            let normalizedValue = (sin(currentTime * speed) + 1) / 2
            
            let shadow = NSShadow()
            shadow.shadowColor = baseColor.withAlphaComponent(0.4 * normalizedValue + 0.3)
            shadow.shadowBlurRadius = CGFloat(15 * normalizedValue)
            shadow.shadowOffset = .zero
            
            self.updateButtonTitle(color: baseColor, shadow: shadow)
        }
    }

    func stopBreathingAnimation() {
        breathingTimer?.invalidate()
        breathingTimer = nil
    }
    
    
    func animateMenuBarText(to targetColor: NSColor, duration: TimeInterval = 0.3) {
        guard let button = self.statusItem?.button else { return }
        
        let currentAttrString = button.attributedTitle
        var startColor = NSColor.labelColor
        
        if currentAttrString.length > 3 {
            let attributes = currentAttrString.attributes(at: 3, effectiveRange: nil)
            if let color = attributes[.foregroundColor] as? NSColor {
                startColor = color
            }
        }
        
        let startTime = Date()
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            let now = Date()
            let elapsed = now.timeIntervalSince(startTime)
       
            if elapsed >= duration {
                self.updateButtonTitle(color: targetColor)
                timer.invalidate()
                return
            }
            
            let percentage = CGFloat(elapsed / duration)
            let interpolatedColor = self.interpolateColor(from: startColor, to: targetColor, percentage: percentage)
            
            self.updateButtonTitle(color: interpolatedColor)
        }
    }

   
    func interpolateColor(from: NSColor, to: NSColor, percentage: CGFloat) -> NSColor {
        guard let c1 = from.usingColorSpace(.sRGB),
              let c2 = to.usingColorSpace(.sRGB) else { return to }
        
        let red = c1.redComponent + (c2.redComponent - c1.redComponent) * percentage
        let green = c1.greenComponent + (c2.greenComponent - c1.greenComponent) * percentage
        let blue = c1.blueComponent + (c2.blueComponent - c1.blueComponent) * percentage
        let alpha = c1.alphaComponent + (c2.alphaComponent - c1.alphaComponent) * percentage
        
        return NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }

    
    
    func updateButtonTitle(color: NSColor, shadow: NSShadow? = nil) {
        guard let button = self.statusItem?.button else { return }
        let font = NSFont.systemFont(ofSize: 13, weight: .bold)
        
        let attributedString = NSMutableAttributedString(string: "MacDPI")
        
        attributedString.addAttributes([
            .foregroundColor: NSColor.labelColor,
            .font: font
        ], range: NSRange(location: 0, length: 3))
        
        var dpiAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        
        if let shadow = shadow {
            dpiAttributes[.shadow] = shadow
        }
        
        attributedString.addAttributes(dpiAttributes, range: NSRange(location: 3, length: 3))
        
        button.attributedTitle = attributedString
    }
    
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    
    
    func openSettingsWindow() {
            if settingsWindow == nil {
                settingsWindow = NSWindow(
                    contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
                    styleMask: [.titled, .closable, .miniaturizable],
                    backing: .buffered, defer: false)
                settingsWindow?.title = "Settings"
                settingsWindow?.center()
                settingsWindow?.isReleasedWhenClosed = false
                
                let settingsRoot = SettingsView()
                    .modelContainer(sharedModelContainer)
                
                settingsWindow?.contentView = NSHostingView(rootView: settingsRoot)
            }
            settingsWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            NSApp.setActivationPolicy(.regular)
    
        }
    
    
}


struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}


struct MacDPIView: View {
    @EnvironmentObject var appState: AppState
    var openSettings: () -> Void
    var appVersion = "ALPHA"
    
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    
                    Image(appState.isWorking ? "gps.fill" : "gps")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MacDPI")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text("by Bes-js")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer(minLength: 2)
                    
                    
                    Text(appVersion)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(4)
                    
                    HStack(spacing: 15) {
                        
                        BuyMeCoffeeButton()
                        SettingsButton(openSettings: openSettings)
                        CloseButton()
                    }
                    .padding(.leading, 10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 15)
                
                Spacer()
                
                let toggleBinding = Binding<Bool>(
                    get: { appState.status == .connected || appState.status == .connecting },
                    set: { newValue in
                            AppDelegate.shared.toggleConnection(targetState: newValue)
                        }
                )
                
                GpsToggle(isOn: toggleBinding, status: appState.status)
               
                Text(appState.status.rawValue)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(.top, 10)
                    .opacity(appState.status == .connecting ? 0.8 : 1.0)
                    .animation(.easeInOut, value: appState.status)
                
                Spacer()
                
            }
        }
        .frame(width: 300, height: 230)
    }
}
