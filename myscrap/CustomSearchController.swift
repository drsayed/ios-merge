//
//  CustomSearchController.swift
//  myscrap
//
//  Created by MyScrap on 6/25/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit


class CustomSearchController: UISearchController{
    
    var _searchBar: CustomSearchBar
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._searchBar = CustomSearchBar()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        self._searchBar = CustomSearchBar()
        super.init(searchResultsController: searchResultsController)
    }
    
    override var searchBar: UISearchBar{
        return _searchBar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class CustomSearchBar: UISearchBar{
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        //
    }
}
