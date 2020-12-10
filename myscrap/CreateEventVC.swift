//
//  CreateEventVC.swift
//  myscrap
//
//  Created by MS1 on 1/8/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlacesSearchController

class CreateEventVC: UIViewController,KeyboardAvoidable {
    
    enum EventType: String{
        case publicEvent = "Public Event"
        case privateEvent = "Private Event"
        
         static func Events() -> [String]{
            return [EventType.privateEvent.rawValue, EventType.publicEvent.rawValue]
        }
    }
    
    var eventType:EventType? {
        didSet{
            title = eventType?.rawValue
        }
    }
    let items = EventType.Events()
    
    
    var layoutConstraintsToAdjust: [NSLayoutConstraint] = []
    
    var searchController: UISearchController!
    
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var detailImagView: UIImageView!
  
    
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var imageView: AddPhotoImageView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    var keyboardHeight: CGFloat!
    var lastOffset: CGPoint!
    // Storing Variables
    

    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter
    }()
    
    private let timeFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh : mm a"
        return formatter
    }()

    
    
    fileprivate var eventName = ""
    fileprivate var startDate : String? {
        didSet{
            startDateTextField.text = startDate
        }
    }
    fileprivate var startTime: String? {
        didSet {
            startTimeTextField.text = startTime
        }
    }

    fileprivate var endDate: String? {
        didSet{
            endDateTextField.text = endDate
        }
    }
    
    fileprivate var endTime : String? {
        didSet {
            endTimeTextField.text = endTime
        }
    }
    
    fileprivate var location: String? {
        didSet {
            locationTextField.text = location
        }
    }
    fileprivate var details = ""
    fileprivate var mentionFriends = false
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        setupCloseBtn()
        updateTime()
        setupViews()
        setupImageViews()
        setupTextFields()
      
        textView.delegate = self
        
        layoutConstraintsToAdjust.append(constraintContentHeight)
        addKeyboardObservers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        textView.autocorrectionType = .no
        eventType = .privateEvent
    }
    

    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
    
    
    func addKeyboardObservers(customBlock: ((CGFloat) -> Void)?) {
        // do custom things
    }
    
    private func setupTextFields(){
        startDateTextField.delegate = self
        startTimeTextField.delegate = self
        endDateTextField.delegate = self
        endTimeTextField.delegate = self
        locationTextField.delegate = self
    }
    private func updateTime(){
        startDate = dateFormatter.string(from: Date())
        startTime = timeFormatter.string(from: Date())
    }
    
    private func setupImageViews(){
        dateImageView.image = #imageLiteral(resourceName: "ic_access_time_black_48dp").withRenderingMode(.alwaysTemplate)
        dateImageView.tintColor = UIColor.lightGray
        
        locationImageView.image = #imageLiteral(resourceName: "ic_location_on_48pt").withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor.lightGray
        
        detailImagView.image = #imageLiteral(resourceName: "ic_create_48pt").withRenderingMode(.alwaysTemplate)
        detailImagView.tintColor = UIColor.lightGray
    
    }
    
    
    private func setupViews(){
        imageView.mYDelegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func setupCloseBtn(){
            let closeBtn = UIButton()
            closeBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            closeBtn.tintColor = UIColor.white
            closeBtn.addTarget(self, action: #selector(CreateEventVC.closePressed), for: .touchUpInside)
            closeBtn.setImage(#imageLiteral(resourceName: "libraryCancel").withRenderingMode(.alwaysTemplate), for: .normal)
            let item = UIBarButtonItem(customView: closeBtn)
            self.navigationItem.setLeftBarButtonItems([item], animated: true)
    }
    
    @IBAction func createEventPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Select Event Type", message: nil, preferredStyle: .actionSheet)
        let privateEvent = UIAlertAction(title: EventType.privateEvent.rawValue, style: .default) { [weak self]  alert in
            self?.eventType = .privateEvent
        }
        let publicEvent = UIAlertAction(title: EventType.publicEvent.rawValue, style: .default) { [weak self]  alert in
            self?.eventType = .publicEvent
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(privateEvent)
        alert.addAction(publicEvent)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func closePressed(){
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction private func createEventBtnPressed(){
        var content = ""
        if validate(textView: textView){
            content = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        guard let _ = imageView.image else {
            print("No Image")
            presentAlert()
            return
        }
        
        var feedImage = ""
        let imageData: Data = imageView!.image!.jpegData(compressionQuality: 0.6)!
            let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
            feedImage = imageString

        
        guard let eventTitle = titleTextField.text , eventTitle != "", let startDate = startDate, startDate != "", let endDate = endDate, endDate != "",let startTime = startTime, startTime != "",let endTime = endTime, endTime != "" , let location = location , location != "", content != "" else {
            presentAlert()
            return
        }
        
        
        if let window = UIApplication.shared.keyWindow {
            
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            
            
            let av = UIActivityIndicatorView(style: .whiteLarge)
            av.center = overlay.center
            av.startAnimating()
            overlay.addSubview(av)
            
            var type = "0"
            if let event = eventType , event == .publicEvent { type = "1"}
            
            EventItem.insertEvent(startTime: startTime, endTime: endTime, eventName: eventTitle, eventPicture: feedImage, startDate: startDate, enddate: endDate, location: location, details: content, eventId: "",eventType:type) { (success) in
                DispatchQueue.main.async {
                    av.stopAnimating()
                    overlay.removeFromSuperview()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                return false
        }
        return true
    }
    
    func presentAlert(){
        let alert = UIAlertController(title: "Please Fill all details", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
  
    
    
    private func setDateToButton( startDate: Date, maximumDate: Date?, isStartDateButton: Bool){
        let datePicker = DatePickerDialog(textColor: UIColor.black, buttonColor: UIColor.GREEN_PRIMARY, font: UIFont.boldSystemFont(ofSize: 17), showCancelButton: true)
        datePicker.show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date) { [weak self] (date) in
            if let dt = date {
                if isStartDateButton {
                    self?.startDate = self?.dateFormatter.string(from: dt)
                } else {
                    self?.endDate = self?.dateFormatter.string(from: dt)
                }
            }
        }
    }
    
    
    private func setTimeToButton(isStartTimeButton: Bool){
        let datePicker = DatePickerDialog(textColor: UIColor.black, buttonColor: UIColor.GREEN_PRIMARY, font: UIFont.boldSystemFont(ofSize: 17), showCancelButton: true)
        datePicker.show("SelectTime", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .time) { [weak self] (date) in
            guard let dt = date else { return }
            if isStartTimeButton{
                self?.startTime = self?.timeFormatter.string(from: dt)
            } else {
                self?.endTime = self?.timeFormatter.string(from: dt)
            }
        }
    }
    
    
    
    static func storyBoardInstance() -> CreateEventVC? {
        let st = UIStoryboard.calendar
        return st.instantiateViewController(withIdentifier: CreateEventVC.id) as? CreateEventVC
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

extension CreateEventVC : AddPhotoImageViewDelegate{
    func didTappedImageView() {
            let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 300, height: 150))
            let cameraVC = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] (image, asset) in
                self?.imageView.image = image
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraVC, animated: true, completion: nil)
    }
}


extension CreateEventVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        // Start Date Tapped
        case startDateTextField:
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.month = +36
            guard let maximumDateString = endDate, let maxDate = dateFormatter.date(from: maximumDateString) else {
                setDateToButton(startDate: currentDate, maximumDate: currentDate, isStartDateButton: true)
                return false
            }
            setDateToButton(startDate: currentDate, maximumDate: maxDate, isStartDateButton: true)
            return false
            // Start Time
        case startTimeTextField:
            setTimeToButton(isStartTimeButton: true)
            return false
        case endDateTextField:
            guard let startDateString = startDate, let startDate = dateFormatter.date(from: startDateString) else { return false }
            var dateComponents = DateComponents()
            dateComponents.month = +36
            let maximumDate = Calendar.current.date(byAdding: dateComponents, to: startDate)
            setDateToButton(startDate: startDate, maximumDate: maximumDate, isStartDateButton: false)
            return false
        case endTimeTextField:
            setTimeToButton(isStartTimeButton: false)
            return false
        case locationTextField:
            //show Location View Controller
            textView.resignFirstResponder()
            presentGoogleController()
            return false
        default:
            return true
        }
    }
    
    
    
    
    private func presentGoogleController(){
        let controller = GooglePlacesSearchController(
            apiKey: "AIzaSyBE0S9Fu1p7jaPE9Imp8jKod0OAqYlqLfQ",
            placeType: PlaceType.cities
        )
        controller.searchBar.placeholder = "Search"
        controller.searchBar.tintColor = UIColor.white
        controller.searchBar.barTintColor = UIColor.GREEN_PRIMARY
        controller.didSelectGooglePlace { (place) in
            self.location = place.name
            controller.isActive = false
        }
        present(controller, animated: true, completion: nil)
    }
    
    
}


extension CreateEventVC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        lastOffset = self.scrollView.contentOffset
        return true
    }
}


func statusBarHeight() -> CGFloat {
    let statusBarSize = UIApplication.shared.statusBarFrame.size
    return min(statusBarSize.width, statusBarSize.height)
}







class PlacesSearchController: UITableViewController{
    
    typealias placeSelection = () -> ()
    
    var onSelectPlace : placeSelection?
    
    convenience init(_ place : @escaping placeSelection){
        self.init()
        onSelectPlace = place
    }
}









