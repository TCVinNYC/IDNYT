//
//  PCLView.swift
//  IDNYT
//
//  Created by Prince on 11/8/21.
//
/// this is the professor's class list view
/// basically allows the prof to add, edit and delete classes

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PCLView: View {
    
    @ObservedObject var model = ClassViewModel()
    
    let database = Firestore.firestore()
    @State var showSheet = false
    @State private var isShowingDetailView = false
    
    @State private var isLoading = true
    var body: some View {
        NavigationView{
                VStack{
                    if isLoading{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        .scaleEffect(1.5)
                        .padding(.bottom, 50)
                    } else{
                        Spacer()
                        ScrollView{
                            ForEach(model.classes, id: \.self) {data in
                                NavigationLink(destination: editClass(), isActive: $isShowingDetailView){
                                    
                                    Button(action: {isShowingDetailView = true}){
                                        VStack(alignment: .leading, spacing: 3){
                                            Text("\(data.course_name) - \(data.course_section)")
                                                .bold()
                                                //.minimumScaleFactor(0.001)
                                                .lineLimit(2)
                                                .font(.system(size: 23))
                                                
                                            Text(data.course_location)
                                                .minimumScaleFactor(0.001)
                                                .lineLimit(1)
                                                .font(.subheadline)
                                            Text("\(data.course_time_start) - \(data.course_time_end)")
                                                .minimumScaleFactor(0.001)
                                                .lineLimit(1)
                                                .font(.subheadline)
                                            Text(data.course_days.joined(separator: ", "))
                                                .minimumScaleFactor(0.001)
                                                .lineLimit(1)
                                                .font(.subheadline)
                                                
                                        }
                                        .frame(minWidth: UIScreen.main.bounds.size.width - 95, idealWidth: UIScreen.main.bounds.size.width - 95, maxWidth: UIScreen.main.bounds.size.width - 95, alignment: .leading)
                                       
                                    }
                                    .frame(maxWidth: UIScreen.main.bounds.size.width - 95, minHeight: UIScreen.main.bounds.size.height/9)
                                    .frame(maxHeight: UIScreen.main.bounds.size.height/6)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(20)
                                }
                            }
                        }
                        HStack{
                            Spacer()
                            Button(action: {self.showSheet.toggle()}){
                                Image(systemName: "plus")
                                    .font(.title3)
                                Text("Add Class")
                                    .font(.title3)
                            }.sheet(isPresented: $showSheet){
                                addClass(showSheet: self.$showSheet)
                            }
                            .padding(20)
                            .foregroundColor(Color.black)
                            .background(Color.accentColor)
                            .cornerRadius(.infinity)
                            .shadow(color: Color.gray, radius: 1, x: 2, y: 3)
                        }
                        .padding(.trailing, 15)
                        .padding(.bottom, 15)
                    }

                    
                    
                }
            .navigationTitle("My Class List")
        }
        .onAppear(perform: downloadCoursesCall)
    }

    func downloadCoursesCall(){
        if isLoading{
            print("downloading courses")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                model.getProfessorCourses { String in
                    if String == "done"{
                        isLoading = false
                    }
                }
            }
        }
    }
    
    func forceUpdate(){
        isLoading = true
        downloadCoursesCall()
    }
    
}


struct addClass: View{
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
    
    @Binding var showSheet: Bool
    
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
                            
                            model.addCourse(prof_name: Auth.auth().currentUser?.displayName ?? "Temp Name", prof_email: Auth.auth().currentUser?.email ?? "Temp Email", c_name: course_name, section: course_section, location: course_location, time_s: course_time_start.formatted(date: .omitted, time: .standard), time_e: course_time_end.formatted(date: .omitted, time: .standard), days: days, semester: "\(course_semester) \(currentYear())")
                            self.showSheet = false
                        }
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(Color.green)
                            .font(.title3.bold())
                            .cornerRadius(8)
                        
                        Button("Cancel"){self.showSheet = false}
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

struct editClass: View{
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




struct PCLView_Previews: PreviewProvider {
    static var previews: some View {
        PCLView()
            .previewDevice("iPhone 13 Pro Max")
    }
}

func currentYear() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: date)
}



// dummy buttons

//                                Button(action: {isShowingDetailView = true}){
//                                    VStack(alignment: .leading, spacing: 3){
//                                        Text("pokfpfjiormo ashdilwsui")
//                                            .bold()
//                                            .font(.system(size: 23))
//                                        Text("data.course_location")
//                                            .font(.subheadline)
//                                        Text("helooooo")
//                                            .font(.subheadline)
//                                        Text("djncijois")
//                                            .font(.subheadline)
//                                    }
//                                }
//                                .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(20)
