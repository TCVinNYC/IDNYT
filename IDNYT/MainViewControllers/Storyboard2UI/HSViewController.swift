//
//  HSViewController.swift
//  IDNYT
//
//  Created by Prince on 11/22/21.
//

import Foundation
import UIKit
import SwiftUI


class HSViewController : UIViewController {
    
    override func viewDidLoad() {
        let vc = HealthScreenView()
        
        let hostingController = UIHostingController.init(rootView: vc)
        self.addChild(hostingController)
        hostingController.didMove(toParent: self)
        self.view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    
}
