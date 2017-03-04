//
//  ViewController.swift
//  KanjiFlashCard
//
//  Created by Nur Sabrina binti Zuraimi on 2017/03/04.
//  Copyright © 2017 Nur Sabrina binti Zuraimi. All rights reserved.
//

import UIKit
import TesseractOCR
import AVFoundation

class CaptureScreenView: UIViewController,AVCaptureMetadataOutputObjectsDelegate,AVCapturePhotoCaptureDelegate{
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var cameraOutput: AVCapturePhotoOutput?
    
    
    @IBOutlet weak var FrameView: UIView!

    @IBOutlet weak var Analyzeview: UIImageView!
    
    @IBAction func TestButton(_ sender: Any) {
        let image = UIImage(named: "hello.png")
        
        performImageRecognition(image: image!)
        
//        let settings = AVCapturePhotoSettings()
//        cameraOutput = AVCapturePhotoOutput()
//        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
//
//        captureSession?.startRunning()
//
//        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                             kCVPixelBufferWidthKey as String: 160,
//                             kCVPixelBufferHeightKey as String: 160,
//                             ]
//        settings.previewPhotoFormat = previewFormat
//        cameraOutput?.capturePhoto(with: settings, delegate: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraOutput = AVCapturePhotoOutput()
        
        startAVCapture()
        putAV()
        analyzeviewui()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func analyzeviewui(){
        Analyzeview.layer.borderColor = UIColor.green.cgColor
        Analyzeview.layer.borderWidth = 1.0
        Analyzeview.backgroundColor = UIColor.clear
        FrameView.addSubview(Analyzeview)
    }

    func startAVCapture(){
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
            
            captureSession?.addInput(input)
        } catch {
            print(error)
            return
        }
    }
    
    func putAV(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        FrameView.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()

    }
    
    func captureImage(){
        var stillImageOutput = AVCapturePhotoOutput()
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
        
        }
        }
        
//        let settings = AVCapturePhotoSettings()
//        cameraOutput = AVCapturePhotoOutput()
//        
//        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//
//        if let input = try? AVCaptureDeviceInput(device: captureDevice){
//            if(captureSession?.canAddInput(input))!{
//                captureSession?.addInput(input)
//                if(captureSession?.canAddOutput(cameraOutput))!{
//                    startAVCapture()
//                    captureSession?.addOutput(cameraOutput)
//                    
//                    let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//                    let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                                         kCVPixelBufferWidthKey as String: 160,
//                                         kCVPixelBufferHeightKey as String: 160,
//                                         ]
//                    settings.previewPhotoFormat = previewFormat
//                    cameraOutput?.capturePhoto(with: settings, delegate: self)
//                }
//            } else {
//                print("Issue here: captureSession.canAddInput")
//            }
//        } else{
//            print("problem")
//        }

    
    
    func performImageRecognition(image:UIImage){
        let tess = G8Tesseract(language: "eng")
        tess?.image = image
        
//        tess?.engineMode = .tesseractCubeCombined
        tess?.pageSegmentationMode = .auto
        tess?.maximumRecognitionTime = 60.0
        
        tess?.image = image.g8_blackAndWhite()
        
        tess?.recognize()

        print("Recognized text is",tess?.recognizedText)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error{
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            var image = UIImage(data: dataImage)
        
        } else{
            
        }
    }
    

}

