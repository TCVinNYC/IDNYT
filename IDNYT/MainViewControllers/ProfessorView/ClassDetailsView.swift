//
//  ClassDetailsView.swift
//  IDNYT
//
//  Created by Prince on 12/5/21.
//

import SwiftUI

struct ClassDetailsView: View{
    @ObservedObject var model = ClassViewModel()
    
    @State private var course_name : String = ""
    @State private var course_section : String = ""
    @State private var citySelection : Int = -1
    let cities  = ["Abu Dhabi", "Beijing", "Manhattan", "Old Westbury", "Vancouver"]
    @State var locationSelection : Int = -1
    @State private var course_location : String = ""
    
    @State private var course_zoomLink : String = ""
    @State private var course_time_start = Date()
    @State private var course_time_end = Date()
    @State private var course_semester : String = ""
    var semesters = ["Fall", "Spring", "Summer", "Winter"]

    @State private var didTap1: Bool = false
    @State private var didTap2: Bool = false
    @State private var didTap3: Bool = false
    @State private var didTap4: Bool = false
    @State private var didTap5: Bool = false
    @State private var didTap6: Bool = false
    @State private var didTap7: Bool = false
    
    @Binding var showSheet: Bool
    @State private var textEditorText:String = ""
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    
    var body : some View {
        NavigationView{
            VStack{
            Form{
                Section(header: Text("Class Details").foregroundColor(Color("NormalTextColor"))){
                    HStack{
                        TextField("Enter Course Name", text: $course_name)
                            .frame(width: 260)
                            .foregroundColor(Color("NormalTextColor"))
                        Divider()
                        TextField("Sec", text: $course_section)
                            .frame(width: 80)
                            .foregroundColor(Color("NormalTextColor"))
                    }
                    Section{
                        Picker(selection: $citySelection, label: Text("City Location: ").foregroundColor(Color("NormalTextColor"))){
                            ForEach(0 ..< cities.count){
                                Text(self.cities[$0]).foregroundColor(Color("NormalTextColor"))
                            }
                            .onChange(of: citySelection, perform: { sa in
                                model.getCourseLocations(city: cities[citySelection]){String in
                                    if(String == "done"){
                                        self.locationSelection = -1
                                        self.course_location = ""
                                        print("downloading rooms")
                                    }
                                }
                            })
                        }
                    }
                    Section{
                        Picker(selection: $locationSelection, label: Text("Room: ").foregroundColor(Color("NormalTextColor"))){
                            ForEach(0 ..< model.locationList.count, id: \.self) { index in
                                Text(self.model.locationList[index]).foregroundColor(Color("NormalTextColor"))
                            }
                            .onChange(of: locationSelection, perform: { sa in
                                if(locationSelection > -1){
                                    self.course_location = model.locationList[locationSelection]
                                }
                            })
                        }
                    }
                    TextField("Paste Zoom Link", text: $course_zoomLink)
                        .frame(width: 275)
                        .foregroundColor(Color("NormalTextColor"))
                }
                Section(header: Text("Days and Times:").foregroundColor(Color("NormalTextColor"))){
                    HStack{
                        Spacer()
                        Toggle("Mon", isOn: $didTap1)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )
                            .toggleStyle(.button)
                        Toggle("Tue", isOn: $didTap2)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )
                            .toggleStyle(.button)
                        Toggle("Wed", isOn: $didTap3)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )
                            .toggleStyle(.button)
                        Toggle("Thu", isOn: $didTap4)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )
                            .toggleStyle(.button)
                        Toggle("Fri", isOn: $didTap5)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )
                            .toggleStyle(.button)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        DatePicker("Starts:", selection: $course_time_start, displayedComponents: .hourAndMinute)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .frame(width: 160, height: 35)
                            .foregroundColor(Color("NormalTextColor"))
                        Divider()
                        DatePicker("Ends:", selection: $course_time_end, displayedComponents: .hourAndMinute)
                            .minimumScaleFactor(0.02)
                            .scaledToFit()
                            .frame(width: 153, height: 35)
                            .foregroundColor(Color("NormalTextColor"))
                        Spacer()
                    }
                }
                
                Section(header: Text("Semester for \(currentYear())").foregroundColor(Color("NormalTextColor"))){
                    Picker("", selection: $course_semester) {
                        ForEach(semesters, id: \.self) {
                            Text($0)
                                .minimumScaleFactor(0.02)
                                .scaledToFit()
                        }
                    }
                    .pickerStyle(.segmented)
                }
                // (Separate with commas)
                Section(header: Text("All Attendee Emails").foregroundColor(Color("NormalTextColor"))){
                    ZStack(alignment: .topLeading){
                        if textEditorText.isEmpty {
                            Text("After each email add a comma")
                                .foregroundColor(Color("NormalTextColor").opacity(0.30))
                                .font(.system(size: 15))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $textEditorText)
                            .foregroundColor(Color("NormalTextColor"))
                            .font(.system(size: 15))
                            .textInputAutocapitalization(.never)
                    }
                }
            }
                HStack{
                    Spacer()
                    Button(action: {
                        print("uploading...")

                        var days: [String] = []
                        if(didTap1){days.append("Mon")}
                        if(didTap2){days.append("Tue")}
                        if(didTap3){days.append("Wed")}
                        if(didTap4){days.append("Thu")}
                        if(didTap5){days.append("Fri")}
                        
                        let formatter = DateFormatter()
                        formatter.dateStyle = .none
                        formatter.timeStyle = .short
                        
                        if(course_name.isEmpty || course_section.isEmpty || course_location.isEmpty || course_zoomLink.isEmpty || days.isEmpty || course_semester.isEmpty){
                            showAlert = true
                        }else{
                            model.addCourse(prof_name: model.userName!, prof_email: model.userEmail!, c_name: course_name, section: course_section, location: course_location, zoomLink: course_zoomLink, time_s: formatter.string(from: course_time_start), time_e: formatter.string(from: course_time_end), days: days, semester: "\(course_semester) \(currentYear())", student_list: model.studentParser(textEditorText: textEditorText))
                            self.showSheet = false
                        }

                    }){
                        HStack{
                            Spacer()
                            Text("Upload")
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        .padding(.all, 12)
                        .background(.green)
                        .cornerRadius(4)
                    }
                    .alert("You Have Some Empty Fields!", isPresented: $showAlert){}
                    Spacer()
                    Button(action: {self.showSheet = false}){
                        HStack{
                            Spacer()
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        .padding(.all, 12)
                        .background(.red)
                        .cornerRadius(4)
                    }
                    Spacer()
                }
                Spacer()
            }
         //   .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .navigationTitle("Enter Course Info")
        }
    
    }
}

func currentYear() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: date)
}

//struct ClassDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassDetailsView(showSheet: true)
//    }
//}
