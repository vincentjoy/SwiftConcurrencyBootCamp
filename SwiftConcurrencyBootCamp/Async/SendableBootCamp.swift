// From the tutorial - https://youtu.be/wSmTbtOwgbE?si=lSwDLdv8xiXZFqMc

import SwiftUI

actor CurrentUserManager {
    
    func updateDataBase() {
        
    }
}

class SendableBootCampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        await manager.updateDataBase()
    }
}

struct SendableBootCamp: View {
    
    @StateObject private var viewModel = SendableBootCampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await viewModel.updateCurrentUserInfo()
            }
    }
}

#Preview {
    SendableBootCamp()
}
