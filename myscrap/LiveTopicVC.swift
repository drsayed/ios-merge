//
//  LiveTopicVC.swift
//  myscrap
//
//  Created by Hassan Jaffri on 1/2/21.
//  Copyright © 2021 MyScrap. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
enum CameraType
{
    case Front
    case Back
}
class LiveTopicVC: UIViewController {
    
    @IBOutlet weak var topicTtitle: UILabel!
    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var topicValue: UILabel!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var cameraType  = CameraType.Front
    @IBOutlet weak var cameraToggleButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var liveLable: UILabel!
    @IBOutlet weak var livebutton: UIButton!
    @IBOutlet weak var closebutton: UIButton!
    @IBOutlet weak var announceImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        self.topicTtitle.text = "Write Topic :"
        self.topicValue.text = "Type"
        announcementView.layer.cornerRadius =  announcementView.frame.size.height/2
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnTopic(tapGestureRecognizer:)))
        announcementView.isUserInteractionEnabled = true
        announcementView.addGestureRecognizer(tapGestureRecognizer)

        let imageCam = UIImage(named: "cameraSC")?.withRenderingMode(.alwaysTemplate)
        cameraToggleButton.setImage(imageCam, for: .normal)
        cameraToggleButton.tintColor = UIColor.white
        cameraToggleButton.drawShadow()
       
       self.announceImage.image =  UIImage.fontAwesomeIcon(name: .bullhorn, style: .solid, textColor: UIColor.white , size: CGSize(width: 30, height: 30))
      
        let imageClose = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        closebutton.setImage(imageClose, for: .normal)
        closebutton.tintColor = UIColor.white
        closebutton.drawShadow()
 

        self.livebutton.applyGradient(colours: [UIColor(red: 0.11, green: 0.32, blue: 0.12, alpha: 1.00), UIColor(red: 0.25, green: 0.69, blue: 0.16, alpha: 1.00)])

        livebutton.layer.cornerRadius = livebutton.frame.size.height/2
        livebutton.clipsToBounds = true
        self.setUpCamera()
        
    }
    @objc func tappedOnTopic(tapGestureRecognizer: UITapGestureRecognizer){

        self.addTopic()

        // Your action
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
      
        // Setup your camera here...
    }
   func addTopic ()
   {
    if  let customAlert = CustomAlertView.storyBoardInstance()
  {
    customAlert.providesPresentationContextTransitionStyle = true
    customAlert.definesPresentationContext = true
        if topicValue.text != "Type"  {
        customAlert.alertTextField.text = topicValue.text
        }

    customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    customAlert.delegate = self
    self.present(customAlert, animated: true, completion: nil)
  }
//    let name = UIAlertAction(title: "Topic", style: .default) { (action) in
//        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertView") as! CustomAlertView
//        customAlert.providesPresentationContextTransitionStyle = true
//        customAlert.definesPresentationContext = true
//        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        customAlert.delegate = self
//        self.present(customAlert, animated: true, completion: nil)
//    }
   }
    func setUpCamera ()
    {

        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera , for: AVMediaType.video, position: .front)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    
    }
    func setupLivePreview() {
        let screenSize = UIScreen.main.bounds
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView.frame = screenSize

        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame = screenSize
        cameraView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        //Step12
    }
    /// Swap camera and reconfigures camera session with new input
    fileprivate func swapCamera() {

        // Get current input
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }

        // Begin new session configuration and defer commit
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        // Create new capture device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }

        // Create new capture input
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        // Swap capture device inputs
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }

    /// Create new capture device with requested position
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {

        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices

        //if let devices = devices {
            for device in devices {
                if device.position == position {
                    return device
                }
            }
        //}

        return nil
    }
    
    @IBAction func cameraTogglePressed(_ sender: Any) {
        self.swapCamera()
//        if cameraType == .Front {
//            cameraType = .Back
//            self.setUpCamera()
//        }
//        else
//        {
//            cameraType = .Front
//            self.setUpCamera()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false

        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goLiveButtonPressed(_ sender: Any) {
        if let vc = UserLiveVC.storyBoardInstance() {
            vc.topicValueText = topicValue.text!
               self.navigationController?.pushViewController(vc, animated: true)
            }
    }
}
extension LiveTopicVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> LiveTopicVC?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: LiveTopicVC.id) as? LiveTopicVC
    }
}
extension LiveTopicVC: CustomAlertViewDelegate {
    
    func okButtonTapped(selectedOption: String, textFieldValue: String) {
        print("okButtonTapped with \(selectedOption) option selected")
        print("TextField has value: \(textFieldValue)")
      
        if textFieldValue.length > 0 {
            self.topicTtitle.text = "Topic :"
            self.topicValue.text = textFieldValue
            self.topicValue.textColor = .white
        }
        else
        {
            self.topicTtitle.text = "Write topic :"
            self.topicValue.textColor = .lightGray
        }
     
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}
class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(red: 0.25, green: 0.69, blue: 0.16, alpha: 1.00), UIColor(red: 1.00, green: 0.10, blue: 0.32, alpha: 1.00)]
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
