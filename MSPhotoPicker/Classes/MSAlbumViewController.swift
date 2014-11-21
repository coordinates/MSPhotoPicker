//
//  MSAlbumViewController.swift
//  MSPhotoPickerController
//
//  Created by Masayoshi Ukida on 2014/11/18.
//  Copyright (c) 2014年 Masyaoshi Ukida. All rights reserved.
//

import UIKit
import Photos


public class MSAlbumViewController: UITableViewController {
    private var collections = [PHAssetCollection]()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    


    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch(status){
            case .Authorized:
                println("Authorized")
                // フォトアプリの中にあるアルバムを検索する.
                //            let fetchOptions = PHFetchOptions()
                //            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
                //
                //            let fetchResult = PHAsset.fetchAssetsWithOptions(fetchOptions);
                //            fetchResult.count
                //            println(fetchResult.count)
                
                if 0 == self.collections.count {
                    self.collections = self.fetchCollections()
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData();
                };

                break
                
                
            case .Denied:
                println("Denied")
                
            case .NotDetermined:
                println("NotDetermined")
                
            case .Restricted:
                println("Restricted")
            }
            
        }

    }
    
    func fetchCollections() -> [PHAssetCollection] {
        let controller = self.navigationController as MSPhotoPickerController;
        var collections = [PHAssetCollection]()
        var album: PHFetchResult;
        var subtypes = controller.collectionSubtypes
        
        // has Any
        if contains(subtypes, PHAssetCollectionSubtype.Any) {
            var album: PHFetchResult;
            
            // for PHAssetCollectionType.SmartAlbumd
            album = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum,
                subtype: PHAssetCollectionSubtype.Any,
                options: nil)
            album.enumerateObjectsUsingBlock { (collection, index, isStop) -> Void in
                collections.append(collection as PHAssetCollection)
            }
            
            // for PHAssetCollectionType.Album
            album = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album,
                subtype: PHAssetCollectionSubtype.Any,
                options: nil)
            album.enumerateObjectsUsingBlock { (collection, index, isStop) -> Void in
                collections.append(collection as PHAssetCollection)
            }
        }
        else {
            for i in 0 ..< subtypes.count {
                var type = NSNotFound;
                var subtype = subtypes[i];
                
                let osVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
                if 8.1 > osVersion {
                    switch subtype {
                    case .SmartAlbumUserLibrary, .AlbumMyPhotoStream:
                        continue
                        
                    default:
                        break
                    }
                }
                else {
                    switch subtype {
                    case .SmartAlbumGeneric, .SmartAlbumRecentlyAdded:
                        continue
                        
                    default:
                        break
                    }
                }
                
                
                switch subtype.rawValue {
                case 0 ..< PHAssetCollectionSubtype.SmartAlbumGeneric.rawValue:
                    type = PHAssetCollectionType.Album.rawValue;
                    break;
                    
                case PHAssetCollectionSubtype.SmartAlbumGeneric.rawValue ..< PHAssetCollectionSubtype.Any.rawValue:
                    type = PHAssetCollectionType.SmartAlbum.rawValue;
                    break;
                    
                default:
                    break;
                }
                
                if NSNotFound != type {
                    let collectionType = PHAssetCollectionType(rawValue: type)!;
                    let album = PHAssetCollection.fetchAssetCollectionsWithType(collectionType,
                        subtype: subtype,
                        options: nil)
                    
                    album.enumerateObjectsUsingBlock { (collection, index, isStop) -> Void in
                        collections.append(collection as PHAssetCollection)
                    }
                    
                }
            }
            
        }
        
        return collections
    }
    
    @IBAction func actionCancel(sender: AnyObject)  {
        let controller = self.navigationController as MSPhotoPickerController
        controller.pickerDelegate?.photoPickerControllerDidCancel?(controller);
    }


    // MARK: - Table view data source

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        let status = PHPhotoLibrary.authorizationStatus()
        return PHAuthorizationStatus.Authorized == status ? 1 : 0
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println(self.collections.count)
        return self.collections.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let collection = self.collections[indexPath.row];
        cell.textLabel.text = collection.localizedTitle;
        
        println(collection.localizedTitle)
        println("  ",
            collection.assetCollectionType.rawValue,
            collection.assetCollectionSubtype.rawValue,
            collection.startDate)

        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let collection = self.collections[indexPath.row];
        
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "ShowPhotoViewController" == segue.identifier {
            let indexPath = self.tableView.indexPathForSelectedRow()
            if nil != indexPath {
                let collection = self.collections[indexPath!.row]
                let viewController = segue.destinationViewController as MSPhotoViewController
                viewController.collection = collection
            }
        }
    }
}
