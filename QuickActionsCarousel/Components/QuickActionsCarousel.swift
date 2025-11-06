import SwiftUI

struct QuickActionsCarousel: View {
    let actions: [QuickAction]
    let configuration: CarouselConfiguration
    
    @State private var scrollPosition: CGFloat = 0
    
    init(actions: [QuickAction], configuration: CarouselConfiguration = .default) {
        self.actions = actions
        self.configuration = configuration
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            HStack {
                Text("Quick Actions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Optional: Add "See All" button for future expansion
                if actions.count > 4 {
                    Button("See All") {
                        // Future: Navigate to full actions view
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            
            // Carousel scroll view
            ScrollView(.horizontal, showsIndicators: configuration.showsScrollIndicators) {
                LazyHStack(spacing: configuration.itemSpacing) {
                    ForEach(actions) { action in
                        QuickActionCell(
                            action: action,
                            configuration: configuration
                        )
                    }
                }
                .padding(.horizontal, configuration.horizontalPadding)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minX)
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollPosition = value
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled() // Allow content to peek beyond edges
            .contentMargins(.horizontal, configuration.horizontalPadding, for: .scrollContent)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Quick Actions")
        .accessibilityHint("Swipe horizontally to browse available actions")
    }
}

// MARK: - Scroll Position Tracking
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Preview
struct QuickActionsCarousel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            QuickActionsCarousel(actions: SampleActions.defaultActions)
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}
