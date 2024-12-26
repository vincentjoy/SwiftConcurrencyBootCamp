// From the tutorial - https://youtu.be/4dQOnNYjO58?si=Y4hj41CbGc90KUqS

import SwiftUI

actor TitleDataBase {
    
    func getNewTitle() -> String {
        "New Title"
    }
}

@MainActor
class ObservableMacroViewModel: ObservableObject {
    
    let dataBase = TitleDataBase()
    @Published var title: String = "Starting Title"
    
    func updateTitle() async {
        title = await dataBase.getNewTitle()
    }
}

struct ObservableMacroBootCamp: View {
    
    @StateObject private var viewModel = ObservableMacroViewModel()
    
    var body: some View {
        Text(viewModel.title)
            .task {
                await viewModel.updateTitle()
            }
    }
}

#Preview {
    ObservableMacroBootCamp()
}
