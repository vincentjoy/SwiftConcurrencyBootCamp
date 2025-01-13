import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var response = [SampleModel]()
    
    func getHomeData() {
        NetworkManagerCombine.shared.getData(endpoint: .endPoint1, type: SampleModel.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            }
            receiveValue: { [weak self] response in
                self?.response = response
            }
            .store(in: &cancellables)
        }
}

struct SampleModel: Decodable, Identifiable, Hashable {
    var id: Int
    var fare: Int
    var stops: Int
    var serialNumber: String?
    var company: String?
}
