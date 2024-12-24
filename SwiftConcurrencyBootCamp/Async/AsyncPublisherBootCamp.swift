// From the tutorial - https://youtu.be/ePPm2ftSVqw?si=xmUZgQpjBqANOqy9

import SwiftUI

actor AsyncPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(for: .seconds(1))
        myData.append("Banana")
        try? await Task.sleep(for: .seconds(1))
        myData.append("Orange")
        try? await Task.sleep(for: .seconds(1))
        myData.append("Watermelon")
        try? await Task.sleep(for: .seconds(1))
    }
}

class AsyncPublisherBootCampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootCamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootCampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootCamp()
}
