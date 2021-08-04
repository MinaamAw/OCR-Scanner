/*
 BaseTextRecognizer.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Base Text Recognizer: Uses Apple's Vision to Perform OCR Extraction.
 */


import Vision


final class BaseTextRecognizer: ModelProcessor {
    
    // Methods:
    public override func analyzeImage(_ extractedImage: CGImage, _ regionOfInterest: Dictionary <Int, CGRect>) -> String? {
        
        // Initialize:
        var textRequest = VNRecognizeTextRequest()
        var extractInfo: String = ""
        
        
        // Process:
        textRequest = VNRecognizeTextRequest { textRequest, error in
            guard let observations = textRequest.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            
            // Assign Value:
            if (text == "") {
                extractInfo.addString(str: "nil")
            } else {
                extractInfo.addString(str: text)
            }
        }
        
        
        // Extract Text for Required Regions
        let sortedArray = regionOfInterest.sorted( by: { $0.0 < $1.0 })
        
        
        // Loop through ROIs:
        for (_ , value) in sortedArray {
            
            // OCR Properties:
            textRequest.recognitionLevel = .accurate
            textRequest.regionOfInterest = value
            textRequest.usesLanguageCorrection = false
            
            // Execute:
            try? VNImageRequestHandler(cgImage: extractedImage, options: [:]).perform([textRequest])
        }
        
        return extractInfo
    }
    
    
    // Default Implementation:
    public override func analyzeImage(_ extractedImage: CGImage) -> String? {
        
        // Initialize:
        var textRequest = VNRecognizeTextRequest()
        var extractedText: String?
        
        // Process:
        textRequest = VNRecognizeTextRequest { textRequest, error in
            guard let observations = textRequest.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            
            // Assign Value:
            extractedText = text
            
            print(text)
        }
        
        // OCR Properties:
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = false
        
        // Execute:
        try? VNImageRequestHandler(cgImage: extractedImage, options: [:]).perform([textRequest])
        
        
        return extractedText
    }
}


// Extensions:
extension String {
    mutating func addString(str: String) {
        self = self + str + "\n"
    }
}
