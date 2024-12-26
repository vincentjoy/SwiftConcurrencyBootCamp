// from the tutorial - https://youtu.be/gi38bouUI2Q?si=Wn-iMja2kyco9xFq

import SwiftUI

class AsyncStreamDataMananger {
    
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getFakeData(newValue: { value in
                continuation.yield(value)
            }, onFinish: { error in
                if let error {
                    continuation.finish(throwing: error)
                } else {
                    continuation.finish()
                }
            })
        }
    }
    
    func getFakeData(
        newValue: @escaping (Int) -> Void,
        onFinish: @escaping (Error?) -> Void
    ) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                newValue(item)
                
                if item == items.last {
                    onFinish(nil)
                }
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
            do {
                for try await value in manager.getAsyncStream() {
                    currentNumber = value
                }
            } catch {
                print(error)
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
