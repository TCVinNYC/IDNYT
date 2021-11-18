//
//  ClassListUIViewController.swift
//  IDNYT
//
//  Created by Prince on 11/17/21.
//

import SwiftUI
import VisionKit

struct ClassListUIViewController: View {
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("NYIT CARD:")
                ScrollView{
                HStack(alignment: .center){
                  //  ScrollView{
                        VStack{
                            Text("Front ID Card")
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                        }
                        .frame(width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.height/4)
                        .background(.gray)
                        
                        VStack{
                            Text("Back ID Card")
                            Image(systemName: "camera.circle.fill")

                        }
                    }
                }
            }
            .navigationTitle("Digital Wallet")
        }
    }
}

//struct ScannerView: UIViewControllerRepresentable {
//
//}

struct ClassListUIViewController_Previews: PreviewProvider {
    static var previews: some View {
        ClassListUIViewController()
    }
}
