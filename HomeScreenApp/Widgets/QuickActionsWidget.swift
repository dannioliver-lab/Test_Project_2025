import SwiftUI

class QuickActionsWidget: BaseWidget {
    let actions: [QuickAction]
    
    init() {
        self.actions = [
            QuickAction(title: "Messages", icon: "message.fill", color: .green),
            QuickAction(title: "Camera", icon: "camera.fill", color: .blue),
            QuickAction(title: "Calendar", icon: "calendar", color: .red),
            QuickAction(title: "Settings", icon: "gear", color: .gray)
        ]
        super.init(title: "Quick Actions", size: .medium, isRefreshable: false)
    }
    
    override var contentView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(actions, id: \.id) { action in
                QuickActionButton(action: action)
            }
        }
    }
}

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
}

struct QuickActionButton: View {
    let action: QuickAction
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Handle action tap
            print("Tapped \(action.title)")
        }) {
            VStack(spacing: 6) {
                Image(systemName: action.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text(action.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(action.color)
            .cornerRadius(8)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
        } onPressingChanged: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }
    }
}
