//
//  DigitalCardController.swift
//  IDNYT
//
//  Created by Prince on 11/2/21.
//


// make names + keys for the default images, then if the keys dont have text ("") that means it has a picture of the card now
import UIKit
import ImageSlideshow
import WeScan

class DigitalCardController: UIViewController, ImageScannerControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nyitCardLabel: UILabel!
    @IBOutlet weak var vaxCardLabel: UILabel!
    @IBOutlet weak var nyitSlideShow: ImageSlideshow!
    
    var nyitPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nyitSlideShow.setImageInputs([
            ImageSource(image: UIImage(named: "AddImage")!),
            ImageSource(image: UIImage(named: "AddImage")!)
        ])
        nyitSlideShow.zoomEnabled = true
        nyitSlideShow.circular = false
        nyitSlideShow.pageIndicator = nil
        nyitSlideShow.zoomEnabled = false
        nyitSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: .yellow)
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(DigitalCardController.didTapNYT))
        nyitSlideShow.addGestureRecognizer(gestureRec)
    }
    
    @objc func didTapNYT(){
        //nyitSlideShow.presentFullScreenController(from: self)
        
        nyitPosition = nyitSlideShow.currentPage
        print(nyitPosition)
        
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
            
            //saves image to app locally
            guard let data = UIImage(named: "nyitFront")?.jpegData(compressionQuality: 0) else {return}
            let encoded = try! PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "nyitFront")
            
        if(nyitPosition == 0){
            //sets first image
            nyitSlideShow.setImageInputs([
                ImageSource(image: results.croppedScan.image)
            ])
            //checks if second image is avalible
            guard let data = UserDefaults.standard.data(forKey: "nyitBack") else {return}
            let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
            let backImage = UIImage(data: decoded)
        
        }
        
        nyitSlideShow.setImageInputs([
            ImageSource(image: results.croppedScan.image)
        ])
        scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }


}
