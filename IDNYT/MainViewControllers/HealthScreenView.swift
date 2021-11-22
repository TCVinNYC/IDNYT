//
//  HealthScreenView.swift
//  IDNYT
//
//  Created by Prince on 11/22/21.
//

import SwiftUI

struct HealthScreenView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("What campus are you entering?")
                Picker(selection: .constant(1), label: Text("Picker")) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                }
                
            }
            .navigationBarTitle("Health Screen")
        }
        
        
        
    }
}

struct HealthScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HealthScreenView()
    }
}
