// From the tutorial - https://youtu.be/2wzq6SQkSJE?si=vuT0nWpYll_kyw4u

import SwiftUI

extension FileManager {
    static func documensPath(key: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "key.txt")
    }
}

@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    
    @State private var title: String
    let key: String
    
    var wrappedValue: String {
        get {
            title
        } nonmutating set {
            saveTitle(newValue)
        }
    }
    
    init(key: String) {
        self.key = key
        do {
            title = try String(contentsOf: FileManager.documensPath(key: key), encoding: .utf8)
        } catch {
            title = "Starting Title"
            print("Error getting the title")
        }
    }
    
    func saveTitle(_ newTitle: String) {
        do {
            try newTitle.write(to: FileManager.documensPath(key: key), atomically: false, encoding: .utf8)
            title = newTitle
        } catch {
            print("Error saving the file: \(error.localizedDescription)")
        }
    }
}

struct PropertyWrapperBootCamp: View {
    
    @FileManagerProperty(key: "custom_title_1") private var title1: String
    @FileManagerProperty(key: "custom_title_2") private var title2: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text(title1).font(.largeTitle)
            Text(title2).font(.largeTitle)
            Button("Click me 1") {
                title1 = "title 1"
                title2 = "title 2"
            }
            Button("Click me 2") {
                title1 = "custom title 1"
                title2 = "custom title 2"
            }
        }
    }
}

#Preview {
    PropertyWrapperBootCamp()
}
