// From the tutorial - https://youtu.be/RUZcs0SWqnI?si=86V3KlQ4XOXi3XoL

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
    @Published var basicPublisher: String = ""
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items = ["one", "two", "three"]
        for x in items.indices {
            let sec = Double(x)
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.basicPublisher = items[x]
            }
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
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
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
