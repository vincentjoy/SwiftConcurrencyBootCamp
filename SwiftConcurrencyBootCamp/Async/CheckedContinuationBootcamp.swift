import SwiftUI

class CheckedContinuationBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data {
                    continuation.resume(returning: data)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage?
    private let networkMaanger = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        do {
            let data = try await networkMaanger.getData(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject private var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
