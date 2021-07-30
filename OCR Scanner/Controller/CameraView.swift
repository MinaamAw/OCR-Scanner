/*
 CameraView.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 28/07/2021.
 
 Abstract:
 Camera View: Responsible for Frame Extraction, Bounding Box and Image Cropping.
 */


import Foundation
import AVFoundation
import Vision
import VideoToolbox


// Protocols:
public protocol CameraViewDelegate: AnyObject {
    
    func processImage(extractedImage: CGImage)
}


final class CameraView: UIView {
    
    // Delegates:
    weak var delegate: CameraViewDelegate?
    
    
    // Initialize:
    private var maskLayer = CAShapeLayer()
    private var boundLayer = CAShapeLayer()
    private var bufferAspectRatio: Double!
    private var previewCamera: UIView!
    private var focusView: UIView!
    private var croppedImage: UIImage?
    private var cgImage: CGImage?
    
    
    // Capture Queue:
    private let captureSessionQueue = DispatchQueue(label: "com.Vikesyy.OCR-Scanner.CaptureSessionQueue")
    private let videoOutputQueue = DispatchQueue(label: "com.Vikesyy.OCR-Scanner.VideoOutputQueue")
    
    
    // ROI Properties:
    var currentOrientation = UIDeviceOrientation.portrait
    var textOrientation = CGImagePropertyOrientation.up
    var uiRotationTransform = CGAffineTransform.identity
    var bottomToTopTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
    var roiToGlobalTransform = CGAffineTransform.identity
    var visionToAVFTransform = CGAffineTransform.identity
    var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
    
    
    // MARK: Constructor:
    init(
        delegate: CameraViewDelegate,
        previewCamera: UIView,
        focusView: UIView,
        maskLayer: CAShapeLayer,
        boundLayer: CAShapeLayer
    ) {
        self.delegate = delegate
        self.previewCamera = previewCamera
        self.focusView = focusView
        self.maskLayer = maskLayer
        self.boundLayer = boundLayer
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Camera Functions:
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        
        return layer
    }
    
    private var videoSession: AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    public func stopSession() {
        videoSession?.stopRunning()
    }
    
    public func startSession() {
        videoSession?.startRunning()
    }
    
    public func setupCamera() {
        captureSessionQueue.async { [weak self] in
            self?._setupCamera()
        }
    }
    
    private func _setupCamera() {
        
        // Initialize:
        let captureSession = AVCaptureSession()
        let videoOutput = AVCaptureVideoDataOutput()
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: .back) else {
            print("Error: Device Issue")
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Error: Device Input")
            return
        }
        captureSession.canAddInput(deviceInput)
        captureSession.addInput(deviceInput)
        
        videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        
        guard captureSession.canAddOutput(videoOutput) else {
            print("Error: Device Output")
            return
        }
        
        captureSession.addOutput(videoOutput)
        captureSession.connections.forEach {
            $0.videoOrientation = .portrait
        }
        captureSession.commitConfiguration()
        
