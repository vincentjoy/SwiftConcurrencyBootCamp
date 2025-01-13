// From the tutorial - https://youtu.be/ymXRX6ZB-J0?si=SUTHPKZy3yehi0Sv

import SwiftUI

struct TimerBootCamp: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Current Time
    /*
    @State private var currentDate: Date = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    */
    
    // Count down
    /*
    @State private var counter: Int = 10
    @State private var finishedText: String?
    */
    
    // Count down to date
    @State private var timeRemaining: String = ""
    private let futureData: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color(.blue), Color(.red)]),
                center: .center,
                startRadius: 5,
                endRadius: 500)
            .ignoresSafeArea()
            
            // Current Time
            /*
            Text(dateFormatter.string(from: currentDate))
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
             */
            
            // Count down
            /*
            Text(finishedText ?? "\(counter)")
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
             */
            
            // Count down to date
            Text(timeRemaining)
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
        .onReceive(timer) { value in
            // Current Time
            /* currentDate = value */
            
            // Count down
            /*
            if counter < 1 {
                finishedText = "Wow!"
            } else {
                counter -= 1
                finishedText = nil
            }
            */
            
            // Count down to date
            updateTimeRemaining()
        }
    }
    
    private func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(), to: futureData)
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(hour):\(minute):\(second)"
    }
}

#Preview {
    TimerBootCamp()
}
