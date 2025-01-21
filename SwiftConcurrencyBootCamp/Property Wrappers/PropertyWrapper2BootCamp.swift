// From the tutorial - https://youtu.be/TERHgCD_tGA?si=Ui1ptzloOOl_TtdH

import SwiftUI

struct PropertyWrapper2BootCamp: View {
    
    @State private var title: String = "Hello, World!"
    
    var body: some View {
        VStack {
            Button(title) {
                title = "new title".capitalized
            }
        }
    }
}

#Preview {
    PropertyWrapper2BootCamp()
}
