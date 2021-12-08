//
//  HealthScreenView.swift
//
//
//  Created by Jeffrey Aguilar on 12/2/21.
//

import SwiftUI
import FirebaseAuth

struct HealthScreenView: View {
    @State var completedQuestions = false
    @State var answerResult = -1
    
    var locations = ["Long Island, NY", "New York, New York", "Jonesboro, AR", "Vancouver, Canada"]
    var answers = ["Yes", "No"]
    var secondAnswers = ["Yes", "No"]
    
    @State var selectedLocation = ""
    @State var selectedAnswer = ""
    @State var selectedSecondAnswer = ""
    @State var temp = ""
    
    @State private var showingAlert = false
    @State private var confirmView = false
   // @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        NavigationView{
            if(completedQuestions){
                CompletedHealthView(selection: answerResult)
            }else{
                
                VStack{
                    Form{
                        Section(header: Text("Fill out truthfully")){
                            HStack{
                                Text("Select the campus you wish to attend")
                                    .frame(width: 190, alignment: .leading)
                                Spacer()
                                Picker("", selection: $selectedLocation) {
                                    ForEach(locations, id: \.self){
                                        Text($0)
                                    }
                                }
                                Spacer()
                            }.padding(.all, 10)
//                                .onTapGesture {
//                                    nameIsFocused = false
//                        }
                        }
                        
                        Section(header: Text("TAKE AND REPORT TEMPERATURE AT HOME"), footer: Text("In Fahrenheit F° (Ex: 98.6)")){
                            HStack{
                                Text("Enter Temperature: ")
                                    .frame(width: 200, alignment: .leading)
                                
                                Divider()
                                TextField("Enter",text: $temp)
                                    .keyboardType(.decimalPad)
                                    //.focused($nameIsFocused)
                                Spacer()
                            }.padding(.all, 10)
                        }
                        
                        Section{
                            HStack{
                                Text("HAVE YOU TESTED POSITIVE FOR COVID-19 IN THE PAST 10 DAYS?")
                                 //   .frame(width: 190, alignment: .leading)
                                Spacer()
                                Picker("", selection: $selectedAnswer) {
                                    ForEach(answers, id: \.self){
                                        Text($0)
                                    }
                                }
                                Spacer()
                            }.padding(.all, 10)
//                                .onTapGesture {
//                                    nameIsFocused = false
//                        }
                        }

                        Section{
                            HStack{
                                Picker(selection: $selectedSecondAnswer, label: Text("HAVE YOU HAD ANY OF THESE COVID-19 SYMPTOMS SINCE YOUR LAST VISIT TO CAMPUS (UP TO 10 DAYS AGO)? \n a. Cough \n b. Shortness of breath or difficulty breathing \n Fever \n d. New loss of taste or smell \n e. Nausea, vomiting or diarrhea \n f. Congestion or runny nose")){
                                    ForEach(secondAnswers, id: \.self){
                                        Text($0)
                                    }
                                }
                                Spacer()
                            }.padding(.all, 10)
//                                .onTapGesture {
//                                    nameIsFocused = false
//                                }
                        }
                    }
                    .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
                    
                    .navigationBarItems(trailing:
                    NavigationLink(destination: ConfirmationHSView(selectedLocation: $selectedLocation, temp: $temp, selectedAnswer: $selectedAnswer, selectedSecondAnswer: $selectedSecondAnswer), isActive: $confirmView) {
                        Button(action: {
                          //  nameIsFocused = false
                            if(selectedLocation.isEmpty || temp.isEmpty || selectedAnswer.isEmpty || selectedSecondAnswer.isEmpty){
                                self.showingAlert = true
                            }else{
                                self.confirmView = true
                            }
                            
                        }, label: {
                            Text("Submit").bold().foregroundColor(Color("AccentColor"))
                        })
                    })
                    .alert("You're Missing Some Fields!", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }}
                .navigationBarTitle("Health Screen Questions")
            }
                
        }
        .onChange(of: confirmView, perform: { newValue in
            guard let lastDate : String = UserDefaults.standard.object(forKey: "setDate") as? String else{
                print("no date")
                return
            }
            if lastDate != getCurrentDate(){
                print("does not equal")
                return
            }else{
                answerResult = UserDefaults.standard.object(forKey: "answerResult") as? Int ?? 0
                self.completedQuestions = true
                print("you've completed today")
                return
            }
        })
        
        .onAppear {
            guard let lastDate : String = UserDefaults.standard.object(forKey: "setDate") as? String else{
                print("no date")
                return
            }
            if lastDate != getCurrentDate(){
                print("does not equal")
                return
            }else{
                answerResult = UserDefaults.standard.object(forKey: "answerResult") as? Int ?? 0
                self.completedQuestions = true
                print("you've completed today")
                return
            }
        }
        
    }
}

