/*
 VisionRecognizer.swift
 OCR Scanner

 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
    Vision Recognizer: Vision Method to Extract Frames from the Camera using AVFoundation & Vision.
*/


import UIKit
import AVFoundation
import Vision


// Protocol:
protocol VisionRecognizerDelegate: AnyObject {

}


class VisionRecognizer: ModelProcessorViewController {
  
    
    // Enums:
    enum Candidate: Hashable {
        case number(String), name(String)
        case issueDate(DateComponents)
        case expireDate(DateComponents)
       }

    
    // Intialize:
    typealias PredictedCount = Int
    private var selectedCard = CreditCard()
    
    
    // Properties
    private var predictedCardInfo: [Candidate: PredictedCount] = [:]
    private var dateCount = 0
    private var intYear = 0
    private var intExpYear = 0
    
    
    // Detect Recentangle Object:
    private func detectRectangle(in image: CVPixelBuffer) {
        let request = VNDetectRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            
            DispatchQueue.main.async {
                guard let results = request.results as? [VNRectangleObservation] else { return }
                self.removeMask()
                
                guard let rect = results.first else { return }
                    self.drawBoundingBox(rect: rect)
            }
        })
                
                request.minimumAspectRatio = VNAspectRatio(1.3)
                request.maximumAspectRatio = VNAspectRatio(1.6)
                request.minimumSize = Float(0.5)
                request.maximumObservations = 1
                request.minimumConfidence = 1.0

                
                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
                try? imageRequestHandler.perform([request])
    }
    
    
    // Draw Rectangle Box:
    func drawBoundingBox(rect : VNRectangleObservation) {
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.previewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: self.previewLayer.frame.width, y: self.previewLayer.frame.height)

        let bounds = rect.boundingBox.applying(scale).applying(transform)
        createLayer(in: bounds)

    }
    
    
    // Create ROI UI:
    private func createLayer(in rect: CGRect) {
        boundLayer = CAShapeLayer()
        boundLayer.frame = rect
        boundLayer.cornerRadius = 10
        boundLayer.opacity = 0.5
        boundLayer.borderColor = UIColor.green.cgColor
        boundLayer.borderWidth = 5.0
        
        previewLayer.insertSublayer(boundLayer, at: 1)
    }
    
    
    // Remove Mask:
    func removeMask() {
            boundLayer.removeFromSuperlayer()
    }

}
