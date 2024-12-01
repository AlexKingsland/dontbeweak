import SwiftUI

struct ContentView: View {
    // Hardcoded data
    let birthDate = Calendar.current.date(from: DateComponents(year: 1998, month: 7, day: 25))!
    let lifeExpectancyYears = 75
    
    // Timer to update every second
    @State private var currentTime = Date()
    @State private var totalSecondsRemaining = 0
    @State private var secondsRemaining = 60
    @State private var minutesRemaining = 60
    @State private var hoursRemaining = 24
    @State private var daysRemaining = 0
    @State private var weeksRemaining = 0
    @State private var monthsRemaining = 0
    @State private var yearsRemaining = 0
    @State private var millisecondProportion: Double = 0.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Quote Section
                Text("Invest your money like Warren Buffet. Invest your time like a gambling addict.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Divider()
                
                // Timer Section (Horizontal Scrollable)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        TimerBox(unit: "Years", remaining: yearsRemaining, proportion: proportionThroughYear())
                        TimerBox(unit: "Months", remaining: monthsRemaining, proportion: proportionThroughMonth())
                        TimerBox(unit: "Weeks", remaining: weeksRemaining, proportion: proportionThroughWeek())
                        TimerBox(unit: "Days", remaining: daysRemaining, proportion: proportionThroughDay())
                        TimerBox(unit: "Hours", remaining: hoursRemaining, proportion: proportionThroughHour())
                        TimerBox(unit: "Minutes", remaining: minutesRemaining, proportion: proportionThroughMinute())
                        TimerBox(unit: "Seconds", remaining: secondsRemaining, proportion: millisecondProportion)
                    }
                    .padding()
                }
                
                Divider()
                
                // Grid Section (80 sets of 4x13 circles)
                VStack(spacing: 20) {
                    Text("Your Life in Weeks")
                        .font(.title2)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(0..<lifeExpectancyYears, id: \.self) { year in
                            YearGrid(
                                year: year,
                                birthDate: birthDate,
                                currentTime: Date(),
                                weeksPerYear: 52
                            )
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .foregroundColor(Color.black)
            
            Divider()
            
            // Bottom Quote Section
            Text("Be careful to not set your time horizon too short such that your actions are brash, or too long such that you live life as if you'll live forever.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            setupInitialValues()
            // Faster timer for smoother updates
            Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                updateProportions()
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                updateCountdown()
            }
        }
    }
    
    // Helper functions to calculate remaining time and proportions
    private func remainingYears() -> Int {
        lifeExpectancyYears - Calendar.current.dateComponents([.year], from: birthDate, to: currentTime).year!
    }
    
    private func remainingMonths() -> Int {
        lifeExpectancyYears - Calendar.current.dateComponents([.year], from: birthDate, to: currentTime).month!
    }
    
    private func remainingWeeks() -> Int {
        (remainingMonths() / 12) * 52
    }
    
    private func remainingDays() -> Int {
        let endDate = Calendar.current.date(byAdding: .year, value: lifeExpectancyYears, to: birthDate)!
        return Calendar.current.dateComponents([.day], from: currentTime, to: endDate).day!
    }
    
    private func remainingHours() -> Int {
        remainingDays() * 24
    }
    
    private func remainingMinutes() -> Int {
        remainingHours() * 60
    }
    
    private func remainingSeconds() -> Int {
        remainingMinutes() * 60
    }
    
    // Update proportions dynamically for the seconds clock
    private func updateProportions() {
        let now = Date()
        let milliseconds = Calendar.current.component(.nanosecond, from: now) / 1_000_000
        millisecondProportion = Double(milliseconds) / 1_000.0
    }
    
    // Set up initial values
    private func setupInitialValues() {
        let now = Date()
        let calendar = Calendar.current
        let endOfLife = calendar.date(byAdding: .year, value: lifeExpectancyYears, to: birthDate)!
        
        // Calculate total seconds remaining
        totalSecondsRemaining = Int(endOfLife.timeIntervalSince(now))
        calculateRemainingUnits()
    }
    
    // Update countdown dynamically
    private func updateCountdown() {
        totalSecondsRemaining -= 1
        if totalSecondsRemaining > 0 {
            calculateRemainingUnits()
        }
    }
    
    // Calculate remaining units from total seconds
    private func calculateRemainingUnits() {
        secondsRemaining = totalSecondsRemaining
        minutesRemaining = (totalSecondsRemaining / 60)
        hoursRemaining = (totalSecondsRemaining / 3600)
        daysRemaining = (totalSecondsRemaining / 86400)
        weeksRemaining = totalSecondsRemaining / (86400 * 7)
        monthsRemaining = weeksRemaining / 4
        yearsRemaining = monthsRemaining / 12
    }
    
    // Helper functions to calculate proportions
    private func proportionThroughYear() -> Double {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
        let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
        let elapsed = Date().timeIntervalSince(startOfYear)
        let total = endOfYear.timeIntervalSince(startOfYear)
        return elapsed / total
    }
    
    private func proportionThroughMonth() -> Double {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let elapsed = Date().timeIntervalSince(startOfMonth)
        let total = endOfMonth.timeIntervalSince(startOfMonth)
        return elapsed / total
    }
    
    private func proportionThroughWeek() -> Double {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
        let elapsed = Date().timeIntervalSince(startOfWeek)
        let total = endOfWeek.timeIntervalSince(startOfWeek)
        return elapsed / total
    }
    
    private func proportionThroughDay() -> Double {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let elapsed = Date().timeIntervalSince(startOfDay)
        let total = endOfDay.timeIntervalSince(startOfDay)
        return elapsed / total
    }
    
    private func proportionThroughHour() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let currentMinute = calendar.component(.minute, from: now)
        let secondsPastMinute = calendar.component(.second, from: now)
        let elapsed = Double(currentMinute * 60 + secondsPastMinute)
        return elapsed / 3600.0
    }
    
    private func proportionThroughMinute() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let currentSecond = calendar.component(.second, from: now)
        let elapsed = Double(currentSecond)
        return elapsed / 60.0
    }
    
    private func proportionThroughSecond() -> Double {
        let now = Date()
        let milliseconds = Calendar.current.component(.nanosecond, from: now) / 1_000_000
        return Double(milliseconds) / 1_000.0
    }
}

