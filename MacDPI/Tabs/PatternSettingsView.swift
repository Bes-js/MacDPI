import SwiftUI
import SwiftData

extension PatternItem {
    var iconURL: URL? {
        return URL(string: "https://www.google.com/s2/favicons?domain=\(domain)&sz=64")
    }
}

struct PatternSettingsView: View {
  
    @Environment(\.modelContext) private var modelContext
    @Query private var services: [Services]
   
    var activeService: Services? {
        services.first
    }
    
    @State private var selectedItem: PatternItem?
    
    let containerColor = Color(nsColor: .controlBackgroundColor)
    
    var body: some View {
        VStack(spacing: 0) {
       
            VStack(spacing: 4) {
                Text("Pattern")
                    .font(.system(size: 20, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Applies DPI bypass only to packets that match the given domain patterns.")
                    .font(.system(size: 12, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(containerColor)
            
            Divider()
            
            List(selection: $selectedItem) {
              
                let patterns = activeService?.patterns ?? []
                
                ForEach(patterns) { item in
                    DomainRowView(item: item)
                        .tag(item)
                }
            }
            .listStyle(.plain)
            .background(Color.black.opacity(0.3))
            
            HStack(spacing: 0) {
                Button(action: addNewDomain) {
                    Image(systemName: "plus").frame(width: 24, height: 24)
                }
                .buttonStyle(.borderless)
                .overlay(Rectangle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                
                Button(action: removeSelectedDomain) {
                    Image(systemName: "minus").frame(width: 24, height: 24)
                }
                .buttonStyle(.borderless)
                .overlay(Rectangle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                .disabled(selectedItem == nil)
                
                Spacer()
                
                Text("“Double-click the text to edit the added domain addresses.”")
                    .font(.system(size: 10, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
            }
            .background(containerColor)
            .frame(height: 28)
        }
        .frame(width: 590, height: 380)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    
    func addNewDomain() {
        guard let service = activeService else { return }
        
        let newId = Int(Date().timeIntervalSince1970)
        let newItem = PatternItem(id: newId, domain: "example.com")
        
        service.patterns.append(newItem)
        selectedItem = newItem
    }
    
    func removeSelectedDomain() {
        guard let itemToDelete = selectedItem,
              let service = activeService else { return }
     
        if let index = service.patterns.firstIndex(where: { $0.id == itemToDelete.id }) {
            service.patterns.remove(at: index)
        }
     
        modelContext.delete(itemToDelete)
        
        selectedItem = nil
    }
}


struct DomainRowView: View {

    @Bindable var item: PatternItem
    
    @State private var isEditing: Bool = false
    @FocusState private var focusedField: Bool
    
    var body: some View {
        HStack(spacing: 8) {
     
            AsyncImage(url: item.iconURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .empty, .failure:
                    Image(systemName: "globe")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 20, height: 20)
            .clipShape(Circle())
            
            if isEditing {
               
                TextField("Domain", text: $item.domain)
                    .textFieldStyle(.plain)
                    .focused($focusedField)
                    .onSubmit {
                        isEditing = false
                    }
                    .onAppear {
                        focusedField = true
                    }
            } else {
                Text(item.domain)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        isEditing = true
                    }
            }
        }
        .padding(.vertical, 2)
    }
}
