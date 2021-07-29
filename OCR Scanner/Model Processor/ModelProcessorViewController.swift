/*
 ModelProcessorViewController.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Model Processor View Controller: Handles Camera I/O, OCR ROI and Bounding Box.
 */


import UIKit
import AVFoundation
import AVFoundation
import Vision


// Protocols:
protocol ModelProcessorDelegate {
    // Implement Protocol Here
}


class ModelProcessorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // IBOutlets:
    @IBOutlet weak var previewCamera: UIView!
    @IBOutlet weak var focusView: UIView!
    
    
    // Initialize:
    var maskLayer = CAShapeLayer()
    var boundLayer = CAShapeLayer()
    
    
    // Delegate:
    private lazy var cameraView: CameraView = CameraView(
        delegate: self,
        previewCamera: self.previewCamera,
        focusView: self.focusView,
        maskLayer: self.maskLayer,
        boundLayer: self.boundLayer
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call Methods:
        setupUI()
        cameraView.setupCamera()
        cameraView.addPreviewLayer()
        
        DispatchQueue.main.async {
            self.cameraView.calculateRegionOfInterest()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Preview UI:
        self.cameraView.updateFocusView()
        self.cameraView.videoPreviewLayer.frame = self.previewCamera.frame
    }
    
    
    // Clean Up Function:
    override func viewDidDisappear(_ animated: Bool) {
        cameraView.stopSession()
    }
    
    
    // Setup UI:
    func setupUI() {
        // Setup UI In Controller:
        focusView.backgroundColor = UIColor.gray.withAlphaComponent(0.9)
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.fillRule = .evenOdd
        focusView.layer.mask = maskLayer
    }
}


// MARK: Extension CameraViewDelegate:
extension ModelProcessorViewController: CameraViewDelegate {
    
}
