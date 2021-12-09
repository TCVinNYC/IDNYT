//
//  AttendenceViewController.swift
//  IDNYT
//
//  Created by Prince on 11/18/21.
//

import SwiftUI
import FirebaseFirestore

struct AttendenceViewController: View {
    
    @Binding var isActive : Bool
    
    var currentCourse: ClassModel
    @ObservedObject var model = AttendanceViewModel()
    let database = Firestore.firestore()
    
    @State private var date : String = ""
    @State private var attendingCount : Int = 0
    @State private var maxAttend : Int = 0
    
    @State private var daysOfClass : [String] = []
    @State private var selectedDay = ""

    var body: some View {
            VStack{
                List{
                    ForEach(model.attendance, id: \.self) {data in
                        VStack{
                            Spacer()
                            HStack {
                                Text("\(data.student_details[0]) -")
                                    .bold()
                                    .font(.system(size: 18))
                                
                                Text(data.student_details[1])
                                    .italic()
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("Method: \(data.student_details[2])")
                                Spacer()
                                Text("Time: \(data.student_details[3])")
                            }
                            
                            Spacer()
                        }
                }
                
            }
            .navigationTitle("Attendance List")
            
            .toolbar {
              //  ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Picker(selection: $selectedDay, label: Text("")) {
                            ForEach(daysOfClass, id: \.self){ day in
                                Text(day)
                            }
                        }

                    }
                label: {
                   // Label("\(selectedDay)", systemImage: "calendar.circle.fill").foregroundColor(.blue)
                    HStack{
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.blue)
//                        Text(selectedDay)
//                            .foregroundColor(.blue)
                    }
                }
                   
            }
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    NavigationLink(destination: EditClassDetails(currentCourse: currentCourse, isActive: self.$isActive)){
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.red)
//                            Text("Edit")
//                                .foregroundColor(.red)
                    }.isDetailLink(false)
                    
            }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Text("\(attendingCount)/\(maxAttend) Students")
                }
                
            }
            
            .onAppear {
                let dateObj = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "E"
                
                let currentDay : String = formatter.string(from: dateObj)
                print(currentDay)
                
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                date = formatter.string(from: dateObj).replacingOccurrences(of: "/", with: "-")
                
                //check the days the course is avalible and compare with the date then manually add that to the array and select it
                //else just choose the latest document
                model.getAllDates(courseDoc: currentCourse.id!) { String in
                    if(String == "complete"){
                        daysOfClass = model.dateList
                        print("days of class ", daysOfClass)
                        if(currentCourse.course_days.contains(currentDay) && !daysOfClass.contains(date)){
                            daysOfClass.append(date)
                        }
                        
                        daysOfClass = daysOfClass.sorted().reversed()
                        if(daysOfClass.isEmpty){
                            daysOfClass.append(date)
                        }
                        selectedDay = daysOfClass[0]
                    }
                }
            }
                
            .onChange(of: selectedDay) { result in
                model.getStudentDetails(courseDoc: currentCourse.id!, dateDoc: selectedDay) { String in
                    print(String)
                    if(String == "empty docs"){
                        attendingCount = 0
                        model.attendance = []
                    }else{
                        attendingCount = model.attendance.count
                    }
                    maxAttend = currentCourse.student_list.count
                }
            }
        }
    }
}
