//
//  editClass.swift
//  IDNYT
//
//  Created by Prince on 11/19/21.
//

import SwiftUI

struct EditClassDetails: View{
    
    var currentCourse: ClassModel
    @ObservedObject var model = ClassViewModel()
    
    @State private var course_name : String = ""
    @State private var course_section : String = ""
    @State private var citySelection : Int = -1
    var cities  = ["Abu Dhabi", "Beijing", "Manhattan", "Old Westbury", "Vancouver"]
    @State var locationSelection : Int = -2
    @State private var course_location : String = ""
    @State private var course_zoomLink : String = ""
    @State private var course_time_start = Date()
    @State private var course_time_end = Date()
    @State private var course_semester : String = "Fall"
    var semesters = ["Fall", "Spring", "Summer", "Winter"]

    @State private var didTap1: Bool = false
    @State private var didTap2: Bool = false
    @State private var didTap3: Bool = false
    @State private var didTap4: Bool = false
    @State private var didTap5: Bool = false
    @State private var didTap6: Bool = false
    @State private var didTap7: Bool = false
    
    @State private var textEditorText:String = ""
    
    @Environment(\.dismiss) var dismiss
    @Binding var isActive : Bool
    @State private var showAlert = false
    @State private var didLoad = false
    @State private var didLoad2 = false
    var body : some View {
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
                            if(self.didLoad){
                                model.getCourseLocations(city: cities[citySelection]){String in
                                    if(String == "done"){
                                        if(self.didLoad2){
                                            self.locationSelection = -1
                                            self.course_location = ""
                                            print("downloading rooms")
                                        }else{
                                            self.didLoad2 = true
                                        }

                                    }
                                }
                            }else{
                                print("changing didLoad to true")
                                self.didLoad = true
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
                Section{
                TextField("Paste Zoom Link Here", text: $course_zoomLink)
                    .frame(width: 275)
                    .foregroundColor(Color("NormalTextColor"))
                }
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
                    print("updating data...")
                    
                    var days: [String] = []
                    if(didTap1){days.append("Mon")}
                    if(didTap2){days.append("Tue")}
                    if(didTap3){days.append("Wed")}
                    if(didTap4){days.append("Thu")}
                    if(didTap5){days.append("Fri")}
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .none
                    formatter.timeStyle = .short
                    
                    if(course_name.isEmpty || course_section.isEmpty || course_location.isEmpty || course_zoomLink.isEmpty || days.isEmpty){
                        showAlert = true
                    }else{
                        model.updateCourse(courseToUpdate: ClassModel(id: currentCourse.id, prof_name: currentCourse.prof_name, prof_email: currentCourse.prof_email, course_name: course_name, course_section: course_section, course_location: course_location, course_zoomLink: course_zoomLink, course_time_start: formatter.string(from: course_time_start), course_time_end: formatter.string(from: course_time_end), course_days: days, course_semester: "\(course_semester) \(currentYear())", student_list: model.studentParser(textEditorText: textEditorText)))
                    }
                    dismiss()
                }){
                    HStack{
                        Spacer()
                        Text("Update")
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
                Button(action: {
                    dismiss()
                }){
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
            .navigationTitle("Edit Course Info")
            .toolbar{
                Button(action: {
                    //dismiss()
                    self.isActive = false
                    model.deleteCourse(docID: currentCourse.id!)
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
            }
         //   .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .onAppear(perform: {
                var tempLocationSelection : Int = 0
                print("\(didLoad)  onAppear")
                if self.didLoad {return}
                course_location = currentCourse.course_location
                
                model.getLocationDetails(course_Loc: course_location) { String in
                    if(String == "done"){
                        print("found city")
                        citySelection = cities.firstIndex(of: model.city) ?? 0
                        print("downloading rooms")
                        
                        model.getCourseLocations(city: cities[citySelection]){String in
                            if(String == "done"){
                                tempLocationSelection = model.locationList.firstIndex(of: course_location)!
                                print("downloaded rooms")
                            }
                        }
                    }
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                
                course_name = currentCourse.course_name
                course_section = currentCourse.course_section
                course_semester = currentCourse.course_semester
                
                course_location = currentCourse.course_location
                locationSelection = tempLocationSelection
                
                course_zoomLink = currentCourse.course_zoomLink
                course_time_start = formatter.date(from: currentCourse.course_time_start) ?? Date.now
                course_time_end = formatter.date(from: currentCourse.course_time_end) ?? Date.now
                course_semester = currentCourse.course_semester.components(separatedBy: " ").first ?? "Fall"
                textEditorText = currentCourse.student_list.joined(separator: ", ")
                
                if(currentCourse.course_days.contains("Mon")){didTap1=true}
                if(currentCourse.course_days.contains("Tue")){didTap2=true}
                if(currentCourse.course_days.contains("Wed")){didTap3=true}
                if(currentCourse.course_days.contains("Thu")){didTap4=true}
                if(currentCourse.course_days.contains("Fri")){didTap5=true}
            })
    }
    

}

//struct EditClassDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        EditClassDetails()
//    }
//}