        DispatchQueue.main.async { [weak self] in
            self?.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self?.videoSession = captureSession
            self?.startSession()
        }
    }
    
    public func addPreviewLayer() {
        previewCamera.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = previewCamera.frame
    }
    
    
    // MARK: Calculate ROI:
    public func calculateRegionOfInterest() {
        
        // Desired Ratios for Credit Card/CNIC:
        let desiredHeightRatio = 0.6
        let desiredWidthRatio = 0.7
        let maxPortraitWidth = 0.9
        bufferAspectRatio = 1920.0 / 1080.0
        
        // Calculate ROI:
        let size: CGSize
        if currentOrientation.isPortrait || currentOrientation == .unknown {
            size = CGSize(width: min(desiredWidthRatio * bufferAspectRatio, maxPortraitWidth), height: desiredHeightRatio / bufferAspectRatio)
        } else {
            size = CGSize(width: desiredWidthRatio, height: desiredHeightRatio)
        }
        
        // Center Align:
        regionOfInterest.origin = CGPoint(x: (1 - size.width) / 2, y: (1 - size.height) / 2)
        regionOfInterest.size = size
        
        // Update ViewController:
        let ROI = regionOfInterest
        roiToGlobalTransform = CGAffineTransform(translationX: ROI.origin.x, y: ROI.origin.y).scaledBy(x: ROI.width, y: ROI.height)
        uiRotationTransform = CGAffineTransform(translationX: 0, y: 1).rotated(by: -CGFloat.pi / 2)
        
        // Update FocusView:
        DispatchQueue.main.async {
            self.updateFocusView()
        }
    }
    
    
    // MARK: Rectangle Detection & Bounding Box:
    private func detectRectangle(in image: CVPixelBuffer) -> UIImage? {
        
        let request = VNDetectRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            
            DispatchQueue.main.async {
                guard let results = request.results as? [VNRectangleObservation] else { return }
                self.removeMask()
                
                guard let rect = results.first else { return }
                self.drawBoundingBox(rect: rect)
                self.croppedImage = self.cropImage(rect, from: image)
            }
        })
        
        request.minimumAspectRatio = VNAspectRatio(1.3)
        request.maximumAspectRatio = VNAspectRatio(1.6)
        request.minimumSize = Float(0.5)
        request.maximumObservations = 1
        request.minimumConfidence = 1.0
        request.regionOfInterest = self.regionOfInterest
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
        try? imageRequestHandler.perform([request])
        
        return croppedImage
    }
    
    
    // Draw Rectangle Box:
    private func drawBoundingBox(rect : VNRectangleObservation) {
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.videoPreviewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: self.videoPreviewLayer.frame.width, y: self.videoPreviewLayer.frame.height)
        
        let bounds = rect.boundingBox.applying(scale).applying(transform)
        createLayer(in: bounds)
    }
    
    
    // Crop Image from RectangleRequest:
    private func cropImage(_ observation: VNRectangleObservation, from imageBuffer: CVImageBuffer) -> UIImage? {
        
        var ciImage = CIImage(cvImageBuffer: imageBuffer)
        
        let topLeft = observation.topLeft.scaled(to: ciImage.extent.size)
        let topRight = observation.topRight.scaled(to: ciImage.extent.size)
        let bottomLeft = observation.bottomLeft.scaled(to: ciImage.extent.size)
        let bottomRight = observation.bottomRight.scaled(to: ciImage.extent.size)
        
        ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight),
        ])
        
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        let croppedImg = UIImage(cgImage: cgImage!)
        //UIImageWriteToSavedPhotosAlbum(croppedImg, nil, nil, nil)
        
        return croppedImg
    }
    
    
    // Create ROI UI Bounds:
    private func createLayer(in rect: CGRect) {
        boundLayer = CAShapeLayer()
        boundLayer.frame = rect
        boundLayer.cornerRadius = 10
        boundLayer.opacity = 0.5
        boundLayer.borderColor = UIColor.green.cgColor
        boundLayer.borderWidth = 5.0
        
        videoPreviewLayer.insertSublayer(boundLayer, at: 1)
    }
    
    
    // Update focusView UI:
    public func updateFocusView() {
        let roiRectTransform = bottomToTopTransform.concatenating(uiRotationTransform)
        let focus = self.videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: regionOfInterest.applying(roiRectTransform))
        
        // Create Mask:
        let path = UIBezierPath(rect: focusView.frame)
        path.append(UIBezierPath(rect: focus))
        maskLayer.path = path.cgPath
    }
    
    
    // Remove Mask:
    private func removeMask() {
        boundLayer.removeFromSuperlayer()
    }
}


// MARK: Extensions:
extension CGPoint {
    func scaled(to size: CGSize) -> CGPoint {
        return CGPoint(x: self.x * size.width,
                       y: self.y * size.height)
    }
}


extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        // Get Frame from Buffer & Convert:
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Detect Card & Crop:
        guard let extractedImg = detectRectangle(in: imageBuffer) else { return }
        
        // Template Matcher:
        let srcImg = #imageLiteral(resourceName: "CNICFormat")
        //let extractedFrame = #imageLiteral(resourceName: "CNIC Test")
        var cardType = false
        
        cardType = FeatureExtractionBridge().extraction_result(srcImg, targetImage: extractedImg)
        
        if cardType == true {
            UIImageWriteToSavedPhotosAlbum(extractedImg, nil, nil, nil)
            delegate?.processImage(extractedImage: extractedImg.cgImage!)
        }
        
        self.croppedImage = nil
    }
}
