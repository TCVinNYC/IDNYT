//
//  NFCController.swift
//  IDNYT
//
//  Created by Prince on 11/28/21.
//

import SwiftUI
import CoreNFC

struct nfcButton : UIViewRepresentable{
    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<nfcButton>) {
        //
    }
    
    @Binding var result : String
    func makeUIView(context: UIViewRepresentableContext<nfcButton>) -> UIButton {
        let button = UIButton()
        button.setTitle("Scan NFC", for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScanning(_:)), for: .touchUpInside)
        return button
    }
    
    func makeCoordinator() -> nfcButton.Coordinator {
        return Coordinator(result: $result)
    }
    
    class Coordinator : NSObject, NFCNDEFReaderSessionDelegate {
        
        var session : NFCNDEFReaderSession?
        
        @Binding var result : String
        
        init(result : Binding<String>){_result = result}
        
        
        @objc func beginScanning(_ sender: Any){
            guard NFCNDEFReaderSession.readingAvailable else {
                print("Error: Scanning Not Supported")
                return
            }
            session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            session?.alertMessage = "Hold the top of your iPhone to the scanner."
            session?.begin()
        }
        
        
        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            if let readerError = error as? NFCReaderError{
                if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                    && (readerError.code != .readerSessionInvalidationErrorUserCanceled){
                    print("Error reading NFC: \(readerError.localizedDescription)")
                }
               
            }
            self.session = nil
        }
        
        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
            guard
                let nfcMessage = messages.first,
                let record = nfcMessage.records.first,
                record.typeNameFormat == .nfcWellKnown,
                let payload : String = String(data: record.payload.advanced(by:3), encoding: .utf8)
            else{
                return
            }
            print(payload)
            self.result = payload
            
        }
        

        
        
    }
}
