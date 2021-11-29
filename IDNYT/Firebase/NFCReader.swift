//
//  NFCReader.swift
//  IDNYT
//
//  Created by Prince on 11/26/21.
//

import Foundation
import CoreNFC
import SwiftUI

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate, ObservableObject{
    var session : NFCNDEFReaderSession?
    @State var showAlert = false

    var result : String = "no data"
    
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Started scanning for tags")
    }
    
    func beginScanning(location : String)-> String{
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return ""
        }
        //self.courseLoc = location
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold the top of your iPhone to the scanner."

        session?.begin()
        while(session != nil){
            //donothing
        }
        return self.result
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError{
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled){
                print("Error reading NFC: \(readerError.localizedDescription)")
                session.invalidate(errorMessage: "Error Reading NFC, Please Try Again!")
            }
           
        }
        self.session = nil
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        guard
            let nfcMessage = messages.first,
            let record = nfcMessage.records.first,
            record.typeNameFormat == .nfcWellKnown,
            let payload = String(data: record.payload.advanced(by:3), encoding: .utf8)
            //result = payload
        else{
            self.session = nil
            session.invalidate()
            return
        }
        result = payload
        print("done reading data")
    }
 
}
