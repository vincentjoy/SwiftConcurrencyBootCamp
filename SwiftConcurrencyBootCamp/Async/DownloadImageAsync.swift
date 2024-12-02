//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Vincent Joy on 01/12/24.
//

import SwiftUI

class DownloadImageAsyncImageLoader {
    
    private func handleResponse(data: Data?, response: URLResponse) -> UIImage? {
        guard let data, let image = UIImage( data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200, response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: "https://i.picsum.photos/id/1/200/300.jpg")!, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

@Observable
final class DownloadImageAsyncViewModel {
    var image: UIImage?
    let loader = DownloadImageAsyncImageLoader()
    
    func fetchmages() async {
        self.image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}

struct DownloadImageAsync: View {
    
    private var viewModel: DownloadImageAsyncViewModel = .init()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchmages()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
