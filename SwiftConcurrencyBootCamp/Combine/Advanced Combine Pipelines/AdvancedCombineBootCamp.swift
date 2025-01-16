// From the tutorial - https://youtu.be/RUZcs0SWqnI?si=86V3KlQ4XOXi3XoL

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
//    @Published var basicPublisher: String = "First Publisher"
//    let currentValuePublisher = CurrentValueSubject<String, Error>("First Publisher")
    let passthroughPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items = Array(1..<11)
        for x in items.indices {
            let sec = Double(x)
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
//                self.basicPublisher = items[x]
//                self.currentValuePublisher.send(items[x])
                self.passthroughPublisher.send(items[x])
                
                if x == items.indices.last {
                    self.passthroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}

class AdvancedCombineBootCampViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var error: String = ""
    let dataService = AdvancedCombineDataService()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.passthroughPublisher
        
        // Operations we can add to our publisher pipeline
        
        // Sequence operations
        /*
            // .first() // Only the first publisher coming through it will be published
            // .first(where: { $0 > 4 }) // Can add conditions to what to publish
            // .tryFirst(where: { value in
            //     if value == 3 {
            //         throw URLError(.badURL)
            //     }
            //     return value > 1
            // })
            // .last() // For last to work, it is mandatory for publisher to send the finished completion, like inside the publishFakeData() method in AdvancedCombineDataService
            // .last(where: { $0 < 4 })
            // .tryLast(where: { value in
            //     if value == 13 {
            //         throw URLError(.badURL)
            //     }
            //     return value > 1
            // })
            // .dropFirst() // This comes handly if the publisher is CurrentValueSubject, which has an initial value and we need to drop that value
            // .dropFirst(3) // will drop the first 3 publishers
            // .drop(while: { $0 < 5 })
            // .tryDrop(while: { value in
            //     if value == 15 {
            //         throw URLError(.badURL)
            //     }
            //     return value < 6
            // })
            // .prefix(4) // will receive the first 4 publishers
            // .output(at: 3) // output at one of the indexes
            // .output(in: 3...5)
            // .output(in: 2..<8)
         */
        
        // Mathematic operations
        /*
            // .max()
            // .max(by: { int1, int2 in
            //     return int1 < int2 // Maximum number where it was greater than the previous number
            // })
            // .tryMax()
            // .min()
            // .tryMin(by:)
         */
        
        // Filter / Reducing Operations
        /*
            // .map({ String($0) })
            // .tryMap({ value in
            //     if value == 5 {
            //         throw URLError(.badURL)
            //     }
            //     return String(value)
            // })
            // .compactMap({ value in
            //     if value == 5 {
            //         return nil
            //     }
            //     return "\(value)"
            // })
            // .tryCompactMap()
            // .filter({ ($0 > 3) && ($0 < 9) })
            // .tryFilter()
            // .removeDuplicates()
            // .removeDuplicates(by: { int1, int2 in
            //     return int1 == int2
            // })
            // .tryRemoveDuplicates(by: )
            // .replaceNil(with: 5) // works if the stream is of optional type
            // .replaceEmpty(with: []) // Works if the response is a collection of arrays
            // .replaceError(with: "Better description of error")
            // .scan(0, { existingValue, newValue in
            //     return existingValue + newValue
            // })
            // .scan(0, { $0 + $1 })
            // .scan(0, +)
            // .tryScan(, )
            // .reduce(0, { existingValue, newValue in
            //     return existingValue + newValue
            // })
            // .reduce(0, +)
            // .collect() // wait and collect the entire stream, then publish finally. So receiveValue here will be sending a colection rather than individual element (so append method wont work)
            // .collect(3) // same as above, but defining the size of the collection
            // .allSatisfy({ $0/3 == 1 }) // returns the stream only if all the streams satisfy this condition
            // .tryAllSatisfy()
         */
        
            .map({ String($0) })
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self.error = "ERROR - \(error.localizedDescription)"
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
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
        }
    }
}

#Preview {
    AdvancedCombineBootCamp()
}
