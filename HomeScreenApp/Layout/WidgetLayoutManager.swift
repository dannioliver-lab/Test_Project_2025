import SwiftUI
import Foundation

class WidgetLayoutManager: ObservableObject {
    @Published var widgets: [any HomeScreenWidget] = []
    @Published var layoutConfiguration: LayoutConfiguration
    
    init() {
        self.layoutConfiguration = LayoutConfiguration()
        setupDefaultWidgets()
    }
    
    var gridColumns: [GridItem] {
        layoutConfiguration.gridColumns
    }
    
    private func setupDefaultWidgets() {
        // Initialize with default widget set
        widgets = [
            WeatherWidget(),
            QuickActionsWidget(),
            NewsWidget(),
            StatsWidget(),
            StatsWidget() // Second stats widget with different data
        ]
    }
    
    func addWidget(_ widget: any HomeScreenWidget) {
        widgets.append(widget)
    }
    
    func removeWidget(withId id: UUID) {
        widgets.removeAll { $0.id == id }
    }
    
    func moveWidget(from source: IndexSet, to destination: Int) {
        widgets.move(fromOffsets: source, toOffset: destination)
    }
    
    func refreshAllWidgets() async {
        await withTaskGroup(of: Void.self) { group in
            for widget in widgets {
                if widget.isRefreshable {
                    group.addTask {
                        await widget.refresh()
                    }
                }
            }
        }
    }
    
    func getWidget(withId id: UUID) -> (any HomeScreenWidget)? {
        return widgets.first { $0.id == id }
    }
    
    func updateLayoutConfiguration(_ config: LayoutConfiguration) {
        layoutConfiguration = config
    }
}
