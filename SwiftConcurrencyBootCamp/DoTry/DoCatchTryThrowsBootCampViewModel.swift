import Foundation

@Observable
class DoCatchTryThrowsBootCampViewModel {
    var startingText: String = "Starting text"
    let manager: DoCatchTryThrowsBootCampDataManager = .init()
    
    func fetchTitle() {
        do {
            if let newTitle = try? manager.getTitleOnlyError() {
                startingText = newTitle
            }
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
    
    func getTitleOnlyError() throws -> String {
        throw URLError(.badServerResponse)
    }
}
