//
//  StoriesList.swift
//  myscrap
//
//  Created by MyScrap on 2/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
class StoriesList{
    
    private var _id : String!
    private var _title : String!
    private var _description : String!
    private var _blogImage : String!
    private var _publishedDate : String!
    private var _createdDate : String!
    
    var id:String{ if _id == nil{ _id = "" } ; return _id }
    var title:String{ if _title == nil{ _title = "" } ; return _title }
    var description:String{ if _description == nil{ _description = "" } ; return _description }
    var blogImage:String{ if _blogImage == nil{ _blogImage = "" } ; return _blogImage }
    var publishedDate:String{ if _publishedDate == nil{ _publishedDate = "" } ; return _publishedDate }
    var createdDate:String{ if _createdDate == nil{ _createdDate = "" } ; return _createdDate }

    init(Dict:Dictionary<String,AnyObject>) {
        if let id = Dict["id"] as? String{
            self._id = id
        }
        if let title = Dict["title"] as? String{
            self._title = title
        }
        if let description = Dict["description"] as? String{
            self._description = description
        }
        if let blogImage = Dict["blogImage"] as? String{
            self._blogImage = blogImage
        }
        if let publishedDate = Dict["publishedDate"] as? String{
            self._publishedDate = publishedDate
        }
        
        if let createdDate = Dict["createdDate"] as? String{
            self._createdDate = createdDate
        }
    }
    
}
