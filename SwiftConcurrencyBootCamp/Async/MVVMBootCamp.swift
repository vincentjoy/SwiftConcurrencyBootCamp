// From the tutorial - https://youtu.be/OpJcInSZpc8?si=pLhrqAOgEM39Vrkw

import SwiftUI

final class MyManagerClass {
    
}

actor MyManagerActor {
    
}

final class MVVMBootCampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
}

struct MVVMBootCamp: View {
    
    @StateObject var viewModel = MVVMBootCampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MVVMBootCamp()
}
