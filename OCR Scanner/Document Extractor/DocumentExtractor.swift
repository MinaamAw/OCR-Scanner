/*
 DocumentExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Document Extractor: Parent & Abstract Class.
 */


protocol DocumentExtractorProtocol {
    
    // Method:
    func extractionHandler(_ extractedImage: CGImage, _ regionOfInterest: Dictionary <Int, CGRect>) -> String?
}


open class DocumentExtractor: DocumentExtractorProtocol {
    
    // Method:
    public func extractionHandler(_ extractedImage: CGImage, _ regionOfInterest: Dictionary <Int, CGRect>) -> String? { return nil
    }
}
