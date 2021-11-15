//
//  EditCourses.swift
//  IDNYT
//
//  Created by Prince on 11/14/21.
//

import SwiftUI
import FirebaseFirestore

struct EditCourses: View{
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
    
    var body : some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .center){
                    Label("Course Name & Section:", systemImage: "book.circle.fill")
                        .frame(width: 340, height: 35, alignment: .leading)
                        .font(.system(size: 23))
                        .imageScale(.large)
                    HStack{
                        TextField("Enter Course Name...", text: $course_name)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 0.5).opacity(0.5)
                            )
                            .frame(width: 275)
                            .foregroundColor(.black)
                        TextField("Sec", text: $course_section)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 0.5).opacity(0.5)
                            )
                            .frame(width: 50)
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
                                .stroke(Color.black, lineWidth: 0.5).opacity(0.5)
                        )
                        .frame(width: 330)
                    
                    Label("Days & Times:", systemImage: "clock.circle.fill")
                        .font(.system(size: 23))
                        .imageScale(.large)
                        .frame(width: 340, height: 35, alignment: .leading)
                        .padding(.top)
                    
                    HStack{
                        Toggle("Mon", isOn: $didTap1)
                            .tint(.accentColor)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.blue, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Tue", isOn: $didTap2)
                            .tint(.accentColor)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.blue, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Wed", isOn: $didTap3)
                            .tint(.accentColor)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.blue, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Thu", isOn: $didTap4)
                            .tint(.accentColor)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.blue, lineWidth:2)
                            )

                            .toggleStyle(.button)
                        Toggle("Fri", isOn: $didTap5)
                            .tint(.accentColor)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.blue, lineWidth:2)
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
                        
//                        Label("All Attendee Emails:", systemImage: "globe.americas.fill")
//                            .font(.system(size: 23))
//                            .imageScale(.large)
//                            .frame(width: 340, height: 35, alignment: .leading)
//                            .padding(.top)
//
//                        TextEditor(text: .constant("After each email add a comma or space"))
//                            .padding()
//                            .foregroundColor(.black)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 4)
//                                    .stroke(Color.black, lineWidth:2).opacity(0.4)
//                            )
//                            .frame(width: 330, height: 150)

                    
                    HStack(alignment: .center){
                        Button("Upload"){
                            print("uploading...")
                            
                            var days: [String] = []
                            if(didTap1){days.append("Mon")}
                            if(didTap2){days.append("Tue")}
                            if(didTap3){days.append("Wed")}
                            if(didTap4){days.append("Thu")}
                            if(didTap5){days.append("Fri")}
                        }
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(Color.green)
                            .font(.title3.bold())
                            .cornerRadius(8)
                        
                        Button("Cancel"){}
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
            .navigationTitle("Enter Course Info")
        }
    }
}

struct EditCourses_Previews: PreviewProvider {
    static var previews: some View {
        EditCourses()
    }
}
