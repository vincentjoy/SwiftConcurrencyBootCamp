// From the tutorial - https://youtu.be/HRHtOdTJH70?si=aE7j2d7Ejx2dCuwt

import SwiftUI

final class StrongSelfDataService {
    
    func getData() async -> String {
        "Updated data"
    }
}

class StrongSelfBootCampViewModel: ObservableObject {
    @Published var data: String = "Some title"
    let dataService = StrongSelfDataService()
    
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
}

struct StrongSelfBootCamp: View {
    
    @StateObject private var viewModel = StrongSelfBootCampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
    }
}

#Preview {
    StrongSelfBootCamp()
}
