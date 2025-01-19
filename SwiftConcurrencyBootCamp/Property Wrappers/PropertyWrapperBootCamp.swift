// From the tutorial - https://youtu.be/2wzq6SQkSJE?si=vuT0nWpYll_kyw4u

import SwiftUI

struct PropertyWrapperBootCamp: View {
    
    @State private var title: String = "Starting Title"
    
    var body: some View {
        VStack(spacing: 24) {
            Text(title).font(.largeTitle)
            Button("Click me 1") {
                setTitleAsUpperCased("title 1")
            }
            Button("Click me 2") {
                setTitleAsUpperCased("title 2")
            }
        }
        .onAppear {
            do {
                let savedTitle = try String(contentsOf: path, encoding: .utf8)
                title = savedTitle
            } catch {
                print("Error getting the title")
            }
        }
    }
    
    private func setTitleAsUpperCased(_ title: String) {
        let newTitle = title.uppercased()
        self.title = newTitle
        saveTitle(newTitle)
    }
    
    private var path: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "custom_file.txt")
    }
    
    private func saveTitle(_ newTitle: String) {
        do {
            try newTitle.write(to: path, atomically: false, encoding: .utf8)
        } catch {
            print("Error saving the file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    PropertyWrapperBootCamp()
}
