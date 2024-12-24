// From the tutorial - https://youtu.be/wSmTbtOwgbE?si=lSwDLdv8xiXZFqMc

import SwiftUI

actor CurrentUserManager {
    
    func updateDataBase(userInfo: MyClassUserInfo) {
        // since MyClassUserInfo is Sendable, it will be thread safe and so can be passed into an actor
        // Try to use Struct or some value types if possible (struct still needs to be marked as sendable)
        // If class, mark it as unchecked sendable and handle the thread safety by using serial queue or lock or semaphore
    }
}

struct MyUserInfo: Sendable {
    var name: String
}

final class MyClassUserInfo: @unchecked Sendable { // Sendable
    
    var name: String
    let queue = DispatchQueue(label: "com.app.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootCampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info = MyClassUserInfo(name: "Vincent")
        await manager.updateDataBase(userInfo: info)
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
