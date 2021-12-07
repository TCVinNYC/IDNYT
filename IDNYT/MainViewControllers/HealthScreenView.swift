//
//  ContentView.swift
//  Test
//
//  Created by Jeffrey Aguilar on 12/2/21.
//

import SwiftUI

struct HealthScreenView: View {
    var locations = ["Long Island, NY", "New York, New York", "Jonesboro, AR", "Vancouver, Canada"]
    var answers = ["Yes", "No"]
    var secondAnswers = ["Yes", "No"]
    @State var selectedLocation = " "
    @State var selectedAnswer = " "
    @State var selectedSecondAnswer = " "
    @State var temp = " "
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section{
                        Picker(selection: $selectedLocation, label: Text("Please select the campus you wish to attend").padding()){
                            ForEach(locations, id: \.self){
                                Text($0)
                            }
                        }
                    }

                    Section(footer: Text("In Fahrenheit F° (Ex: 98.6)")){
                        Section{
                            TextField("TAKE AND REPORT TEMPERATURE AT HOME",text: $temp).padding()
                        }
                    }
                    Section{
                        Picker(selection: $selectedAnswer, label: Text("HAVE YOU TESTED POSITIVE FOR COVID-19 IN THE PAST 10 DAYS?")){
                            ForEach(answers, id: \.self){
                                Text($0)
                            }
                        }
                    }

                    Section{
                        Picker(selection: $selectedSecondAnswer, label: Text("HAVE YOU HAD ANY OF THESE COVID-19 SYMPTOMS SINCE YOUR LAST VISIT TO CAMPUS (UP TO 10 DAYS AGO)? \n a. Cough \n b. Shortness of breath or difficulty breathing \n Fever \n d. New loss of taste or smell \n e. Nausea, vomiting or diarrhea \n f. Congestion or runny nose")){
                            ForEach(secondAnswers, id: \.self){
                                Text($0)
                            }
                        }
                    }

                    
                }
                NavigationLink(destination: ConfirmationHSView(selectedLocation: $selectedLocation, temp: $temp, selectedAnswer: $selectedAnswer, selectedSecondAnswer: $selectedSecondAnswer), label: {Text("Continue").frame(width: 200, height: 50, alignment: .center).background(Color.blue).foregroundColor(.white).cornerRadius(8)})
            }
            .navigationBarTitle("Health Screen")
        }
    }
}

struct ConfirmationHSView : View{
    @Binding var selectedLocation: String
    @Binding var temp: String
    @Binding var selectedAnswer: String
    @Binding var selectedSecondAnswer: String
    let correctAnswer = "No"
    let secondCorrectAnswer = "No"
    var lowTemp: Double = 96.0
    var highTemp: Double = 100.0
    var number: String{
        guard let temp = Double(temp) else{
            return "USE NUMBERS ONLY."
        }
        return String("\(temp) F°")
    }
    var body: some View{
            VStack{
                Form{
                    
                    Section{
                        Text("Campus accessing: \(self.selectedLocation)").padding()
                    }
                    
                    Section{
                        Text("Temperature Recorded: \(number)").padding()
                    }
                    
                    Section{
                        Text("Have you tested positive for COVID-19 in the past 10 days: \(self.selectedAnswer)").padding()
                    }
                    
                    Section{
                        Text("Have you had any of these Covid-19 symptoms since your last visit to campus (UP TO 10 DAYS AGO): \(self.selectedSecondAnswer)").padding()
                    }
                    
                }

                if(self.selectedAnswer == correctAnswer && self.selectedSecondAnswer == secondCorrectAnswer){
                    NavigationLink(destination: GreenHSView(), label: {Text("Continue").frame(width: 200, height: 50, alignment: .center).background(Color.blue).foregroundColor(.white).cornerRadius(8)})
                }
                else{
                    NavigationLink(destination: RedHSView(), label: {Text("Continue").frame(width: 200, height: 50, alignment: .center).background(Color.blue).foregroundColor(.white).cornerRadius(8)})
                }

            }
            .navigationTitle(Text("Confirm Your Answers"))
    }
}

struct GreenHSView : View{
    var body: some View{
            VStack{
                Spacer()
                
                Image("HealthScreen_Check").resizable().aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("Welcome to New York Tech. \nYou are cleared for campus access today. \nPlease remember to wear a face covering at all times while on campus.")
                    .font(.title2)
                    .fontWeight(.semibold).padding()
                    
                
                Spacer()
            }
            .navigationTitle(Text("NYIT HEALTH SCREEN"))
    }
}

struct RedHSView : View{
    var body: some View{
            VStack{
                Spacer()
                
                Image("HealthScreen_Alert").resizable().aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("You are not cleared for campus access today. \nPlease stay home.")
                    .font(.title2)
                    .fontWeight(.semibold).padding()
                    
                
                Spacer()
            }
            .navigationTitle(Text("NYIT HEALTH SCREEN"))

    }
}

struct BlueHSView : View{
    var body: some View{
            VStack{
                Spacer()
                
                Image("HealthScreen_Exclamation2").resizable().aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("You may access campus for the day as long as you provide additional documentation: proof of vaccination or proof of a negative COVID test within past seven days")
                    .font(.title2)
                    .fontWeight(.semibold).padding()
                    
                
                Spacer()
            }
            .navigationTitle(Text("NYIT HEALTH SCREEN"))

    }
}

struct HealthScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HealthScreenView()
    }
}




