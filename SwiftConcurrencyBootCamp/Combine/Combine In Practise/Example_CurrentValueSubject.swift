//
//  Example_CurrentValueSubject.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Vincent Joy on 01/04/25.
//

import SwiftUI
import Combine

class ButtonTapPublisher {
    // CurrentValueSubject holds the latest value and broadcasts it to new subscribers
    let buttonTapped = CurrentValueSubject<String, Never>("No message yet")
    
    static let shared = ButtonTapPublisher()
    
    private init() {}
}

// First view with a button that publishes events
struct Example_CurrentValueSubject: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("First View")
                .font(.title)
                .padding()
            
            Button("Send Message A") {
                // This will now be stored and available to future subscribers
                ButtonTapPublisher.shared.buttonTapped.send("Message A")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Send Message B") {
                ButtonTapPublisher.shared.buttonTapped.send("Message B")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            // NavigationLink("Go to Second View", destination: SecondView()).padding()
            
            NavigationLink("Go to Second View", destination: SecondViewWithViewModel())
                .padding()
        }
    }
}

// Second view that subscribes to button tap events
struct SecondView: View {
    // Use @ObservedObject to track the publisher directly
    @State private var receivedMessage = "No message yet"
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            Text("Second View")
                .font(.title)
                .padding()
            
            Text("Received: \(receivedMessage)")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .onAppear {
            // Get the current value when the view appears
            self.receivedMessage = ButtonTapPublisher.shared.buttonTapped.value
            
            // And subscribe to future updates
            ButtonTapPublisher.shared.buttonTapped
                .sink { message in
                    self.receivedMessage = message
                }
                .store(in: &cancellables)
        }
    }
}

#Preview {
    Example_CurrentValueSubject()
}

// Alternative approach using a view model
class MessageViewModel: ObservableObject {
    @Published var message: String = "No message yet"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to the button tap publisher
        ButtonTapPublisher.shared.buttonTapped
            .sink { [weak self] newMessage in
                self?.message = newMessage
            }
            .store(in: &cancellables)
    }
}

// Alternative second view using a view model
struct SecondViewWithViewModel: View {
    @StateObject private var viewModel = MessageViewModel()
    
    var body: some View {
        VStack {
            Text("Second View")
                .font(.title)
                .padding()
            
            Text("Received: \(viewModel.message)")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
    }
}
