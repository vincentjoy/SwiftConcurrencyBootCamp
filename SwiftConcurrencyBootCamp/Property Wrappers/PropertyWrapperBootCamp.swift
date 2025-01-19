// From the tutorial - https://youtu.be/2wzq6SQkSJE?si=vuT0nWpYll_kyw4u

import SwiftUI

extension FileManager {
    static func documensPath() -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "custom_file.txt")
    }
}

@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    
    @State private var title: String
    var wrappedValue: String {
        get {
            title
        } nonmutating set {
            saveTitle(newValue)
        }
    }
    
    init() {
        do {
            title = try String(contentsOf: FileManager.documensPath(), encoding: .utf8)
        } catch {
            title = "Starting Title"
            print("Error getting the title")
        }
    }
    
    func saveTitle(_ newTitle: String) {
        do {
            try newTitle.write(to: FileManager.documensPath(), atomically: false, encoding: .utf8)
            title = newTitle
        } catch {
            print("Error saving the file: \(error.localizedDescription)")
        }
    }
}

struct PropertyWrapperBootCamp: View {
    
    @FileManagerProperty private var title: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text(title).font(.largeTitle)
            Button("Click me 1") {
                title = "title 1"
            }
            Button("Click me 2") {
                title = "title 2"
            }
        }
    }
}

#Preview {
    PropertyWrapperBootCamp()
}
