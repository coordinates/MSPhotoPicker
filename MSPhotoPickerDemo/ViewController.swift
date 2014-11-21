//
//  ViewController.swift
//  MSPhotoPickerDemo
//
//  Created by Masayoshi Ukida on 2014/11/21.
//  Copyright (c) 2014年 Masyaoshi Ukida. All rights reserved.
//

import UIKit
import Photos
import MSPhotoPicker

class ViewController: UIViewController, MSPhotoPickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func touchUpInsideSingle() {
        let pickerController: MSPhotoPickerController = MSPhotoPickerController()
        pickerController.pickerDelegate = self;
        
        self.presentViewController(pickerController,
            animated: true, completion: nil)
        
    }
    
    // MARK: MSPhotoPickerControllerDelegate
    func photoPickerControllerDidCancel(picker: MSPhotoPickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func photoPickerControllerDidFinishPicking(picker: MSPhotoPickerController, assets: [PHAsset]) {
        println(picker);
        println(assets)
        
        picker.dismissViewControllerAnimated(true, completion: nil);
        
    }
}

