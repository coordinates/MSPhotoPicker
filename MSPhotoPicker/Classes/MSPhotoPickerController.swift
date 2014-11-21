//
//  MSPhotoPickerController.swift
//  MSPhotoPickerController
//
//  Created by Masayoshi Ukida on 2014/11/18.
//  Copyright (c) 2014年 Masyaoshi Ukida. All rights reserved.
//

import Foundation
import UIKit
import Photos

public class MSPhotoPickerController: UINavigationController {
    public weak var pickerDelegate: MSPhotoPickerControllerDelegate?
    public var collectionSubtypes: [PHAssetCollectionSubtype] = [ // enable subtypes
        PHAssetCollectionSubtype.SmartAlbumUserLibrary, // for 8.1 later
        PHAssetCollectionSubtype.AlbumMyPhotoStream, // fot 8.1 later
        PHAssetCollectionSubtype.SmartAlbumRecentlyAdded, // for 8.0
        PHAssetCollectionSubtype.SmartAlbumGeneric, // for 8.0
        PHAssetCollectionSubtype.SmartAlbumFavorites,
        PHAssetCollectionSubtype.SmartAlbumPanoramas,
//        PHAssetCollectionSubtype.SmartAlbumVideos,
//        PHAssetCollectionSubtype.SmartAlbumSlomoVideos,
//        PHAssetCollectionSubtype.SmartAlbumTimelapses,
//        PHAssetCollectionSubtype.SmartAlbumBursts,
//        PHAssetCollectionSubtype.SmartAlbumAllHidden,
        PHAssetCollectionSubtype.AlbumRegular,
        PHAssetCollectionSubtype.AlbumSyncedAlbum,
        PHAssetCollectionSubtype.AlbumSyncedEvent,
        PHAssetCollectionSubtype.AlbumSyncedFaces,
        PHAssetCollectionSubtype.AlbumImported,
        PHAssetCollectionSubtype.AlbumCloudShared,
    ]
    public var numberOfSelectable = 10;
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init() {
        let bundle = NSBundle(identifier: "jp.coordinates.MSPhotoPicker")
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        super.init(rootViewController: storyboard.instantiateInitialViewController() as UIViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

@objc public protocol MSPhotoPickerControllerDelegate : NSObjectProtocol {
    optional func photoPickerControllerDidCancel(picker: MSPhotoPickerController)
    optional func photoPickerControllerDidFinishPicking(picker: MSPhotoPickerController, assets: [PHAsset]!)
}