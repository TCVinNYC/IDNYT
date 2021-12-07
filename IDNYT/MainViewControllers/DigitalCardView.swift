//
//  DigitalCardView.swift
//  IDNYT
//
//  Created by Prince on 11/17/21.
//

import SwiftUI
import VisionKit


struct DigitalCardView: View {
    @State private var showScannerSheetNYTFront = false
    @State private var showScannerSheetNYTBack = false
    @State private var showScannerSheetVAXFront = false
    @State private var showScannerSheetVAXBack = false
    @State private var nyitFront : UIImage = UIImage(named: "AddImage")!
    @State private var nyitBack : UIImage = UIImage(named: "AddImage")!
    @State private var vaxFront : UIImage = UIImage(named: "AddImage")!
    @State private var vaxBack : UIImage = UIImage(named: "AddImage")!

    var body: some View {
    NavigationView{
            VStack{
                HStack{
                    Text("NYIT Card:")
                        .bold()
                        .underline()
                        .padding(.horizontal, 20)
                        .padding(.top)
                        .font(.title2)
                    Spacer()
                }
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    VStack{
                        Image(uiImage: nyitFront)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .aspectRatio(3/2, contentMode: .fit)
                            .cornerRadius(10)
                     //   Text("Back")
                    }.frame(width: UIScreen.main.bounds.width*2/2.5, height: UIScreen.main.bounds.height/4)
                        .shadow(radius: 3)
                        .onTapGesture {
                            print("image1")
                            self.showScannerSheetNYTFront = true
                        }
                    
                    VStack{
                        Image(uiImage: nyitBack)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .aspectRatio(3/2, contentMode: .fit)
                            .cornerRadius(10)
                     //   Text("Back")
                    }.frame(width: UIScreen.main.bounds.width*2/2.5, height: UIScreen.main.bounds.height/4)
                        .shadow(radius: 3)
                        .onTapGesture {
                            print("image2")
                            self.showScannerSheetNYTBack = true
                        }
                }
            }.padding(.horizontal, 20)
                HStack{
                    Text("Vaccine Card:")
                        .bold()
                        .underline()
                        .padding(.horizontal, 20)
                        .padding(.top)
                        .font(.title2)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        VStack{
                            Image(uiImage: vaxFront)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .aspectRatio(3/2, contentMode: .fit)
                                .cornerRadius(10)
                        //    Text("Front")
                        }.frame(width: UIScreen.main.bounds.width*2/2.5, height: UIScreen.main.bounds.height/4)
                            .shadow(radius: 3)
                            .onTapGesture {
                                print("image3")
                                self.showScannerSheetVAXFront = true
                            }
                        VStack{
                            Image(uiImage: vaxBack)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .aspectRatio(3/2, contentMode: .fit)
                                .cornerRadius(10)
                         //   Text("Back")
                        }.frame(width: UIScreen.main.bounds.width*2/2.5, height: UIScreen.main.bounds.height/4)
                            .shadow(radius: 3)
                            .onTapGesture {
                                print("image4")
                                self.showScannerSheetVAXBack = true
                            }
                    }
                }.padding(.horizontal, 20)
                    .padding(.bottom, 40)
                
            }
            .navigationTitle("Digital Wallet")

        }
        .sheet(isPresented: $showScannerSheetNYTFront) {
            ScannerView(images: $nyitFront).ignoresSafeArea().onDisappear {
                UserDefaults.standard.set(nyitFront.jpegData(compressionQuality: 1.0), forKey: "nyitFront")
            }
            
        }
        .sheet(isPresented: $showScannerSheetNYTBack) {
            ScannerView(images: $nyitBack).ignoresSafeArea().onDisappear {
                UserDefaults.standard.set(nyitBack.jpegData(compressionQuality: 1.0), forKey: "nyitBack")
            }
        }

        .sheet(isPresented: $showScannerSheetVAXFront) {
            ScannerView(images: $vaxFront).ignoresSafeArea().onDisappear {
                UserDefaults.standard.set(vaxFront.jpegData(compressionQuality: 1.0), forKey: "vaxFront")
            }
        }

        .sheet(isPresented: $showScannerSheetVAXBack) {
            ScannerView(images: $vaxBack).ignoresSafeArea().onDisappear {
                UserDefaults.standard.set(vaxBack.jpegData(compressionQuality: 1.0), forKey: "vaxBack")
            }
        }
        
        .onAppear {
            if UserDefaults.standard.data(forKey: "nyitFront") != nil {
                print("nyitFront exits")
                guard let data = UserDefaults.standard.data(forKey: "nyitFront") else {return}
                nyitFront = UIImage(data:data)!
            }else{
                print("nyitFront does not exist")
            }
            
            if UserDefaults.standard.data(forKey: "nyitBack") != nil {
                print("nyitBack exits")
                guard let data = UserDefaults.standard.data(forKey: "nyitBack") else {return}
                nyitBack = UIImage(data:data)!
            }else{
                print("nyitBack does not exist")
            }
            
            if UserDefaults.standard.data(forKey: "vaxFront") != nil {
                print("vaxFront exits")
                guard let data = UserDefaults.standard.data(forKey: "vaxFront") else {return}
                vaxFront = UIImage(data:data)!
            }else{
                print("vaxFront does not exist")
            }
            
            if UserDefaults.standard.data(forKey: "vaxBack") != nil {
                print("vaxBack exits")
                guard let data = UserDefaults.standard.data(forKey: "vaxBack") else {return}
                vaxBack = UIImage(data:data)!
            }else{
                print("vaxBack does not exist")
            }
        }
    }
}



