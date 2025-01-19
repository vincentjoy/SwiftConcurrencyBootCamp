// From the tutorial - https://youtu.be/2wzq6SQkSJE?si=vuT0nWpYll_kyw4u

import SwiftUI

struct FileManagerProperty {
    
    var title: String = "Starting Title"
    
    private var path: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "custom_file.txt")
    }
    
    mutating func load() {
        do {
            title = try String(contentsOf: path, encoding: .utf8)
        } catch {
            print("Error getting the title")
        }
    }
    
    mutating func saveTitle(_ newTitle: String) {
        do {
            try newTitle.write(to: path, atomically: false, encoding: .utf8)
            title = newTitle
        } catch {
            print("Error saving the file: \(error.localizedDescription)")
        }
    }
}

struct PropertyWrapperBootCamp: View {
    
    @State var fileManagerProperty = FileManagerProperty()
    
    var body: some View {
        VStack(spacing: 24) {
            Text(fileManagerProperty.title).font(.largeTitle)
            Button("Click me 1") {
                fileManagerProperty.saveTitle("title 1")
            }
            Button("Click me 2") {
                fileManagerProperty.saveTitle("title 2")
            }
        }
        .onAppear {
            fileManagerProperty.load()
        }
    }
}

#Preview {
    PropertyWrapperBootCamp()
}
