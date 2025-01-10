import Foundation
import Combine

@Observable final class ZipOperatorBootCampViewModel {
    
    var userProfile: MainModel?
    private var cancellables = Set<AnyCancellable>()
    
    func getOnboardingData() {
        let publishers = Publishers.Zip(
            getPublisher(for: SubModel1.self, endpoint: .endPoint1),
            getPublisher(for: SubModel2.self, endpoint: .endPoint2)
        )
        
        publishers.map { (model1, model2) in
            MainModel(subModel1: model1, subModel2: model2)
        }
        
        .sink { (completion) in
            if case let .failure(error) = completion {
                print("Error -> \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] profileModel in
            self?.userProfile = profileModel
        }
        .store(in: &cancellables)
    }
    
    func getPublisher<T: Decodable>(for type: T.Type, endpoint: Endpoint) -> Future<[T], Error> {
        NetworkManagerCombine.shared.getData(endpoint: endpoint, type: T.self)
    }
}

struct MainModel: Decodable {
    var subModel1: [SubModel1]
    var subModel2: [SubModel2]
}

struct SubModel1: Decodable {
    
}

struct SubModel2: Decodable {
    
}
