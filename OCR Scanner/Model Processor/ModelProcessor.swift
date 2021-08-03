/*
 ModelProcessor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Model Processor: Parent & Abstract Class.
 */


import Vision


protocol ModelProcessorProtocol {
    
    // Methods:
    func analyzeImage(_ extractedImage: CGImage, _ regionOfInterest: Dictionary <Int, CGRect>) -> String?
    func analyzeImage(_ extractedImage: CGImage) -> String?
}


open class ModelProcessor: ModelProcessorProtocol {
    
    // Methods:
    public func analyzeImage(_ extractedImage: CGImage, _ regionOfInterest: Dictionary <Int, CGRect>) -> String? {
        
        // Definition in Child-Class.
        
        return nil
    }
    
    public func analyzeImage(_ extractedImage: CGImage) -> String? {
        
        // Definition in Child-Class.
        
        return nil
    }
}
