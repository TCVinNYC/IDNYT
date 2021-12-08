//
//  ScannerView.swift
//  IDNYT
//
//  Created by Prince on 12/5/21.
//

import SwiftUI
import VisionKit
import WeScan

struct ScannerView : UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var images : UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> ImageScannerController {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: ImageScannerController, context: Context) {
        //
    }
    func makeCoordinator() -> Coordinator {
         Coordinator(images: $images, parent: self)
    }
    
    class Coordinator: NSObject, ImageScannerControllerDelegate, ObservableObject{
        
        var parent: ScannerView
        var images : Binding<UIImage>
        
        init(images: Binding<UIImage>, parent: ScannerView){
            self.images = images
            self.parent = parent
        }
        
        func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
            // You are responsible for carefully handling the error
            print(error)
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
            // The user successfully scanned an image, which is available in the ImageScannerResults
            // You are responsible for dismissing the ImageScannerController
            scanner.dismiss(animated: true)
            images.wrappedValue = results.croppedScan.image
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
            // The user tapped 'Cancel' on the scanner
            // You are responsible for dismissing the ImageScannerController
            scanner.dismiss(animated: true)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
