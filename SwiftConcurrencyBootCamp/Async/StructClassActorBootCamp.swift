import SwiftUI

struct StructClassActorBootCamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActorBootCamp()
}

extension StructClassActorBootCamp {
    private func runTest() {
        print("Test Started")
    }
}
