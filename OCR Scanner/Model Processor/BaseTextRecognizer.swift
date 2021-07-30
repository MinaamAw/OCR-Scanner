/*
 BaseTextRecognizer.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Base Text Recognizer: Uses Apple's Vision to Perform OCR Extraction.
 */


import Vision


final class BaseTextRecognizer: ModelProcessor {
    
    // Initialize:
    var textRequest = VNRecognizeTextRequest()
    
    
    // Methods:
    public override func analyzeImage(extractedImage: CGImage) -> String? {
        
        // Initialize:
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
            
            DispatchQueue.main.async {
                
                // Print Text Read:
                print(text)
                extractedText = text
            }
        }
        
        // OCR Properties & Request:
        textRequest.recognitionLevel = .accurate
        try? VNImageRequestHandler(cgImage: extractedImage, options: [:]).perform([textRequest])
        
        return extractedText
    }
}
