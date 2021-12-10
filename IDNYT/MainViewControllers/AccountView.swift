//
//  AccountView.swift
//  IDNYT
//
//  Created by Aisha on 12/7/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct AccountView: View {
    
    @AppStorage("selectedAppearance") var selectedAppearance = "Auto"

    private var model = AttendanceViewModel()
    @State private var id_number : String = ""
    @State private var appAppear : String = "Auto"
    private var appearances = ["Auto", "Light", "Dark"]
    @State private var presentAlert = false
    
    var body: some View {
        
        NavigationView{
            VStack{
                WebImage(url: model.userProfilePic)
                    .placeholder(Image(systemName: "person.circle"))
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width/2.5, alignment: .center)
                    .foregroundColor(Color("AccentColor"))
                    .clipShape(Circle())
                    .padding(.bottom, 25)
                    .padding(.top, 30)
                
                HStack(alignment: .center){
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/11)
                            .foregroundColor(Color("AccentColor"))
                            .overlay(Text("Name").foregroundColor(Color("TextColor")).fontWeight(.bold))
                        Spacer()
                        Text(model.userName ?? "Temp Name")
                        .frame(width: UIScreen.main.bounds.width/2.2)
                        Spacer()
                    }
                    HStack(alignment: .center){
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/11)
                            .foregroundColor(Color("AccentColor"))
                            .overlay(Text("Email").foregroundColor(Color("TextColor")).fontWeight(.bold))
                        Spacer()
                        Text(model.userEmail ?? "Temp Email")
                            .frame(width: UIScreen.main.bounds.width/2.2)
                        Spacer()
                    }
                
                HStack(alignment: .center){
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: UIScreen.main.bounds.width/3.5, height: UIScreen.main.bounds.width/11)
                        .foregroundColor(Color("AccentColor"))
                        .overlay(Text("ID Number").foregroundColor(Color("TextColor")).fontWeight(.bold))
                    Spacer()
                    TextField("Enter Numbers", text: $id_number).frame(width: UIScreen.main.bounds.width/2.2).textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Spacer()
                }
                    HStack(alignment: .center){
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.main.bounds.width/3.5, height: UIScreen.main.bounds.width/11)
                            .foregroundColor(Color("AccentColor"))
                            .overlay(Text("Appearance").foregroundColor(Color("TextColor")).fontWeight(.bold))
                        Spacer()
                        Picker("Appearance", selection: $appAppear){
                            ForEach(appearances, id: \.self){
                                Text($0)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 2.2)
                      //  .frame(width: UIScreen.main.bounds.width/3)
                        .pickerStyle(SegmentedPickerStyle())
                        Spacer()
                    }
                    
                Spacer()
                VStack{
                    Button(action: {
                        print("Signing Out")
                        model.signOut()
                        //erase user data
                        SceneDelegate.shared?.window?.overrideUserInterfaceStyle = .unspecified
                        UserDefaults.standard.set("Auto", forKey: "THEME_KEY")
                        UserDefaults.standard.set("", forKey: "ID_KEY")
                    }, label:{
                        Text("Sign out")
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width/3.5, height: UIScreen.main.bounds.width/11)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                }
                Spacer()
           
            }
               .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .onAppear(perform: {
                if UserDefaults.standard.string(forKey: "THEME_KEY") != nil{
                    self.appAppear = UserDefaults.standard.string(forKey: "THEME_KEY") ?? "Auto"
                }
                if UserDefaults.standard.string(forKey: "ID_KEY") != nil{
                    self.id_number = UserDefaults.standard.string(forKey: "ID_KEY") ?? ""
                }
            })
            
            .onChange(of: appAppear, perform: { newValue in
                if(appAppear == "Auto"){
                    selectedAppearance = "Auto"
                    SceneDelegate.shared?.window?.overrideUserInterfaceStyle = .unspecified
                   
                    UserDefaults.standard.set("Auto", forKey: "THEME_KEY")
                }
                if(appAppear == "Light"){
                    selectedAppearance = "Light"
                    SceneDelegate.shared?.window?.overrideUserInterfaceStyle = .light
                    
                    UserDefaults.standard.set("Light", forKey: "THEME_KEY")
                }
                if(appAppear == "Dark"){
                    selectedAppearance = "Dark"
                    SceneDelegate.shared?.window?.overrideUserInterfaceStyle = .dark
                    
                    UserDefaults.standard.set("Dark", forKey: "THEME_KEY")
                }
            })
            
            .onChange(of: id_number, perform: { newValue in
                if(!id_number.isEmpty){
                    UserDefaults.standard.set(id_number, forKey: "ID_KEY")
                }else{
                    UserDefaults.standard.set("", forKey: "ID_KEY")
                }
            })
            
            .alert(isPresented: $presentAlert) {
                Alert(
                    title: Text("Need Help?"),
                    message: Text("Contact admin for help \nstevensonchittumuri@gmail.com")
                )
            }.padding()
            
            .toolbar(content: {
                Button(action: {
                    presentAlert = true
                }, label:{
                    Text("Help")
                })
            })
            .navigationBarTitle("Account Info")

        }

    }
}

extension AccountView {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

