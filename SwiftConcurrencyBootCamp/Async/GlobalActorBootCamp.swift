// From the tutorial - https://youtu.be/BRBhMrJj5f4?si=R98VWSsndVcvDlER

import SwiftUI

actor MyNewDataManager {
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three"]
    }
}

class GlobalActorBootViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    let manager = MyNewDataManager()
    
    func getData() async {
        let data = await manager.getDataFromDatabase()
        self.dataArray = data
    }
}

struct GlobalActorBootCamp: View {
    
    @StateObject private var viewModel = GlobalActorBootViewModel()
    
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
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootCamp()
}
