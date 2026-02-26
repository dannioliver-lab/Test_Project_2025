import SwiftUI

struct GreetingWidget: View {
    let name: String
    let customMessage: String?
    
    init(_ name: String, message: String? = nil) {
        self.name = name
        self.customMessage = message
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greetingText)
                .font(.title2)
                .fontWeight(.medium)
            
            Text(dateText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var greetingText: String {
        if let customMessage {
            return customMessage.replacingOccurrences(of: "{name}", with: name)
        }
        
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting = switch hour {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"  
        case 17..<22: "Good evening"
        default: "Good night"
        }
        
        return "\(timeGreeting), \(name)"
    }
    
    private var dateText: String {
        Date().formatted(date: .complete, time: .omitted)
    }
}

#Preview {
    VStack(spacing: 20) {
        GreetingWidget("Sarah")
        
        GreetingWidget("Alex", message: "Welcome back, {name}!")
        
        GreetingWidget("Jordan", message: "Ready for another great day, {name}?")
    }
    .padding()
}
