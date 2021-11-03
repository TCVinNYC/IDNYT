//
//  DigitalCardController.swift
//  IDNYT
//
//  Created by Prince on 11/2/21.
//


// make names + keys for the default images, then if the keys dont have text ("") that means it has a picture of the card
import UIKit
import ImageSlideshow
import WeScan

class DigitalCardController: UIViewController, ImageScannerControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nyitCardLabel: UILabel!
    @IBOutlet weak var vaxCardLabel: UILabel!
    @IBOutlet weak var nyitSlideShow: ImageSlideshow!
    @IBOutlet weak var vaxSlideShow: ImageSlideshow!
    
    var nyitPosition = 0
    var vaxPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        nyitSlideShow.zoomEnabled = true
        nyitSlideShow.circular = false
        nyitSlideShow.pageIndicator = nil
        nyitSlideShow.zoomEnabled = false
        nyitSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: .yellow)
        
        vaxSlideShow.zoomEnabled = true
        vaxSlideShow.circular = false
        vaxSlideShow.pageIndicator = nil
        vaxSlideShow.zoomEnabled = false
        vaxSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: .yellow)
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(DigitalCardController.didTapNYT))
        nyitSlideShow.addGestureRecognizer(gestureRec)
        
        let gestureRec2 = UITapGestureRecognizer(target: self, action: #selector(DigitalCardController.didTapVAX))
        vaxSlideShow.addGestureRecognizer(gestureRec2)
    }
    
    
    //****figure out a way for people to hold the image and show the full view
    @objc func didTapNYT(){
        //nyitSlideShow.presentFullScreenController(from: self)
        
        nyitPosition = nyitSlideShow.currentPage
        print(nyitPosition)
        
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
    
    @objc func didTapVAX(){
        //nyitSlideShow.presentFullScreenController(from: self)
        
        vaxPosition = vaxSlideShow.currentPage
        print(vaxPosition)
        
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
        if(nyitPosition == 0){
            print("replacing nyitFront")
            //sets first image

            let imageData = results.croppedScan.image.jpegData(compressionQuality: 1.0)
            UserDefaults.standard.set(imageData, forKey: "nyitFront")
            print("dismissing scanner")
            scanner.dismiss(animated: true)
            print("reloading images")

        }else if(nyitPosition == 1){
            print("replacing nyitBack")
            //sets first image
            let imageData = results.croppedScan.image.jpegData(compressionQuality: 1.0)
            UserDefaults.standard.set(imageData, forKey: "nyitBack")
            print("dismissing scanner")
            scanner.dismiss(animated: true)
            print("reloading images")
            
        }else if(vaxPosition == 0){
            print("replacing vaxFront")
            //sets first image
            let imageData = results.croppedScan.image.jpegData(compressionQuality: 1.0)
            UserDefaults.standard.set(imageData, forKey: "vaxFront")
            print("dismissing scanner")
            scanner.dismiss(animated: true)
            print("reloading images")

        }else if(vaxPosition == 1){
            print("replacing vaxBack")
            //sets first image
            let imageData = results.croppedScan.image.jpegData(compressionQuality: 1.0)
            UserDefaults.standard.set(imageData, forKey: "vaxBack")
            print("dismissing scanner")
            scanner.dismiss(animated: true)
            print("reloading images")
            
        }else{print("replaced nothing")}
        
        nyitPosition = -1
        vaxPosition = -1
        loadImages()
        return
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
    
    func loadImages(){
        
        print("getting image data")
        guard let data = UserDefaults.standard.data(forKey: "nyitFront") else {return}
        let nyitFrontImage = UIImage(data:data)
        
        guard let data2 = UserDefaults.standard.data(forKey: "nyitBack") else {return}
        let nyitBackImage = UIImage(data:data2)
        
        guard let data3 = UserDefaults.standard.data(forKey: "vaxFront") else {return}
        let vaxFrontImage = UIImage(data:data3)
        
        guard let data4 = UserDefaults.standard.data(forKey: "vaxBack") else {return}
        let vaxBackImage = UIImage(data:data4)
        
        
        print("loading images")
        nyitSlideShow.setImageInputs([
            ImageSource(image: nyitFrontImage!),
            ImageSource(image: nyitBackImage!)
        ])
        
        vaxSlideShow.setImageInputs([
            ImageSource(image: vaxFrontImage!),
            ImageSource(image: vaxBackImage!)
        ])
    }

}
