/*
 DocumentExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Document Extractor: Parent & Abstract Class.
 */


protocol DocumentExtractorProtocol {
        
    // Method:
    func extractionHandler(_ documentKind: ImageKind, _ extractedText: String)
}


open class DocumentExtractor: DocumentExtractorProtocol {
    
    // Method:
    public func extractionHandler(_ documentKind: ImageKind, _ extractedText: String) {
     
        // Definition in Child Class.
    }
}
