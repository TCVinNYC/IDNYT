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
    var lowTemp: Double = 96.0
    var highTemp: Double = 100.0
    @State var locationIndex = 0
    @State var answerIndex = 0
    @State var secondAnswerIndex = 0
    @State var temp: Double = 0
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section{
                        Picker(selection: $locationIndex, label: Text("Please select the campus you wish to attend").padding()){
                            ForEach(0 ..< locations.count){
                                Text(self.locations[$0])
                            }
                        }
                    }
                    Section(footer: Text("In Fahrenheit F° (Ex: 98.6)")){
                        Section{
                            TextField("TAKE AND REPORT TEMPERATURE AT HOME", value: $temp,format: .number).padding()
                        }
                    }
                    Section{
                        Picker(selection: $answerIndex, label: Text("HAVE YOU TESTED POSITIVE FOR COVID-19 IN THE PAST 10 DAYS?")){
                            ForEach(0 ..< answers.count){
                                Text(self.answers[$0])
                            }
                        }
                    }
                    Section{
                        Picker(selection: $secondAnswerIndex, label: Text("HAVE YOU HAD ANY OF THESE COVID-19 SYMPTOMS SINCE YOUR LAST VISIT TO CAMPUS (UP TO 10 DAYS AGO)? \n a. Cough \n b. Shortness of breath or difficulty breathing \n Fever \n d. New loss of taste or smell \n e. Nausea, vomiting or diarrhea \n f. Congestion or runny nose")){
                            ForEach(0 ..< secondAnswers.count){
                                Text(self.secondAnswers[$0])
                            }
                        }
                    }
                    
                }
                NavigationLink(destination: GreenHSView(), label: {Text("Continue").frame(width: 200, height: 50, alignment: .center).background(Color.blue).foregroundColor(.white).cornerRadius(8)})
            }
            .navigationBarTitle("Health Screen")
        }
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
