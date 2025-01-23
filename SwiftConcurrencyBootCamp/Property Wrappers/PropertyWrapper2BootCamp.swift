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

struct FileManagerKeyPath<T:Codable> {
    let key: String
    let type: T.Type
}

struct FileManagerValues {
    static let shared = FileManagerValues()
    private init() {}
    let userProfile = FileManagerKeyPath(key: "user_profile", type: User.self)
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
    
    var projectedValue: Binding<T?> { // Need to add this property only if this is passed around as a binding property
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 })
    }
    
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
    
    init(_ key: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        let keyPath = FileManagerValues.shared[keyPath: key].key
        self.key = keyPath
        do {
            let url = FileManager.documensPath(key: keyPath)
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
//    @FileManagerCodableProperty("user_profile") private var userProfile: User?
//    @FileManagerCodableProperty(\.userProfile) private var userProfile: User?
    @FileManagerCodableProperty(\.userProfile) private var userProfile

    
    var body: some View {
        VStack(spacing: 40) {
            Button(title) {
                title = "new title"
            }
            SomeBindingView(userProfile: $userProfile)
        }
    }
}

struct SomeBindingView: View {
    
    @Binding var userProfile: User?
    
    var body: some View {
        Button(userProfile?.name ?? "NA") {
            userProfile = User(name: "VJ", age: 75, isPremium: true)
        }
    }
}

#Preview {
    PropertyWrapper2BootCamp()
}
