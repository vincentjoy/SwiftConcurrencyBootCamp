// From the tutorial - https://youtu.be/Q-1EDHXUunI?si=7Z5bVj3DTGScymJN

import SwiftUI
import Combine

@Observable final class SubscriberBootCampViewModel {
    
    var count: Int = 0
    private var timer: AnyCancellable?
    
    var textFieldText: String = "" {
        didSet {
            textFieldTextPublisher.send(textFieldText)
        }
    }
    private let textFieldTextPublisher = PassthroughSubject<String, Never>()
    var textIsValid: Bool = false
    var showButton: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupTimer()
        addTextFieldSubscriber()
        addButtonSubscriber()
    }
    
    private func setupTimer() {
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.count += 1
                
                if count >= 10 {
                    self.timer?.cancel()
                }
            })
    }
    
    private func addTextFieldSubscriber() {
        textFieldTextPublisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // basically adding a delay before map is called
            .map { $0.count > 3 }
            .sink(receiveValue: { [weak self] isValid in
                self?.textIsValid = isValid
            })
            .store(in: &cancellables)
    }
    
    private func addButtonSubscriber() {
        
    }
}

struct SubscriberBootCamp: View {
    
    @State private var vm = SubscriberBootCampViewModel()
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            TextField("Type your message here..", text: $vm.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color.red.opacity(0.5))
                .cornerRadius(10)
                .overlay (
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.red)
                            .opacity(
                                vm.textFieldText.count < 1 ? 0 :
                                vm.textIsValid ? 0 : 1
                            )
                        
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.green)
                            .opacity(vm.textIsValid ? 1 : 0)
                    }
                    .font(.headline)
                    .padding(.trailing)
                    
                    , alignment: .trailing
                )
            
            Button {
                
            } label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .opacity(vm.showButton ? 1 : 0.5)
            }
            .disabled(!vm.showButton)
        }
        .padding()
    }
}

#Preview {
    SubscriberBootCamp()
}
