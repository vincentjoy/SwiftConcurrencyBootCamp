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
    /*
    @State private var timeRemaining: String = ""
    private let futureData: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    */
    
    // Animation Counter
    @State private var count: Int = 0
    
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
            /*
            Text(timeRemaining)
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            */
            
            
            // Animation Counter
            HStack(spacing: 15) {
                Circle()
                    .offset(y: count == 1 ? -20 : 0)
                Circle()
                    .offset(y: count == 2 ? -20 : 0)
                Circle()
                    .offset(y: count == 3 ? -20 : 0)
            }
            .frame(width: 200)
            .foregroundStyle(Color.white)
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
            /* updateTimeRemaining() */
            
            
            // Animation Counter
            withAnimation(.easeInOut(duration: 1.0)) {
                count = count == 3 ? 0 : count+1
            }
        }
    }
    
    /*
    private func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(), to: futureData)
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(hour):\(minute):\(second)"
    }
    */
}

#Preview {
    TimerBootCamp()
}
