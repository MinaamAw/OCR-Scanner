/*
 BaseDocumentExtractor.swift
 OCR Scanner

 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
    Basee Document Extractor: Parent & Abstract Class.
*/


protocol BaseDocumentExtractorProtocol {
    
    // Methods:
    func wordsToSkip(_ extractedText: String) -> String
    func textExtractor(_ extractedText: String) -> String
}


open class BaseDocumentExtractor: DocumentExtractor, BaseDocumentExtractorProtocol {
    
    // Initialize:
    var extractedKeys: AnyClass?
    
    
    // Handle Document Extraction based on Type:
    public override func extractionHandler(_ documentKind: ImageKind, _ extractedText: String) {
    
        // Handle Extraction:
        switch documentKind {
        case .creditCard:
            print("Credit Card")
        case .cnic:
            print("CNIC")
        default:
            break
        }
    }
    
    // Filter Generic String & Text from Raw Extraction
    public func wordsToSkip(_ extractedText: String) -> String {
        
        return extractedText
    }
    
    public func textExtractor(_ extractedText: String) -> String {
        return extractedText
    }
}
