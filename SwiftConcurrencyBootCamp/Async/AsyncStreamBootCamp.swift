// from the tutorial - https://youtu.be/gi38bouUI2Q?si=Wn-iMja2kyco9xFq

import SwiftUI

class AsyncStreamDataMananger {
    
    func getFakeData() -> Int {
        1234
    }
}

@MainActor
final class AsyncStreamBootCampViewModel: ObservableObject {
    
    let manager = AsyncStreamDataMananger()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
        currentNumber = manager.getFakeData()
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
