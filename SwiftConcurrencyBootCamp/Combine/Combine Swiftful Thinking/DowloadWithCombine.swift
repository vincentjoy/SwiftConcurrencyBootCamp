// From the tutorial - https://youtu.be/fdxFp5vU6MQ?si=vlOdj2MFvhxxNWvg

import SwiftUI
import Combine

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

@Observable final class DowloadWithCombineViewModel {
    
    var posts: [PostModel] = []
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        // Combine Steps
        // 1. Create the publisher
        // 2. Subscribe publisher on background thread
        // 3. Receive on main thread
        // 4. tryMap - tom make sure response is not bad and data is not error
        // 5. decode (to decode data into PostModel) - to make sure item is correct
        // 6. sink - to put/use the data into our app
        // 7. store - to cancel subscription if needed
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background)) // This is actually not needed, because dataTaskPublisher will already be in a background thread
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    print("Do some actions required after finish")
                case .failure(let error):
                    print("Hanlde the failure case")
                }
            } receiveValue: { [weak self] returnedPosts in
                self?.posts = returnedPosts
            }
            .store(in: &cancellables)
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 299
        else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}

struct DowloadWithCombine: View {
    
    @State private var vm = DowloadWithCombineViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.body)
                        .foregroundStyle(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    DowloadWithCombine()
}
