// From the tutorial - https://youtu.be/OpJcInSZpc8?si=pLhrqAOgEM39Vrkw

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some data"
    }
}

actor MyManagerActor {
    
    func getData() async throws -> String {
        "Some data"
    }
}

final class MVVMBootCampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func onCallToActionButtonTapped() {
        let task = Task {
            do {
                myData = try await managerClass.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

struct MVVMBootCamp: View {
    
    @StateObject var viewModel = MVVMBootCampViewModel()
    
    var body: some View {
        Button("Click Me") {
            viewModel.onCallToActionButtonTapped()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

#Preview {
    MVVMBootCamp()
}
