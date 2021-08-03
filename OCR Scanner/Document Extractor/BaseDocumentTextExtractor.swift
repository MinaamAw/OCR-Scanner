/*
 BaseDocumentExtractor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Base Document Extractor: Parent & Abstract Class.
 */


protocol BaseDocumentExtractorProtocol {
    
    // Method:
    func textExtractor(_ extractedText: String)
    func documentROI() -> Dictionary <Int, CGRect>?
}


open class BaseDocumentExtractor: DocumentExtractor, BaseDocumentExtractorProtocol {
    
    // Initialize:
    
    
    // Handle Document Extraction:
    public override func extractionHandler(_ extractedImage: CGImage, _ regionOfInterest: Dictionary <Int, CGRect>) -> String? {
        
        // Initialize:
        let modelProcessor: ModelProcessor = BaseTextRecognizer()
        
        // Method Call;
        let extractionResult = modelProcessor.analyzeImage(extractedImage, regionOfInterest)
        
        return extractionResult
    }
    
    
    // Text Extraction & Parse:
    func textExtractor(_ extractedText: String) {
        
        // Definition in Child Class.
    }
    
    // Document ROI:
    public func documentROI() -> Dictionary <Int, CGRect>? {
        
        return nil
    }
}
