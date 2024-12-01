import Foundation

@Observable
class DoCatchTryThrowsBootCampViewModel {
    var startingText: String = "Starting text"
    let manager: DoCatchTryThrowsBootCampDataManager = .init()
    
    func fetchTitle() {
        do {
            let newTitle = try manager.getTitle()
            startingText = newTitle
        } catch {
            startingText = error.localizedDescription
        }
    }
}

class DoCatchTryThrowsBootCampDataManager {
    
    let isActive: Bool = false
    
    func getTitle() throws -> String {
        if isActive {
            return "New text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
