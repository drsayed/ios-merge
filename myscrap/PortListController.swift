//
//  PortListController.swift
//  myscrap
//
//  Created by MyScrap on 7/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class PortListController: UIViewController{
    
    typealias handler = (MSPortList) -> ()
    
    var selection : handler
    
    private lazy var tableview : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var datasource : [MSPortList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableview)
        tableview.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismisscontroller))
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc
    private func dismisscontroller(){
        dismiss(animated: true, completion: nil)
    }
    
    init(dataSource: [MSPortList], title: String,  item: @escaping handler) {
        self.datasource = dataSource.sorted(by: {  $0.port_name.lowercased() < $1.port_name.lowercased() })
        self.selection = item
        super.init(nibName: nil, bundle: nil)
        self.title = title + " Ports"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}

extension PortListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection(datasource[indexPath.row])
        dismisscontroller()
    }
}

extension PortListController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = datasource[indexPath.row].port_name
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
}




