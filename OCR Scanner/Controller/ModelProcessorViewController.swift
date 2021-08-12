/*
 ModelProcessorViewController.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Model Processor View Controller: Handles Camera View & Model Processor.
 */


import UIKit
import AVFoundation
import AVFoundation
import Vision


class ModelProcessorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // IBOutlets:
    @IBOutlet weak var previewCamera: UIView!
    @IBOutlet weak var focusView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
        self.setupUI()
        self.cameraView.setupCamera()
        
        DispatchQueue.main.async {
            self.cameraView.addPreviewLayer()
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
    
    
    // Memory Warning:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Setup UI:
    func setupUI() {
        // Setup UI In Controller:
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        
        focusView.backgroundColor = UIColor.gray.withAlphaComponent(0.9)
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.fillRule = .evenOdd
        focusView.layer.mask = maskLayer
    }
}


// MARK: Extension CameraViewDelegate:
extension ModelProcessorViewController: CameraViewDelegate {
    internal func processImage(_ extractedImage: CGImage, _ imageKind: ImageKind) {
        
        // Initialize:
        let extractionResult: Any?
        
        
        // MARK: Camera Session:
        DispatchQueue.main.async {
            
            // Camera Preview:
            self.cameraView.stopSession()
            self.cameraView.processModel()
            
            // Controller UI:
            self.previewCamera.layer.removeFromSuperlayer()
            self.focusView.backgroundColor = .systemBackground
            self.activityIndicator.startAnimating()
        }
        
        
        // MARK: Document Extractor:
        let documentExtractor: DocumentExtractor = BaseDocumentExtractor()
        let documentRepresentation: DocumentRepresentation = BaseDocumentRepresentation()
        
        if (imageKind == .cnic) {
            
            // CNIC Extraction & Representation:
            let cnicExtractor: BaseDocumentExtractor = CNICExtractor()
            
            let cnicROI = CNICExtractor()
            
            // CNIC Text Extraction & Model:
            let regionOfInterest = cnicROI.documentROI()
            
            guard let extractedResult = documentExtractor.extractionHandler(extractedImage, regionOfInterest) else { return }
            extractionResult = cnicExtractor.textExtractor(extractedResult)
            
            // CNIC Representation:
            let representationResult = documentRepresentation.representationHandler(imageKind)
            
            let uiImage = UIImage(cgImage: extractedImage)
            
            DispatchQueue.main.async {
                
                let cnicViewController =
                    self.storyboard?.instantiateViewController(identifier: representationResult!) as! PakistanCNICDocumentRepresentationViewController
                
                // Present:
                cnicViewController.documentArray.append(extractionResult as! CNIC)
                cnicViewController.imgView = uiImage
                
                self.navigationController?.pushViewController(cnicViewController, animated: true)
            }
            
        } else if (imageKind == .creditCard) {
            
            // Credit Card Extraction & Representation:
            let creditCardExtractor: BaseDocumentExtractor = CreditCardExtractor()
            
            let ccROI = CreditCardExtractor()
            
            // CNIC Text Extraction & Model:
            let regionOfInterest = ccROI.documentROI()
            
            guard let extractedResult = documentExtractor.extractionHandler(extractedImage, regionOfInterest) else { return }
            
            print(extractedResult)
            
            extractionResult = creditCardExtractor.textExtractor(extractedResult)
            
            print(extractedResult)
            
        } else {
            print("Document not Recognized.")
        }
        
    }
}
