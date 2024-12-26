// From the tutorial - https://youtu.be/4dQOnNYjO58?si=Y4hj41CbGc90KUqS

import SwiftUI

actor TitleDataBase {
    
    func getNewTitle() -> String {
        "New Title"
    }
}

@Observable class ObservableMacroViewModel: ObservableObject {
    
    @ObservationIgnored let dataBase = TitleDataBase()
    @MainActor var title: String = "Starting Title"
    
    func updateTitle() async {
        let title = await dataBase.getNewTitle()
        
        await MainActor.run {
            self.title = title
        }
    }
    
    func updateTitle2() {
        Task { @MainActor in
            title = await dataBase.getNewTitle()
        }
    }
    
    @MainActor
    func updateTitle3() async {
        title = await dataBase.getNewTitle()
    }
}

struct ObservableMacroBootCamp: View {
    
    @State private var viewModel = ObservableMacroViewModel()
    
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
