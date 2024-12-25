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
    
    @MainActor @Published private(set) var myData: String = "Click Me"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    // One type of usage of MainActor
    // We need to mark it as MainActor because the myData here is marked as so, becasue it is useed in the UI
    @MainActor
    func onCallToActionButtonTapped() {
        let task = Task {
            do {
                myData = try await managerClass.getData()
                // myData = try await managerActor.getData() - Here instead if we use the MyManagerActor.getData() method, when it is called, it will go to the MyManagerActor and once it is completed, it will return to the MainActor
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
    func onCallToActionButtonTapped2() {
        let task = Task { @MainActor in // Another way of usage of MainActor, that is inside the Task which uses the myData
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
        VStack {
            Button(viewModel.myData) { // Since the myData here is coupled with the UI, it should be marked as the MainActor
                viewModel.onCallToActionButtonTapped()
            }
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

#Preview {
    MVVMBootCamp()
}
