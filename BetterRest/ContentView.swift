//
//  ContentView.swift
//  BetterRest
//
//  Created by Logesh Raja on 12/1/24.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUpTime = Date.now
    @State private var coffeAmount = 1
    @State private var AlertTitle = " "
    @State private var alertMessage = " "
    @State private var showingAlert = false
    var body: some View {
        NavigationStack {
            Form {
                
                
                VStack(alignment: .leading, spacing: 10){
                    Text("When do you want to wake up")
                        .font(.headline)
                    DatePicker("Please Enter a Date", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 10){
                    Text("Desired Sleep Amount")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 10){
                    Text("Daily Coffe Amount ")
                        .font(.headline)
                    
                    Stepper("\(coffeAmount.formatted()) cup", value: $coffeAmount, in: 1...5, step: 1)
                    Picker("\(coffeAmount.formatted()) cup",selection: $coffeAmount){
                        Text("1 cup").tag(1)
                        Text("2 cups").tag(2)
                        Text("3 cups").tag(3)
                        Text("4 cups").tag(4)
                        Text("5 cups").tag(5)
                    }
                    .pickerStyle(.segmented)
                    
                    Button("Calculate Bed Time", systemImage: "bed.double", action: calculateBedTime)
                        .buttonStyle(.bordered)
                }
                    
                
            }
            .alert(AlertTitle, isPresented: $showingAlert){
                Button("Ok"){
                    
                }
            } message: {
                Text(alertMessage)
            }
                
            
            .navigationTitle("Better Rest")
        }
        .ignoresSafeArea()
    }

//        .background(.red)
       
    func calculateBedTime() {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            let sleepTime = wakeUpTime - prediction.actualSleep
            AlertTitle = "Your Bed Time"
            alertMessage = "You should go to bed at \(sleepTime.formatted(date: .omitted, time: .shortened))"
            
            
        } catch{
            AlertTitle = "Error"
            alertMessage = "Sorry there was a problem calculating your bed time."
            
        }
        showingAlert = true
        
        
        
        
        
    }
}

#Preview {
    ContentView()
}
