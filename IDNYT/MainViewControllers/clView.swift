//
//  clView.swift
//  IDNYT
//
//  Created by Prince on 11/7/21.
//

import SwiftUI
import FirebaseFirestore

struct clView: View {
    //Gesture Data
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset : CGFloat = 0
    
    @ObservedObject var model = ClassViewModel()
    let database = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .leading){
                VStack{
                    HStack{
                        Label("Today:", systemImage: "calendar.circle")
                            .imageScale(Image.Scale.large)
                            .font(.title)
                            .padding(10)
                            .padding(.leading, 33)
                        Spacer()
                    }

                    //idea of how the class should look
                    VStack(alignment: .center){
                        ScrollView {
                            ForEach(model.classes, id: \.self) {data in
                                Button(action: {}){
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60)
                                    Divider().frame(width: 15, height: 70)
                                    //Spacer()
                                    VStack(alignment: .leading, spacing: 3){
                                        Text("\(data.course_name) - \(data.course_section)")
                                            .bold()
                                            .font(.system(size: 23))
                                        Text(data.course_location)
                                            .font(.subheadline)
                                        Text("\(data.course_time_start) - \(data.course_time_end)")
                                            .font(.subheadline)
                                        Text("\(data.prof_name) - \(data.prof_email)")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(20)
                                
                                
                            }
                        }
                    }
                    .shadow(radius: 4)

                }
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                .navigationTitle("Class List")
                
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

            }
        }
    }
    func onChange(){
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    init(){
        model.getStudentCourses()
    }
}

struct BottomSheet : View {
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
                    ForEach(1...8, id: \.self) {count in
                        Button(action: {}){
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                            Divider().frame(width: 15, height: 70)
                          //  Spacer()
                            VStack(alignment: .leading, spacing: 3){
                                Text("Class Name - Section")
                                    .bold()
                                    .font(.system(size: 23))
                                Text("Class Location")
                                    .font(.subheadline)
                                Text("Time")
                                    .font(.subheadline)
                                Text("Professor Name - Email")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                        .padding()
                        .frame(width: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .opacity(0.7)
                    }
                }
                
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(25)
        .ignoresSafeArea(.all , edges: .bottom)
        
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
