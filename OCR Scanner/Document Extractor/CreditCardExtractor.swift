/*
 CreditCardExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Credit Card Extractor: OCR Method to Detect Text by the use of Frames Extracted from Feed using Vision Framework.
 */


import Reg


final class CreditCardExtractor: BaseDocumentExtractor {
    
    // Intialize:
    
    
    // Properties:
    private var dateCount = 0
    private var intYear = 0
    private var intExpYear = 0
    
    
    // Words to Filter Out:
    override public func wordsToSkip(_ extractedText: String) -> String {
        
        // Initialize:
        //var filteredText: String
        var text: String
        
        
        // Array:
        let lines = extractedText.components(separatedBy: "\n")
        print(lines)
        
        return extractedText
    }
}
