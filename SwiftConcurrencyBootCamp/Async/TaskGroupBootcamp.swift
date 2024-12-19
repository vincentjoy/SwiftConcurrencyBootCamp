import SwiftUI

class TaskGroupBootcampDataManager {
    
    func fetchImageswithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage5 = fetchImage(urlString: "https://picsum.photos/200")
        
        let (image1, image2, image3, image4, image5) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5)
        
        return [image1, image2, image3, image4, image5]
    }
    
    func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupBootcampDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImageswithAsyncLet() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupBootcamp: View {
    
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group 🥳")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupBootcamp()
}
