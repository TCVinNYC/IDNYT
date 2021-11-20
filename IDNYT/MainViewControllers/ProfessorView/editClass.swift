//
//  editClass.swift
//  IDNYT
//
//  Created by Prince on 11/19/21.
//

import SwiftUI

struct editClass: View{
    
    var currentCourse: ClassModel
    @ObservedObject var model = ClassViewModel()
    
    @State private var course_name : String = ""
    @State private var course_section : String = ""
    @State private var course_location : String = ""
   // @State private var course_locZoom : String
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
    var body : some View {
            ScrollView{
                VStack(alignment: .center){
                    Group{
                        
                    Label("Course Name & Section:", systemImage: "book.circle.fill")
                        .frame(width: 340, height: 35, alignment: .leading)
                        .font(.system(size: 23))
                        .imageScale(.large)
                    HStack{
                        TextField("Enter Course Name...", text: $course_name)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 0.5).opacity(0.5)
                            )
                            .frame(width: 275)
                            .foregroundColor(Color("NormalTextColor"))
                        TextField("Sec", text: $course_section)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 0.5).opacity(0.5)
                            )
                            .frame(width: 50)
                            .foregroundColor(Color("NormalTextColor"))
                    }
                    
                    Label("Course Location:", systemImage: "mappin.circle.fill")
                        .font(.system(size: 23))
                        .imageScale(.large)
                        .frame(width: 340, height: 35, alignment: .leading)
                        .padding(.top)
                    TextField("Enter Building and Room #...", text: $course_location)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 0.5).opacity(0.5)
                        )
                        .frame(width: 330)
                        .foregroundColor(Color("NormalTextColor"))
                    }
                    
                    Group{
                    Label("Days & Times:", systemImage: "clock.circle.fill")
                        .font(.system(size: 23))
                        .imageScale(.large)
                        .frame(width: 340, height: 35, alignment: .leading)
                        .padding(.top)
                    
                    HStack{
                        Toggle("Mon", isOn: $didTap1)
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Tue", isOn: $didTap2)
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Wed", isOn: $didTap3)
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Thu", isOn: $didTap4)
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Fri", isOn: $didTap5)
                            .tint(.accentColor)
                            .foregroundColor(Color("NormalTextColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth:2)
                            )
                            .toggleStyle(.button)
                    }
                        
                    HStack(alignment: .center){
                        Spacer()
                        DatePicker("Starts:", selection: $course_time_start, displayedComponents: .hourAndMinute)
                            .frame(width: 160, height: 35, alignment: .center)
                            .padding(.leading)
                        Divider()
                        DatePicker("Ends:", selection: $course_time_end, displayedComponents: .hourAndMinute)
                            .frame(width: 153, height: 35, alignment: .center)
                            .padding(.trailing)
                        Spacer()
                    }
                }
                    
                        Label("Semester for \(currentYear()):", systemImage: "globe.americas.fill")
                            .font(.system(size: 23))
                            .imageScale(.large)
                            .frame(width: 340, height: 35, alignment: .leading)
                            .padding(.top)
                        
                        Picker("", selection: $course_semester) {
                            ForEach(semesters, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 330)

                        Label("All Attendee Emails:", systemImage: "globe.americas.fill")
                            .font(.system(size: 23))
                            .imageScale(.large)
                            .frame(width: 340, height: 35, alignment: .leading)
                            .padding(.top)
                    
                    ZStack(alignment: .topLeading){
                        if textEditorText == "" {
                            Text("After each email add a comma")
                                .foregroundColor(Color("NormalTextColor").opacity(0.30))
                                .font(.system(size: 15))
                                .padding(.top, 7)
                                .padding(.leading, 20)
                        }
                        TextEditor(text: $textEditorText)
                            .font(.system(size: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth:3).opacity(0.4)
                            )
                            .frame(width: 330, height: 250)
                            .cornerRadius(10)
                            .padding(.leading)
                            .padding(.trailing)
                            .foregroundColor(Color("NormalTextColor"))
                    }.onAppear(){
                        UITextView.appearance().backgroundColor = .clear
                    }.onDisappear(){
                        UITextView.appearance().backgroundColor = nil
                    }

                    
                    HStack(alignment: .center){
                        Button("Update"){
                            print("updating data...")
                            
                            var days: [String] = []
                            if(didTap1){days.append("Mon")}
                            if(didTap2){days.append("Tue")}
                            if(didTap3){days.append("Wed")}
                            if(didTap4){days.append("Thu")}
                            if(didTap5){days.append("Fri")}
                            
                            let separator = CharacterSet(charactersIn: " ,-;:\n")
                            let tempStudentArr : [String] = textEditorText.components(separatedBy: separator)
                            var finalStudentArr:[String] = []
                            for student in tempStudentArr{
                                if(student.hasSuffix("nyit.edu")){
                                    finalStudentArr.append(student)
                                }
                            }
                            
                            let formatter = DateFormatter()
                            formatter.dateStyle = .none
                            formatter.timeStyle = .short
                            
                            let tempCourse = ClassModel(id: currentCourse.id, prof_name: currentCourse.prof_name, prof_email: currentCourse.prof_email, course_name: course_name, course_section: course_section, course_location: course_location, course_time_start: formatter.string(from: course_time_start), course_time_end: formatter.string(from: course_time_end), course_days: days, course_semester: course_semester, student_list: finalStudentArr.sorted())
                            
                            model.updateCourse(courseToUpdate: tempCourse)
                            dismiss()
                        }
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(Color.green)
                            .font(.title3.bold())
                            .cornerRadius(8)
                        
                        Button("Cancel"){
                            dismiss()
                        }
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(Color.red)
                            .font(.title3.bold())
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    .frame(height: 100)
                    
                }
                .padding(.top, 30)
                Spacer()
            }
            .onAppear(perform: {
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                
                course_name = currentCourse.course_name
                course_section = currentCourse.course_section
                course_semester = currentCourse.course_semester
                course_location = currentCourse.course_location
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
            .navigationTitle("Edit Course Info")
            .toolbar{
                
                Button(action: {
                    model.deleteCourse(docID: currentCourse.id!)
                    dismiss()
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
                }

            }

}

//struct editClass_Previews: PreviewProvider {
//    static var previews: some View {
//        editClass()
//    }
//}