struct ConfirmationHSView : View{
   // @State var completedQuestions = false
    @Environment(\.dismiss) var dismiss
    @State var answerResult = -1
    
    @Binding var selectedLocation: String
    @Binding var temp: String
    @Binding var selectedAnswer: String
    @Binding var selectedSecondAnswer: String
    
    var cardCheck = DigitalCardView()
    
    let correctAnswer = "No"
    var lowTemp = 96.0
    var highTemp = 100.0
    var number: String{
        guard let temp = Double(temp) else{
            return "USE NUMBERS ONLY."
        }
        return String("\(temp) F°")
    }
    var tempDouble : Double {
        guard let temp = Double(temp) else{
            return -1
        }
        return temp
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
                

                
                Spacer()
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        if(self.selectedAnswer == correctAnswer && self.selectedSecondAnswer == correctAnswer && self.tempDouble > lowTemp && self.tempDouble < highTemp && UserDefaults.standard.data(forKey: "vaxFront") != nil){
                                            print("setting date 0")
                                            UserDefaults.standard.set(0, forKey: "answerResult")
                                            self.answerResult = 0
                                        }else if (self.selectedAnswer == correctAnswer && self.selectedSecondAnswer == correctAnswer && self.tempDouble > lowTemp && self.tempDouble < highTemp && UserDefaults.standard.data(forKey: "vaxFront") == nil){
                                            print("setting date 1")
                                            UserDefaults.standard.set(1, forKey: "answerResult")
                                            self.answerResult = 1
                                        }else{
                                            print("setting date 2")
                                            UserDefaults.standard.set(2, forKey: "answerResult")
                                            self.answerResult = 2
                                        }
                                    UserDefaults.standard.set(getCurrentDate(), forKey: "setDate")
                                    UserDefaults.standard.set(selectedLocation, forKey: "setlocation")
                                        dismiss()
                                    }, label: {
                                        Text("Continue").bold()
                                    })
            )
        
            .navigationTitle(Text("Confirm Your Answers"))
    }
}

struct CompletedHealthView: View {
    
    let userName = Auth.auth().currentUser?.displayName
    let location : String = UserDefaults.standard.object(forKey: "setlocation") as! String
    
    var imageArr : [String] = ["HealthScreen_Check", "HealthScreen_Exclamation2", "HealthScreen_Alert"]
    var imageText : [String] = ["Welcome to New York Tech. \nYou are cleared for campus access today. \nPlease remember to wear a face covering at all times while on campus.", "You may access campus for the day as long as you provide additional documentation: proof of vaccination or proof of a negative COVID test within past seven days","You are not cleared for campus access today. \nPlease stay home."]
    
    @State var selection : Int
    
   // let now = Date.now
    let colors : [Color] = [.green, .blue, .red]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Image(imageArr[selection]).resizable().aspectRatio(contentMode: .fit)
                    .padding()
                    .padding(.top)
                Text(userName ?? "Temp Name")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .padding(.bottom, 1)
                Text(getCurrentDate())
                    .font(.title)
                    .bold()
                    .foregroundColor(colors[selection])
                    .padding(.bottom, 1)
                    .padding(.horizontal)
                Text(location)
                    .font(.title)
                    .bold()
                    .foregroundColor(colors[selection])
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                Text(imageText[selection])
                    .font(.title2)
                    .fontWeight(.semibold).padding(.horizontal).padding(.bottom)
                Spacer()
            }
        }


        .navigationTitle(Text("Health Screen Result"))
    }
}

func getCurrentDate() -> String{
    let now = Date()

    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none

    return formatter.string(from: now)
}


struct HealthScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HealthScreenView()
    }
}




