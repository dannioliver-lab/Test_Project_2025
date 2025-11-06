import SwiftUI

struct QuickActionCell: View {
    let action: QuickAction
    let configuration: CarouselConfiguration
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon container
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: action.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.blue)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            
            // Label
            Text(action.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1) // Limit extreme scaling
        }
        .frame(width: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            handleTap()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(action.actionType.description)
        .accessibilityAddTraits(.isButton)
    }
    
    private var accessibilityLabel: String {
        "Action: \(action.title)"
    }
    
    private func handleTap() {
        // Trigger haptic feedback if enabled
        if configuration.enableHapticFeedback {
            HapticManager.shared.lightImpact()
        }
        
        // Execute the action
        action.action()
    }
}

struct QuickActionCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            QuickActionCell(
                action: QuickAction(
                    title: "Start Build",
                    iconName: "hammer.fill",
                    actionType: .build,
                    action: { print("Build tapped") }
                ),
                configuration: .default
            )
            
            QuickActionCell(
                action: QuickAction(
                    title: "Scan Item",
                    iconName: "qrcode.viewfinder",
                    actionType: .scan,
                    action: { print("Scan tapped") }
                ),
                configuration: .default
            )
            
            QuickActionCell(
                action: QuickAction(
                    title: "Find Teammate",
                    iconName: "person.2.fill",
                    actionType: .findTeammate,
                    action: { print("Find teammate tapped") }
                ),
                configuration: .default
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
