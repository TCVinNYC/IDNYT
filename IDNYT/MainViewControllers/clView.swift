//
//  clView.swift
//  IDNYT
//
//  Created by Prince on 11/7/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CoreNFC

enum ActiveAlert {
    case success, fail
}

struct clView: View {
    //Gesture Data
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset : CGFloat = 0
    
    @ObservedObject var model = ClassViewModel()
    var attend = AttendanceViewModel()
//    @State var color : Color = .accentColor
    
    @State var signInCourse : [String] = []
    
    @State private var isLoading = true
    @State private var confirmationShown = false
    @State private var result : String = ""
    
    var nfc = NFCReader()
    @State var tempCourseLoc : String = ""
    @State var tempCourseID : String = ""
    
    @State private var signInAlert : Bool = false
    @State private var activeAlert: ActiveAlert = .success

    
    var body: some View {
        NavigationView{
            ZStack(alignment: .leading){
                VStack{
                    if isLoading{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        .scaleEffect(1.5)
                        .padding(.bottom, 50)
                    } else {
                    HStack{
                        Label("Today:", systemImage: "calendar.circle")
                            .imageScale(Image.Scale.large)
                            .font(.title)
                            .padding(10)
                            .padding(.leading, 33)
                        Spacer()
                    }

                        VStack{
                            ScrollView {
                                // sort by time if you can
                               // for var data in model.classes {
                                
                                ForEach(model.classes, id:  \.id) { data in
                                    if(data.course_days.contains(currentDay())){
                                        Button(action: {
                                            
                                            tempCourseID = data.id!
                                            if(!signInCourse.contains(tempCourseID)){
                                                tempCourseLoc = data.course_location
                                                confirmationShown = true
                                            }
                                                   
//                                            attend.studentSignIn(courseDoc: tempCourseID, dateDoc: date4Doc(), studentEmail: (Auth.auth().currentUser?.email)!){ String in
//                                                if(String == "true"){
//                                                 //   color = .green
//                                                    confirmationShown = false
//                                                    print("cannot sign in anymore")
//                                                }else{
//                                                    confirmationShown = true
//                                                    print("can sign in for now")
//                                                }
//                                            }
                                            
                                        }){
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60)
                                                .foregroundColor(Color("TextColor"))
                                            Divider().frame(width: 15, height: 70)
                                            VStack(alignment: .leading, spacing: 3){
                                                Text("\(data.course_name) - \(data.course_section)")
                                                    .bold()
                                                    .font(.system(size: 23))
                                                    .foregroundColor(Color("TextColor"))
                                                Text(data.course_location)
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("TextColor"))
                                                Text("\(data.course_time_start) - \(data.course_time_end)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("TextColor"))
                                                Text("\(data.prof_name) - \(data.prof_email)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("TextColor"))
                                            }

                                            Spacer()

                                        }
                                        
                                        .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                                        .padding()
                                        .background(Color.accentColor)
                                        .cornerRadius(20)
                                        .disabled(signInCourse.contains(data.id!))
                                        
                                        .confirmationDialog("Sign Into Class", isPresented: $confirmationShown) {
                                            Button("NFC Scanner"){
                                                let result = nfc.beginScanning(location: tempCourseLoc)
                                                print("NFC Read: \(result)")
                                                
                                                if(result.contains(tempCourseLoc)){
                                                    self.activeAlert = .success
                                                    print("Right Class")
                                                    attend.setAttendance(courseDoc: tempCourseID, dateDoc: date4Doc(), tempUser: gatherUserData(loginType: "NFC") ) { String in
                                                        print(String)
                                                    }
                                                    signInCourse.append(tempCourseID)
                                                        
                                                    
                                              //      setSignIn(doc_ID: tempCourseID, signInResult: "green")
                                                }else{
                                                    self.activeAlert = .fail
                                                    print("Wrong Class")
                                                }
                                                self.signInAlert = true
                                        }
                                            Button("Zoom"){
                                                self.activeAlert = .success
                                                //code for Zoom Link on iPhone
                                                attend.setAttendance(courseDoc: tempCourseID, dateDoc: date4Doc(), tempUser: gatherUserData(loginType: "Zoom") ) { String in
                                                    print(String)
                                                }
                                                signInCourse.append(tempCourseID)
                                            }
                                       }
                                        .alert(isPresented: $signInAlert) {
                                            switch activeAlert {
                                            case .success:
                                                return Alert(
                                                    title: Text("Successfully Signed In!"),
                                                    message: Text("Go ahead and enter class :)")
                                                )
                                            case .fail:
                                                return Alert(
                                                    title: Text("Wrong Class Room!"),
                                                    message: Text("Try Again Please")
                                                )
                                            }
                                       }

                                        
                                        
                                    }
                                }
                            }
                        }
                        .shadow(radius: 4)
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                .navigationTitle("Class List")
                .toolbar{
                    Menu("Fall 2021"){
                        Button("Placeholder for all semesters"){}
                    }
                    .foregroundColor(.blue)
                }
                
                GeometryReader {reader in
                    BottomSheet()
                        .frame(maxHeight: .infinity)
                        .offset(y: reader.frame(in: .global).height - 80)
                        .offset(y: offset)
                        
                    //this is where the old gesture code was
                        .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                            out = value.translation.height
                            onChange()
                        }).onEnded({ value in
                            let maxHeight = reader.frame(in: .global).height - 80
                            withAnimation {
                                //Logic for moving the view
                                if -offset > 100 && -offset < maxHeight/2{
                                    offset = -(maxHeight/2)
                                } else if -offset > maxHeight/2{
                                    offset = -maxHeight
                                }else{
                                    offset = 0
                                }
                            }
                            lastOffset = offset
                        }))
                }
                .onAppear{
                    downloadCoursesCall()
                    
                    
             //       let modelSorted = model.classes.sorted{ $0.course_time_start.formatted(date: .omitted, time: .standard) < $1.course_time_start.formatted(date: .omitted, time: .standard) }

                   // model.classes.sorted{ stringTime(item: $0.course_time_start) < stringTime(item: $1.course_time_start) }
                }
            }
        }
    }
    func onChange(){
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func downloadCoursesCall(){
        if isLoading{
            print("downloading courses")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                model.getStudentCourses() { String in
                    if String == "done"{
                        
                        for course in model.classes{
                            attend.studentSignIn(courseDoc: course.id!, dateDoc: date4Doc(), studentEmail: (Auth.auth().currentUser?.email)!){String in
                                if(String == "true"){
                                    signInCourse.append(course.id!)
                                }
                            }
                        }
                        isLoading = false
                    }
                }
            }
        }
    }
    
    func gatherUserData(loginType:String) -> [String?] {
        let temp : [String?] = [Auth.auth().currentUser?.displayName, Auth.auth().currentUser?.email, loginType, currentTime()]
        return temp
    }
    
    func stringTime(item : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        
        
        let temp : Date = dateFormatter.date(from: item)!
        
        
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: temp as Date)
    }
    
    func setSignIn(doc_ID : String) -> Color{
        var tempColor : Color = .accentColor
        attend.studentSignIn(courseDoc: doc_ID, dateDoc: date4Doc(), studentEmail: (Auth.auth().currentUser?.email)!){String in
            if(String == "true"){
                signInCourse.append(doc_ID)
                tempColor = .green
            }
        }
        return tempColor
    }
}

