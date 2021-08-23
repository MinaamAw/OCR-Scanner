/*
 CNICExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 CNIC Extractor: Generate Key Value Pairs and Model from Extracted Text.
 */


import Reg


final class CNICExtractor: BaseDocumentExtractor {
    
    // Define ROI's for CNIC:
    public override func documentROI() -> Dictionary <Int, CGRect> {
        
        // Initialize and Set Values:
        let roiCNIC: [Int: CGRect] = [
            //            1: CGRect(x: 0.06, y: 0.68, width: 0.6, height: 0.1),
            
            // Name
            1: CGRect(x: 0.05, y: 0.68, width: 0.9, height: 0.1),
            
            // Father Name
            2: CGRect(x: 0.05, y: 0.48, width: 0.9, height: 0.1),
            
            // Gender
            3: CGRect(x: 0.0, y: 0.28, width: 0.9, height: 0.1),
            
            // Country
            4: CGRect(x: 0.35, y: 0.29, width: 0.45, height: 0.09),
            
            // Identity
            5: CGRect(x: 0.05, y: 0.15, width: 0.47, height: 0.09),
            
            // Date of Birth
            6: CGRect(x: 0.5, y: 0.15, width: 0.5, height: 0.09),
            
            // Date of Issue
            7: CGRect(x: 0.06, y: 0.06, width: 0.4, height: 0.07),
            
            // Date of Expiry
            8: CGRect(x: 0.5, y: 0.06, width: 0.4, height: 0.07)
        ]
        
        return roiCNIC
    }
    
    // Text Extraction & Parse:
    public override func textExtractor(_ extractedText: String) -> Any? {
        
        // Initialize:
        var nameCount = 0
        var dateCount = 0
        var cnicFormat = CNIC()
        
        
        // Regular Expression Patterns:
        let name: Regex = #"([A-z]{3,}\h([A-z.]+\h)?[A-z]{2,})"#
        let gender: Regex = #"^([M | F]{1})$"#
        let date: Regex = #"^([0]?[1-9]|[1|2][0-9]|[3][0|1])[. / - \s]([0]?[1-9]|[1][0-2])[. / - \s]([1-9][0-9]{3})$"#
        let countries: Regex = #"([A-z]{4,})$"#
        let identity: Regex = #"([0-9]{5})[-]([0-9]{7})[- \s]([0-9]{1})$"#
        
        
        // Extract Lines:
        extractedText.enumerateLines { (line, _) in
            
            // Conditions:
            if let holderName = name.firstMatch(in: line) {
                
                // Conditions:
                if (nameCount == 0) {
                    
                    // Assign Value:
                    cnicFormat.holderName = holderName
                    nameCount = nameCount + 1
                } else {
                    
                    // Assign Value:
                    cnicFormat.fatherName = holderName
                }
                
            } else if let gender = gender.firstMatch(in: line) {
                
                // Assign Value:
                cnicFormat.gender = gender
                
            } else if let identityCNIC = identity.firstMatch(in: line)?
                        .replacingOccurrences(of: " ", with: "-") {
                
                // Assign Value:
                cnicFormat.identityNumber = identityCNIC
                
            } else if let country = countries.firstMatch(in: line) {
                
                // Assign Value:
                cnicFormat.countryStay = country
                
            } else if let dates = date.firstMatch(in: line)?
                        .replacingOccurrences(of: ".", with: "/")
                        .replacingOccurrences(of: " ", with: "/") {
                
                // Conditions:
                if (dateCount == 0) {
                    
                    // Assign Value:
                    cnicFormat.birthDate = dates
                    dateCount = dateCount + 1
                    
                } else if (dateCount == 1) {
                    
                    // Assign Value:
                    cnicFormat.issueDate = dates
                    dateCount = dateCount + 1
                    
                } else {
                    
                    // Assign Value:
                    cnicFormat.expireDate = dates
                    dateCount = dateCount + 1
                }
            } else {
                print(line)
            }
        }
        
        return cnicFormat
    }
}
