// Practice codes from the lecture - https://youtu.be/-JLenSTKEcA?si=zNSw8dT43RMsSkYI


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

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

extension StructClassActorBootCamp {
    
    private func runTest() {
        print("Test Started")
//        structTest1()
//        classTest1()
        Task {
            await actorTest1()
        }
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting Title")
        print("ObjectA: \(objectA.title)")
        
        print("Pass the VALUES of objectA to objectB")
        var objectB = objectA
        print("ObjectB: \(objectB.title)")
        
        objectB.title = "New Title"
        print("ObjectB title changed")
        
        print("ObjectA title: \(objectA.title)")
        print("ObjectB title: \(objectB.title)")
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "Starting Title")
        print("ObjectA: \(objectA.title)")
        
        print("Pass the REFERENCE of objectA to objectB")
        let objectB = objectA
        print("ObjectB: \(objectB.title)")
        
        objectB.title = "New Title"
        print("ObjectB title changed")
        
        print("ObjectA title: \(objectA.title)")
        print("ObjectB title: \(objectB.title)")
    }
    
    private func actorTest1() async {
        let objectA = MyActor(title: "Starting Title")
        await print("ObjectA: \(objectA.title)")
        
        print("Pass the REFERENCE of objectA to objectB")
        let objectB = objectA
        await print("ObjectB: \(objectB.title)")
        
        await objectB.updateTitle(newTitle: "New Title")
        print("ObjectB title changed")
        
        await print("ObjectA title: \(objectA.title)")
        await print("ObjectB title: \(objectB.title)")
    }
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

// Mutable struct
struct MutatingStruct {
    var title: String
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootCamp {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title 1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title 2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title 1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title 2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title 1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title 2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title 1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title 2")
        print("Struct4: ", struct4.title)
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}
