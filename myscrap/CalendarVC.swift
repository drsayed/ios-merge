//
//  CalendarVC.swift
//  myscrap
//
//  Created by MS1 on 12/14/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarVC: BaseRevealVC{
    
    fileprivate var dataSource : [EventItem]?
    fileprivate var privateDates = [Date]()
    
    fileprivate var dates = [Date]()

    private func refreshCalendar(){
        guard let events = dataSource else { return }
        
        
        
        for event in events{
            if let startDate = event.startDate{
                let dateformatter = DateFormatter()
                dateformatter.timeZone = Calendar.current.timeZone
                dateformatter.locale = Calendar.current.locale
                dateformatter.dateFormat = "dd/MM/yyyy"
                if let date = dateformatter.date(from: startDate){
                    privateDates.append(date)
                }
            }
        }
        collectionView.reloadData()
        if !privateDates.isEmpty{
            calendarView.selectDates(privateDates)
            calendarView.reloadData()
        }
        
        self.dates = privateDates
    }
    
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let selectedTextColor = UIColor.white
    let textColor = UIColor.BLACK_ALPHA
    let todaysDateColor = UIColor.red
    
    fileprivate let defaultBackgroundColor = UIColor.rgbColor(red: 220, green: 220, blue: 222)
    fileprivate let selectedBackgroundColor = UIColor.gray
    
    let todaysDate = Date()
    
    private let inset: CGFloat = 8
    private let lineInset: CGFloat = 0.5
    private let monthColor : UIColor = UIColor.BLACK_ALPHA
    private let outsideMonthColor: UIColor = UIColor.white

    
    let formatter : DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.timeZone = Calendar.current.timeZone
        dateformatter.locale = Calendar.current.locale
        dateformatter.dateFormat = "yyyy MM dd"
        return dateformatter
    }()
    
    lazy var titleView: CalendarTitleView = {
        let hv = CalendarTitleView()
        hv.calendarVC = self
        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
    }()
    
    lazy var weekView: CalendarWeekView = {
        let view = CalendarWeekView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var calendarView: JTAppleCalendarView!
    
    private let eventLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        lbl.text = "Scheduled Events"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return cv
    }()
    
    private lazy var createEventBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.GREEN_PRIMARY
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "ui_event_add_m").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(CalendarVC.createEventClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    private func setupViews(){
        
        
        // MARK:- Setting up calendar view
        calendarView = JTAppleCalendarView()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.scrollDirection = .horizontal
        calendarView.minimumLineSpacing = lineInset
        calendarView.minimumInteritemSpacing = lineInset
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.showsVerticalScrollIndicator = false
        calendarView.isPagingEnabled = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = UIColor.white
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.allowsMultipleSelection = true
        
        view.addSubview(titleView)
        view.addSubview(weekView)
        view.addSubview(calendarView)
        view.addSubview(eventLbl)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(createEventBtn)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            titleView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            weekView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            weekView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: inset),
            weekView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -inset),
            weekView.heightAnchor.constraint(equalToConstant: (view.frame.width - inset - inset) / 7)
            ])
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: weekView.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: inset),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -inset),
            calendarView.heightAnchor.constraint(equalToConstant: (view.frame.width - inset - inset) * 6 / 7),
            ])
        
        NSLayoutConstraint.activate([
            eventLbl.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            eventLbl.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            ])
        
        if #available(iOS 11.0, *) {
            let safeAreInset = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: eventLbl.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: safeAreInset.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: safeAreInset.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: safeAreInset.bottomAnchor),
                ])
        } else {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: eventLbl.bottomAnchor, constant: 8),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
                ])
        }
        
        
        
        
        NSLayoutConstraint.activate([
            createEventBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            createEventBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            createEventBtn.widthAnchor.constraint(equalToConstant: 50),
            createEventBtn.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20)
            ])
        
    }
    
    private func setupCollectionView(){
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.white
        setupViews()
        setupCollectionView()
        
        calendarView.scrollToDate(todaysDate, animateScroll: false)
        calendarView.selectDates([todaysDate])
        

        calendarView.visibleDates { (dateSement) in
            self.setupCalendarView(dateSegment: dateSement)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if dataSource == nil{
            self.activityIndicator.startAnimating()
            getEvents()
        }
    }
    
    private func setupCalendarView(dateSegment: DateSegmentInfo){
        guard let date = dateSegment.monthDates.first?.date else { return }
        formatter.dateFormat = "MMMM yyyy"
        titleView.title = formatter.string(from: date)
    }
    
    func scrollCalendar(segment: SegmentDestination){
        calendarView.scrollToSegment(segment)
    }
    
    @objc private func createEventClicked(_ sender: UIButton){
        if let vc = CreateEventVC.storyBoardInstance() {
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }
    }
    
}

extension CalendarVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendarView.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
    
        cell.dateLbl.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let myCustomCell = cell as! CalendarCell
        
        // Setup Cell text
        myCustomCell.dateLbl.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2050 02 01")! // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        if dates.contains(date){
            performEventVC()
        }
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if !dates.contains(date){
            handleCellSelection(view: cell, cellState: cellState)
            handleCellTextColor(view: cell, cellState: cellState)
        } else {
            calendarView.selectDates([date])
        }
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let myCustomCell = view as? CalendarCell  else {
            return
        }
        formatter.dateFormat = "yyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString{
            myCustomCell.dateLbl.textColor = todaysDateColor
            myCustomCell.selectedView.backgroundColor = UIColor.clear
        } else {
            myCustomCell.selectedView.backgroundColor = UIColor.GREEN_PRIMARY
            if cellState.isSelected {
                myCustomCell.dateLbl.textColor = selectedTextColor
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    myCustomCell.dateLbl.textColor = textColor
                } else {
                    myCustomCell.dateLbl.textColor = UIColor.white
                }
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if privateDates.contains(date){
            return true
        }
        return false
    }
    

    
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCell  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupCalendarView(dateSegment: visibleDates)
    }
    
    
}

extension CalendarVC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       performEventVC()
    }
    
    fileprivate func performEventVC(){
        if let vc = EventVC.storyBoardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension CalendarVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.identifier, for: indexPath) as? EventCell else { return UICollectionViewCell()}
        cell.eventItem = dataSource?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}



extension CalendarVC{
    
    func getEvents(){
        EventItem.getEvents { (success, error, dataSource) in
            DispatchQueue.main.async {
                guard error == nil else { return }
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                }
                self.dataSource = dataSource
                self.refreshCalendar()
            }
        }
    }
}





