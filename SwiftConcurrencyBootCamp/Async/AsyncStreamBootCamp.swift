// from the tutorial - https://youtu.be/gi38bouUI2Q?si=Wn-iMja2kyco9xFq

import SwiftUI

class AsyncStreamDataMananger {
    
    func getAsyncStream() -> AsyncStream<Int> {
        AsyncStream(Int.self) { continuation in
            self.getFakeData { value in
                continuation.yield(value)
            }
        }
    }
    
    func getFakeData(completion: @escaping (Int) -> Void) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                completion(item)
            })
        }
    }
}

@MainActor
final class AsyncStreamBootCampViewModel: ObservableObject {
    
    let manager = AsyncStreamDataMananger()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
//        manager.getFakeData { [weak self] item in
//            self?.currentNumber = item
//        }
        Task {
            for await value in manager.getAsyncStream() {
                currentNumber = value
            }
        }
    }
}

struct AsyncStreamBootCamp: View {
    
    @StateObject private var viewModel = AsyncStreamBootCampViewModel()
    
    var body: some View {
        Text("\(viewModel.currentNumber)")
            .onAppear {
                viewModel.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootCamp()
}
