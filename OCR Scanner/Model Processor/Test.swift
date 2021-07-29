///*
// ModelProcessorViewController.swift
// OCR Scanner
// 
// Created by Minaam Ahmed Awan on 11/07/2021.
// 
// Abstract:
// Model Processor View Controller: Handles Camera I/O, OCR ROI and Bounding Box.
// */
//
//
//import UIKit
//import AVFoundation
//import AVFoundation
//import Vision
//
//
//// Protocols:
//protocol ModelPrssocessorDelegate {
//    // Implement Protocol Here
//}
//
//
//class ModelProcessosssrViewController: UIViewController {
//    
//    // IBOutlets:
//    @IBOutlet weak var previewCamera: UIView!
//    @IBOutlet weak var focusView: UIView!
//    
//    
//    // Camera Capture Session & Output Preview:
//    let captureSession = AVCaptureSession()
//    let videoOutput = AVCaptureVideoDataOutput()
//    let context = CIContext()
//    var captureDevice: AVCaptureDevice?
//    public lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
//        
//        return preview
//    }()
//    
//    
//    // Manage Thread Queue:
//    let captureSessionQueue = DispatchQueue(label: "com.Vikesyy.OCR-Scanner.CaptureSessionQueue")
//    let videoOutputQueue = DispatchQueue(label: "com.Vikesyy.OCR-Scanner.VideoOutputQueue")
//    
//    
//    // Region of Interest:
//    var maskLayer = CAShapeLayer()
//    var boundLayer = CAShapeLayer()
//    var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
//    
//    
//    // Orientation Properties:
//    var currentOrientation = UIDeviceOrientation.portrait
//    var textOrientation = CGImagePropertyOrientation.up
//    var bufferAspectRatio: Double!
//    var uiRotationTransform = CGAffineTransform.identity
//    var bottomToTopTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
//    var roiToGlobalTransform = CGAffineTransform.identity
//    var visionToAVFTransform = CGAffineTransform.identity
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Call Methods:
//        setupUI()
//        addPreviewLayer()
//        
//        // Start Thread:
//        captureSessionQueue.async {
//            self.addCameraInput()
//            self.addVideoOutput()
//            self.captureSession.startRunning()
//            
//            // Calculate ROI:
//            DispatchQueue.main.async {
//                self.calculateRegionOfInterest()
//            }
//        }
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // Calculate ROI:
//        calculateRegionOfInterest()
//        
//        // Preview UI:
//        self.previewLayer.frame = self.previewCamera.frame
//        updateFocusView()
//    }
//    
//    
//    // Clean Up Function:
//    override func viewDidDisappear(_ animated: Bool) {
//        videoOutput.setSampleBufferDelegate(nil, queue: nil)
//        self.captureSession.stopRunning()
//    }
//    
//    
//    // Setup UI:
//    func setupUI() {
//        // Setup UI In Controller:
//        focusView.backgroundColor = UIColor.gray.withAlphaComponent(0.9)
//        maskLayer.backgroundColor = UIColor.clear.cgColor
//        maskLayer.fillRule = .evenOdd
//        focusView.layer.mask = maskLayer
//    }
//    
//    
//    // Add Camera Input:
//    func addCameraInput() {
//        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
//        self.captureDevice = captureDevice
//        
//        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
//        bufferAspectRatio = 1920.0 / 1080.0
//        
//        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
//        
//        captureSession.addInput(deviceInput)
//    }
//    
//    
//    // Add Preview UI to ViewController:
//    func addPreviewLayer() {
//        previewCamera.layer.addSublayer(self.previewLayer)
//        previewLayer.frame = self.previewCamera.frame
//    }
//    
//    
//    // Display Video Output:
//    func addVideoOutput() {
//        
//        // Frame Settings:
//        videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
//        videoOutput.alwaysDiscardsLateVideoFrames = true
//        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
//        captureSession.addOutput(self.videoOutput)
//        
//        // Portrait Mode Only
//        guard let connection = self.videoOutput.connection(with: AVMediaType.video),
//              connection.isVideoOrientationSupported else { return }
//        connection.videoOrientation = .portrait
//    }
//    
//    
//    // Calculate ROI:
//    func calculateRegionOfInterest() {
//        
//        // Desired Ratios
//        let desiredHeightRatio = 0.6
//        let desiredWidthRatio = 0.7
//        let maxPortraitWidth = 0.9
//        
//        // Figure out size of ROI.
//        let size: CGSize
//        if currentOrientation.isPortrait || currentOrientation == .unknown {
//            size = CGSize(width: min(desiredWidthRatio * bufferAspectRatio, maxPortraitWidth), height: desiredHeightRatio / bufferAspectRatio)
//        } else {
//            size = CGSize(width: desiredWidthRatio, height: desiredHeightRatio)
//        }
//        
//        // Make it centered.
//        regionOfInterest.origin = CGPoint(x: (1 - size.width) / 2, y: (1 - size.height) / 2)
//        regionOfInterest.size = size
//        
//        // Update ViewController.
//        let ROI = regionOfInterest
//        roiToGlobalTransform = CGAffineTransform(translationX: ROI.origin.x, y: ROI.origin.y).scaledBy(x: ROI.width, y: ROI.height)
//        //textOrientation = CGImagePropertyOrientation.right
//        uiRotationTransform = CGAffineTransform(translationX: 0, y: 1).rotated(by: -CGFloat.pi / 2)
//        
//        // Update FocusView:
//        DispatchQueue.main.async {
//            self.updateFocusView()
//        }
//    }
//    
//    
//    // Update focusView UIView:
//    func updateFocusView() {
//        let roiRectTransform = bottomToTopTransform.concatenating(uiRotationTransform)
//        let focus = previewLayer.layerRectConverted(fromMetadataOutputRect: regionOfInterest.applying(roiRectTransform))
//        
//        // Create the mask.
//        let path = UIBezierPath(rect: focusView.frame)
//        path.append(UIBezierPath(rect: focus))
//        maskLayer.path = path.cgPath
//    }
//    
//    // Detect Recentangle Object:
//    func detectRectangle(in image: CVPixelBuffer) -> UIImage {
//        
//        var bol = UIImage()
//        let request = VNDetectRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
//            
//            DispatchQueue.main.async {
//                guard let results = request.results as? [VNRectangleObservation] else { return }
//                self.removeMask()
//                
//                guard let rect = results.first else { return }
//                self.drawBoundingBox(rect: rect)
//                bol = self.doPerspectiveCorrection(rect, from: image)
//                
//            }
//        })
//        
//        request.minimumAspectRatio = VNAspectRatio(1.3)
//        request.maximumAspectRatio = VNAspectRatio(1.6)
//        request.minimumSize = Float(0.5)
//        request.maximumObservations = 1
//        request.minimumConfidence = 1.0
//        request.regionOfInterest = self.regionOfInterest
//        
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
//        try? imageRequestHandler.perform([request])
//        
//        return bol
//    }
//    
//    // Draw Rectangle Box:
//    public func drawBoundingBox(rect : VNRectangleObservation) {
//        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.previewLayer.frame.height)
//        let scale = CGAffineTransform.identity.scaledBy(x: self.previewLayer.frame.width, y: self.previewLayer.frame.height)
//        
//        let bounds = rect.boundingBox.applying(scale).applying(transform)
//        createLayer(in: bounds)
//        
//    }
//    
//    
//    // Crop Image from RectangleRequest:
//    func doPerspectiveCorrection(_ observation: VNRectangleObservation, from buffer: CVImageBuffer) -> UIImage {
//        
//        var ciImage = CIImage(cvImageBuffer: buffer)
//        
//        let topLeft = observation.topLeft.scaled(to: ciImage.extent.size)
//        let topRight = observation.topRight.scaled(to: ciImage.extent.size)
//        let bottomLeft = observation.bottomLeft.scaled(to: ciImage.extent.size)
//        let bottomRight = observation.bottomRight.scaled(to: ciImage.extent.size)
//        
//        // pass those to the filter to extract/rectify the image
//        ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
//            "inputTopLeft": CIVector(cgPoint: topLeft),
//            "inputTopRight": CIVector(cgPoint: topRight),
//            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
//            "inputBottomRight": CIVector(cgPoint: bottomRight),
//        ])
//        
//        let context = CIContext()
//        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
//        let output = UIImage(cgImage: cgImage!)
//        
//        return output
//    }
//    
//    
//    // Create ROI UI:
//    public func createLayer(in rect: CGRect) {
//        boundLayer = CAShapeLayer()
//        boundLayer.frame = rect
//        boundLayer.cornerRadius = 10
//        boundLayer.opacity = 0.5
//        boundLayer.borderColor = UIColor.green.cgColor
//        boundLayer.borderWidth = 5.0
//        
//        previewLayer.insertSublayer(boundLayer, at: 1)
//    }
//    
//    
//    // Remove Mask:
//    public func removeMask() {
//        boundLayer.removeFromSuperlayer()
//    }
//}
//
//
//// Extensions:
//extension CGPoint {
//    func scaled(to size: CGSize) -> CGPoint {
//        return CGPoint(x: self.x * size.width,
//                       y: self.y * size.height)
//    }
//}
