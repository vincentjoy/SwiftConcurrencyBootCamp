// From the tutorial - https://youtu.be/K91rKH_O8BY?si=xeXt8Scq75xSANZm

import SwiftUI

struct CustomBindingBootCamp: View {
    
    @State var title: String = "Start"
    @State var title2: String = "Start 2"
    @State private var errorTitle: String?
//    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            Text(title)
            ChildviewWithBinding(title: $title)
            ChildviewWithOldSchoolWay(title: title) { newTitle in
                title = newTitle
            }
            ChildviewWithBinding2(title: $title)
            
            // Binding the 3rd way, with set a binding property on the fly, rather than using a global @state property
            ChildviewWithBinding2(title: Binding(get: {
                title2
            }, set: { newValue in
                title2 = newValue
            }))
            
            Button("Click Me") {
                errorTitle = "New Error"
//                showError.toggle()
            }
        }
        .alert(errorTitle ?? "nA", isPresented: Binding(get: {
            (errorTitle != nil)
        }, set: { newValue in
            if !newValue {
                errorTitle = nil
            }
        })) {
            
        }
//        .alert(errorTitle ?? "NA", isPresented: $showError) {
//            Button("Ok") {
//                
//            }
//        }
    }
}

/// First binding type
struct ChildviewWithBinding: View {
    
    @Binding var title: String
    
    var body: some View {
        Text(title)
            .onAppear {
                title = "New title"
            }
    }
}

struct ChildviewWithOldSchoolWay: View {
    
    let title: String
    let setTitle: (String) -> Void
    
    var body: some View {
        Text(title)
            .onAppear {
                setTitle("New title 2")
            }
    }
}

/// Binding of different type
struct ChildviewWithBinding2: View {
    
    var title: Binding<String>
    
    var body: some View {
        Text(title.wrappedValue)
            .onAppear {
                title.wrappedValue = "New title 3"
            }
    }
}

#Preview {
    CustomBindingBootCamp()
}
