// From the tutorial on Actor - https://youtu.be/UUdi137FySk?si=C3Bzxe1gcnJWjeJC

import SwiftUI

class MyDataManager {
    static let instance = MyDataManager()
    private init() {}
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completion: @escaping ((String?) -> Void)) {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completion(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() {}
    var data: [String] = []
    
    nonisolated let myRandonData: String = "New Data"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getRandomDataNonIsolated() -> String {
        return "New Data"
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onTapGesture(perform: {
            let newString = manager.getRandomDataNonIsolated()
            print(newString)
            let randonString = manager.myRandonData
            print(randonString)
        })
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        }
    }
}

struct BrowseView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        }
    }
}

struct ActorBootCamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorBootCamp()
}
