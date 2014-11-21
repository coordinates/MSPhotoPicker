//
//  MSPhotoCollectionViewController.swift
//  MSPhotoPickerController
//
//  Created by Masayoshi Ukida on 2014/11/18.
//  Copyright (c) 2014年 Masyaoshi Ukida. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "MSPhotoCollectionCell"

class MSPhotoViewController: UICollectionViewController {
    @IBOutlet var flowLayout: UICollectionViewFlowLayout?
    var collection: PHAssetCollection? {
        didSet {
            // title
            self.navigationItem.title = self.collection?.localizedTitle
            
            // fetchResult
            self.fetchResult = PHAsset.fetchAssetsInAssetCollection(self.collection,
                options: nil);
            
        }
        
    }
    var fetchResult: PHFetchResult?
    
    private var numberOfSelectable: Int {
        get {
            let controller = self.navigationController as MSPhotoPickerController
            return controller.numberOfSelectable
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation
        if(1 >= self.numberOfSelectable) {
            self.navigationItem.rightBarButtonItem = nil;
            self.collectionView.allowsMultipleSelection = false;
        }
        else {
            self.collectionView.allowsMultipleSelection = true;
        }

        // collectionViewLayout
        self.adjustFlowLayoutToSize(self.view.frame.size)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -
    func adjustFlowLayoutToSize(size: CGSize) {
        var numberOfCol: CGFloat = 4.0
        var width = size.width
        
        do {
            width = floor((size.width - (self.flowLayout!.minimumInteritemSpacing * (numberOfCol-1))) / numberOfCol++);
        } while 120.0 < width
        
        println(width)
        
        self.flowLayout?.itemSize = CGSize(width: width, height: width);

    }
    
    // MARK: - action
    @IBAction func actionDone(sender: AnyObject) {
        let indexPaths = collectionView.indexPathsForSelectedItems()
        
        if 0 < indexPaths?.count {
            // call photo picker delegate
            var assets = [PHAsset]()
            
            for object in indexPaths! {
                let indexPath = object as NSIndexPath
                let asset = self.fetchResult?.objectAtIndex(indexPath.row) as PHAsset
                assets.append(asset)
            }
            
            let pickreController = self.navigationController as MSPhotoPickerController
            pickreController.pickerDelegate?.photoPickerControllerDidFinishPicking?(pickreController,
                assets: assets);
        }
    }
    
    // MARK: - UIContentContainer
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            self.adjustFlowLayoutToSize(size);
    }


    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if nil == self.fetchResult {
            return 0
        }
        
        return self.fetchResult!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as MSPhotoCollectionCell
    
        // Configure the cell
//        let asset = PHAsset.fetchAssetsInAssetCollection(self.collection,
//            options: nil);
        let asset = self.fetchResult?.objectAtIndex(indexPath.row) as PHAsset
        
        PHImageManager.defaultManager().requestImageForAsset(asset,
            targetSize: CGSizeMake(100.0, 100.0),
            contentMode: PHImageContentMode.AspectFill,
            options: nil) { (result, _) in
                cell.imageView!.image = result;
        }
        
    
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let indexPaths = collectionView.indexPathsForSelectedItems()
        if self.numberOfSelectable <= indexPaths?.count {
            return false
        }
        
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(1 >= self.numberOfSelectable) {
            println(indexPath)
            // call photo picker delegate
            var assets:[PHAsset] = [self.fetchResult?.objectAtIndex(indexPath.row) as PHAsset]
            let pickreController = self.navigationController as MSPhotoPickerController
            pickreController.pickerDelegate?.photoPickerControllerDidFinishPicking?(pickreController,
                assets: assets);

        }
        else {
            let indexPaths = collectionView.indexPathsForSelectedItems()
            println(indexPaths)
        }
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
