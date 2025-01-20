// From the tutorial - https://youtu.be/FmjG6mG-GIA?si=aiAzG7ZkIEKdseMt

import SwiftUI

struct MyDataModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let count: Int
    let date: Date
}

extension Array {
    
    mutating func sortByKeypath<T:Comparable>(_ keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        return sort {
            let value1 = $0[keyPath: keyPath]
            let value2 = $1[keyPath: keyPath]
            return ascending ? value1 < value2 : value1 > value2
        }
    }
    
    func sortedByKeypath<T:Comparable>(_ keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        return sorted {
            let value1 = $0[keyPath: keyPath]
            let value2 = $1[keyPath: keyPath]
            return ascending ? value1 < value2 : value1 > value2
        }
    }
}

struct KeypathBootCamp: View {
    
    @State private var screentitle: String = ""
    @State private var dataArray: [MyDataModel] = []
    
    var body: some View {
        List {
            ForEach(dataArray) { item in
                VStack(alignment: .leading) {
                    Text(item.id)
                    Text(item.title)
                    Text("\(item.count)")
                    Text(item.date.description)
                }
                .font(.headline)
            }
        }
        .onAppear {
            let array = [
                MyDataModel(title: "Three", count: 3, date: .distantFuture),
                MyDataModel(title: "One", count: 1, date: .now),
                MyDataModel(title: "Two", count: 2, date: .distantPast)
            ]
            let sortedArray = array.sortedByKeypath(\.date, ascending: false)
            dataArray = sortedArray
        }
    }
}

#Preview {
    KeypathBootCamp()
}
