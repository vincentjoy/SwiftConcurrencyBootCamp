// From the titorial - https://youtu.be/UiU0y2wQTLw?si=NJq3G0av51UYLgZt

import SwiftUI

final class RefreshableDataService {
    func getData() async throws -> [String] {
        try await Task.sleep(for: .seconds(3))
        return ["Apple", "Orange", "Banana"].shuffled()
    }
}

@MainActor
final class RefreshableBootCampViewModel: ObservableObject {
    
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataService()
    
    func loadData() async {
        do {
            items = try await manager.getData()
        } catch {
            print(error)
        }
    }
}

struct RefreshableBootCamp: View {
    
    @StateObject private var viewModel = RefreshableBootCampViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.items, id:\.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    RefreshableBootCamp()
}
