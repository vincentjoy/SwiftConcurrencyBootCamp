// From the tutorial - https://youtu.be/TERHgCD_tGA?si=Ui1ptzloOOl_TtdH

import SwiftUI

@propertyWrapper
struct Capitalized: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        } nonmutating set {
            value = newValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
}

@propertyWrapper
struct Uppercased: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        } nonmutating set {
            value = newValue.uppercased()
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.uppercased()
    }
}

struct User: Codable {
    let name: String
    let age: Int
    let isPremium: Bool
}

@propertyWrapper
struct FileManagerCodableProperty<T:Codable>: DynamicProperty {
    
    @State private var value: T?
    let key: String
    
    var wrappedValue: T? {
        get {
            value
        } nonmutating set {
            saveValue(value)
        }
    }
    
//    var projectedValue: Binding<T?> { // Projected value is optional, only if this property is passed around as a binding property
//        Binding {
//            wrappedValue
//        } set: { newValue in
//            wrappedValue = newValue
//        }
//
//    }
    
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documensPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
        } catch {
            _value = State(wrappedValue: nil)
            print("Error getting the title")
        }
    }
    
    func saveValue(_ newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue!)
            try data.write(to: FileManager.documensPath(key: key))
            value = newValue
        } catch {
            print("Error saving the file: \(error.localizedDescription)")
        }
    }
}

struct PropertyWrapper2BootCamp: View {
    
    @Capitalized private var title: String = "Hello, World!"
    @FileManagerCodableProperty("user_profile") private var userProfile: User?
    
    var body: some View {
        VStack(spacing: 40) {
            Button(title) {
                title = "new title"
            }
            Button(userProfile?.name ?? "NA") {
                userProfile = User(name: "VJ", age: 75, isPremium: true)
            }
        }
    }
}

#Preview {
    PropertyWrapper2BootCamp()
}
