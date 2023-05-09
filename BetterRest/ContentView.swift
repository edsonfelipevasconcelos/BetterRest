//
//  ContentView.swift
//  BetterRest
//
//  Created by EDSON FELIPE VASCONCELOS on 17/04/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeup = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private var recommendedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeup - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error"
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.purple, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                Form {
                    Section("When do you want to wake up?") {
                        DatePicker("Please, enter a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    
                    Section("Desired amount of sleep") {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    Section("Daily coffee intake") {
                        Picker(coffeeAmount == 1 ? "1 cup" : "cups", selection: $coffeeAmount) {
                            ForEach(1...20, id: \.self) { number in
                                Text("\(number) cup")
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
//                        Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    }
                    
                    Section {
                        Text("Recommended bedtime \(recommendedBedtime)")
                            .font(.headline)
                    }
                }
                .navigationTitle("BetterRest")
//                .toolbar {
//                    Button("Calculate", action: calculateBedtime)
//                }
//                .alert(alertTitle, isPresented: $showingAlert) {
//                    Button("Ok") { }
//                } message: {
//                    Text(alertMessage)
//                }
            .padding()
            }
        }
        .scrollDisabled(true)
    }
    
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//            
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//            let sleepTime = wakeup - prediction.actualSleep
//            alertTitle = "Your ideal bedtime is.."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//        }
//        
//        showingAlert = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
