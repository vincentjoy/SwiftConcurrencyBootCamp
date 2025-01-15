// From the tutorial - https://youtu.be/RUZcs0SWqnI?si=86V3KlQ4XOXi3XoL

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
    @Published var basicPublisher: [String] = []
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.basicPublisher = ["one", "two", "three"]
        }
    }
}

class AdvancedCombineBootCampViewModel: ObservableObject {
    
    @Published var data: [String] = []
    let dataService = AdvancedCombineDataService()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$basicPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Failed with error - \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] result in
                self?.data = result
            }
            .store(in: &cancellables)

    }
}

struct AdvancedCombineBootCamp: View {
    
    @StateObject private var vm = AdvancedCombineBootCampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.data, id: \.self) {
                    Text($0)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
            }
        }
    }
}

#Preview {
    AdvancedCombineBootCamp()
}
