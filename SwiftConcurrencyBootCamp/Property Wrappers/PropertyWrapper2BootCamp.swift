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

struct PropertyWrapper2BootCamp: View {
    
    @Capitalized private var title: String = "Hello, World!"
    
    var body: some View {
        VStack {
            Button(title) {
                title = "new title"
            }
        }
    }
}

#Preview {
    PropertyWrapper2BootCamp()
}
