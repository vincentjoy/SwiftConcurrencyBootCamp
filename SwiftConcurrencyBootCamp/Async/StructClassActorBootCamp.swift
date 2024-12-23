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

struct MyStruct {
    var title: String
}

extension StructClassActorBootCamp {
    
    private func runTest() {
        print("Test Started")
        structTest1()
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting Title")
        print("ObjectA: \(objectA.title)")
        
        print("Pass the values of objectA to objectB")
        var objectB = objectA
        print("ObjectB: \(objectB.title)")
        
        objectB.title = "New Title"
        print("ObjectB title changed")
        
        print("ObjectA title: \(objectA.title)")
        print("ObjectB title: \(objectB.title)")
    }
}
