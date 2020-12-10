//
//  MarketGalleryDataSource.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import Foundation

struct MarketGalleryDataSource{
    
    private(set) var photos: [MarketPhotoViewable] = []
    
    func photoAtIndex(_ index: Int) -> MarketPhotoViewable? {
        if (index < photos.count && index >= 0) {
            return photos[index];
        }
        return nil
    }
    
    var numberOfPhotos: Int{
        return photos.count
    }
    
    func indexOfPhoto(_ photo: MarketPhotoViewable) -> Int? {
        return photos.index(where: { $0 === photo} )
    }
    
    func contains(_ photo: MarketPhotoViewable) -> Bool{
        return indexOfPhoto(photo) != nil
    }
    
    subscript(index: Int) -> MarketPhotoViewable? {
        get {
            return photoAtIndex(index)
        }
    }
    
}