struct BottomSheet : View {
    @State private var model = ClassViewModel()
    
    var body : some View{
        VStack(){
            Capsule()
                .fill(Color.black)
                .frame(width: 40, height: 5)
            Label("Upcoming:", systemImage: "hourglass.circle")
                .imageScale(Image.Scale.large)
                .font(.title)
                .offset(x: -80, y: 0)
            ScrollView(.vertical){
                LazyVStack(alignment: .center){
                    ForEach(model.classes, id: \.self) {data in
                        if(!data.course_days.contains(currentDay())){
                            Button(action: {}){
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(Color("TextColor"))
                                Divider().frame(width: 15, height: 70)
                                //Spacer()
                                VStack(alignment: .leading, spacing: 3){
                                    Text("\(data.course_name) - \(data.course_section)")
                                        .bold()
                                        .font(.system(size: 23))
                                        .foregroundColor(Color("TextColor"))
                                    Text(data.course_location)
                                        .font(.subheadline)
                                        .foregroundColor(Color("TextColor"))
                                    Text("\(data.course_time_start) - \(data.course_time_end)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("\(data.prof_name) - \(data.prof_email)")
                                        .font(.subheadline)
                                        .foregroundColor(Color("TextColor"))
                                }
                                Spacer()
                            }
                            .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                            .padding()
                            .background(Color.accentColor)
                            .opacity(0.7)
                            .cornerRadius(20)
                        }
                    }
                    .disabled(true)
                }
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(25)
        .ignoresSafeArea(.all , edges: .bottom)
        .onAppear(){
            model.getStudentCourses() { String in
                    print(String)
                print(model.classes.count)
                }
        }
    }

}

struct BlurView: UIViewRepresentable{
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct clView_Previews: PreviewProvider {
    static var previews: some View {
        clView()
            .previewDevice("iPhone 13 Pro Max")
    }
}

func currentDay() -> String{
    let dateForm = DateFormatter()
    dateForm.dateFormat = "EEEE"
    let weekDay = dateForm.string(from: Date())
    return String(weekDay.prefix(3))
}

func date4Doc() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter.string(from: Date()).replacingOccurrences(of: "/", with: "-")
}

func currentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: Date())
}



// old code
//                        .gesture(DragGesture().onChanged({(value) in
//                            withAnimation {
//                                if value.startLocation.y > reader.frame(in: .global).midX{
//                                    offset = value.translation.height
//                                }
//                                if value.startLocation.y < reader.frame(in: .global).midX{
//                                    offset = (-reader.frame(in: .global).height + 150) + value.translation.height
//                                }
//
//                            }
//                        }).onEnded({ value in
//                            withAnimation {
//                                if value.startLocation.y > reader.frame(in: .global).midX{
//                                    if -value.translation.height > reader.frame(in: .global).midX{
//                                        offset = (-reader.frame(in: .global).height + 150)
//                                        return
//                                    }
//                                    offset = 0
//
//                                }
//                                if value.startLocation.y < reader.frame(in: .global).midX{
//                                    if value.translation.height < reader.frame(in: .global).midX{
//                                        offset = (-reader.frame(in: .global).height + 150)
//                                        return
//                                    }
//                                    offset = 0
//                                }
//                            }
//                        }))




