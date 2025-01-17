// From the tutorial - https://youtu.be/yCGbhbFK8sY?si=i00RA6W7VFV_g3qb

import SwiftUI
import Combine

class FuturesBootCampViewModel: ObservableObject {
    
    @Published var title: String = "Futures Bootcamp"
    private let url: URL = .init(string: "https://example.com/data.json")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        download()
    }
    
    private func download() {
//        getCombinePublisher()
//            .sink { _ in
//                
//            } receiveValue: { [weak self] returnedValue in
//                self?.title = returnedValue
//            }
//            .store(in: &cancellables)

//        getEscapingClosures { [weak self] returnedValue, error in
//            self?.title = returnedValue
//        }
        
        getFuturePublisher()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    /// Example 1
    private func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New Value 1"
            })
            .eraseToAnyPublisher()
    }
    
    private func getEscapingClosures(completionHandler: @escaping ((String, Error?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("New Value 2", nil)
        }
        .resume()
    }
    
    private func getFuturePublisher() -> Future<String, Error> {
        return Future { [weak self] promise in
            self?.getEscapingClosures(completionHandler: { returnedValue, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            })
        }
    }
    
    /// Example 2
    private func doSomethingClosureWay(_ completion: @escaping ((String) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion("New Value 3")
        }
    }
    
    private func doTheSameCombineWay() -> Future<String, Never> {
        return Future { promise in
            self.doSomethingClosureWay { value in
                promise(.success(value))
            }
        }
    }
}

struct FuturesBootCamp: View {
    
    @StateObject private var vm = FuturesBootCampViewModel()
    
    var body: some View {
        Text(vm.title)
    }
}

#Preview {
    FuturesBootCamp()
}
