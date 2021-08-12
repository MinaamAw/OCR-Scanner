/*
 CreditCardExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Credit Card Extractor: OCR Method to Detect Text by the use of Frames Extracted from Feed using Vision Framework.
 */


import Reg


final class CreditCardExtractor: BaseDocumentExtractor {
    
    // Define ROI's for Credit Card:
    public override func documentROI() -> Dictionary <Int, CGRect> {
        
        // Initialize and Set Values:
        let roiCreditCard: [Int: CGRect] = [
            //            1: CGRect(x: 0.06, y: 0.68, width: 0.6, height: 0.1),
            
            // Card Number
            1: CGRect(x: 0.1, y: 0.3, width: 0.85, height: 0.2),
            
            // Date of Issue
            2: CGRect(x: 0.12, y: 0.18, width: 0.2, height: 0.1),
            
            // Date of Expiry
            3: CGRect(x: 0.4, y: 0.18, width: 0.2, height: 0.1),
            
            // Holder Name
            4: CGRect(x: 0.0, y: 0.0, width: 0.8, height: 0.15)
        ]
        
        return roiCreditCard
    }
    
    
    // Text Extraction & Parse:
    public override func textExtractor(_ extractedText: String) -> Any? {
        
        // Initialize:
        var ccFormat = CreditCard()
        
        
        // Regular Expression Patterns:
        let name: Regex = #"([A-z]{4,}\h([A-z.]+\h)?[A-z]{2,})"#
        let creditCard: Regex = #"(?:\d[ -]*?){13,16}"#
        
        // Extract Lines:
        extractedText.enumerateLines { (line, _) in
            
            // Conditions:
            if let holderName = name.firstMatch(in: line) {
                
                // Assign Value:
                ccFormat.holderName = holderName
                print("Holder Name: \(holderName)")
                
            } else if let creditCardNumber = creditCard.firstMatch(in: line) {
                
                // Assign Value:
                ccFormat.cardNumber = creditCardNumber
                print("Credit Card Number: \(creditCardNumber)")
                
            } else {
                print(line)
            }
        }
        
        return ccFormat
    }
}
