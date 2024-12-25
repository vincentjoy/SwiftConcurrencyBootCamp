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
    private var someTask: Task<Void, Never>?
    
    // This implies strong reference
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This implies strong reference
    func updateData2() {
        Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // This implies strong reference
    func updateData3() {
        Task { [self] in
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a weak reference
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong
    // Because we can manage the Task
    func updateData5() {
        someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    
    func cancelTask() {
        someTask?.cancel()
        someTask = nil
    }
}

struct StrongSelfBootCamp: View {
    
    @StateObject private var viewModel = StrongSelfBootCampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTask()
            }
    }
}

#Preview {
    StrongSelfBootCamp()
}
