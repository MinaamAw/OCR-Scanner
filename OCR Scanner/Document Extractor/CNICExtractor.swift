/*
 CNICExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 CNIC Extractor: Generate Key Value Pairs from Extracted Text.
 */


final class CNICExtractor: BaseDocumentExtractor {
    
    // Define ROI's for CNIC:
    public override func documentROI() -> Dictionary <Int, CGRect> {
        
        // Initialize and Set Values:
        let roiCNIC: [Int: CGRect] = [
//            1: CGRect(x: 0.06, y: 0.68, width: 0.6, height: 0.1),
            
            // Name
            1: CGRect(x: 0.05, y: 0.68, width: 0.55, height: 0.09),
            
            // Father Name
            2: CGRect(x: 0.06, y: 0.45, width: 0.9, height: 0.12),
            
            // Gender
            3: CGRect(x: 0.06, y: 0.3, width: 0.3, height: 0.07),
            
            // Country
            4: CGRect(x: 0.35, y: 0.3, width: 0.4, height: 0.09),
            
            // Identity
            5: CGRect(x: 0.5, y: 0.2, width: 0.45, height: 0.05),
            
            // Date of Birth
            6: CGRect(x: 0.05, y: 0.2, width: 0.46, height: 0.05),
            
            // Date of Issue:
            7: CGRect(x: 0.06, y: 0.06, width: 0.4, height: 0.07),
            
            // Date of Expiry;
            8: CGRect(x: 0.5, y: 0.06, width: 0.4, height: 0.07)
        ]
        
        return roiCNIC
    }
    
    // Text Extraction & Parse:
    public override func textExtractor(_ extractedText: String) {
        
        // Definition in Child Class.
        print(extractedText)
    }
}