// TimerBox with Dynamic Numbers
struct TimerBox: View {
    let unit: String
    let remaining: Int
    let proportion: Double
    
    var body: some View {
        VStack {
            ZStack {
                // Base circle (white background)
                Circle()
                    .fill(Color.white)
                
                // Filling circle (progress indicator)
                Circle()
                    .trim(from: 0, to: proportion)
                    .stroke(Color.black, lineWidth: 8)
                    .rotationEffect(.degrees(-90)) // Starts filling from 12:00 position
                
                // Clock hand
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 2, height: 40)
                    .offset(y: -20)
                    .rotationEffect(.degrees(proportion * 360)) // Rotates with the proportion
            }
            .frame(width: 80, height: 80)
            
            Text("\(remaining)")
                .font(.largeTitle)
                .monospacedDigit()
            Text(unit)
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// Life Grid for a Single Year
struct YearGrid: View {
    let year: Int
    let birthDate: Date
    let currentTime: Date
    let weeksPerYear: Int
    
    var body: some View {
        VStack {
            Text("Year \(year)")
                .font(.caption)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(10), spacing: 5), count: 4), spacing: 5) {
                ForEach(0..<52, id: \.self) { week in
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .background(
                            Circle()
                                .foregroundColor(circleColor(week: week))
                        )
                        .frame(width: 8, height: 8)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func circleColor(week: Int) -> Color {
        let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: currentTime)
        let currentYear = Calendar.current.component(.year, from: currentTime)
        let thisYear = Calendar.current.date(byAdding: .year, value: year, to: birthDate) ?? Date()
        let yearOfGrid = Calendar.current.component(.year, from: thisYear)
        
        if currentYear > yearOfGrid || (currentYear == yearOfGrid && week < currentWeekOfYear) {
            return Color.black
        } else if currentYear == yearOfGrid && week == currentWeekOfYear {
            return Color.red
        } else {
            return Color.clear
        }
    }
}
