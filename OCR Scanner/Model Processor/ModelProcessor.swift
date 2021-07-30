/*
 ModelProcessor.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Model Processor: Parent & Abstract Class.
 */


protocol ModelProcessorProtocol {
    
    // Methods:
    func analyzeImage(extractedImage: CGImage) -> String?
}


open class ModelProcessor: ModelProcessorProtocol {
    
    // Initialize:
    private var extractedImage: CGImage?
    private var imageKind: ImageKind?
    
    
    // Methods:
    public func analyzeImage(extractedImage: CGImage) -> String? {
        
        // Definition in Child-Class.
        
        return nil
    }
}
