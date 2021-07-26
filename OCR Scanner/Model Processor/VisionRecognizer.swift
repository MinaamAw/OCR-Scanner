/*
 VisionRecognizer.swift
 OCR Scanner

 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
    Vision Recognizer: Vision Method to Extract Frames from the Camera using AVFoundation & Vision.
*/


import Foundation
import UIKit
import AVFoundation
import Vision


class VisionRecognizer: ModelProcessorViewController {
    
    // Detect Recentangle Object:
    public func detectRectangle(in image: CVPixelBuffer) {
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
    private func drawBoundingBox(rect : VNRectangleObservation) {
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
    private func removeMask() {
            boundLayer.removeFromSuperlayer()
    }
}


// Extension:
extension ModelProcessorViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Extract Frames from Feed:
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Implementation in VisionRecognizer.swift
        //print("Frame Received", Date())
        
        // Convert Frames to UIImage:
        guard let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        guard let quartzImage = context?.makeImage() else { return }
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        let trgtImage = UIImage(cgImage: quartzImage)
        
              
        let srcImg = #imageLiteral(resourceName: "CNICFormat")
        //let filteredImage = #imageLiteral(resourceName: "trgtImage")
        var temp = false
        
        temp = FeatureExtractionBridge().extraction_result(srcImg, targetImage: trgtImage)
        if temp == true {
            print("Done")
        }
    }
}
