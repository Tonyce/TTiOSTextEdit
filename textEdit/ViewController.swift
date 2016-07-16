//
//  ViewController.swift
//  textEdit
//
//  Created by D_ttang on 15/11/30.
//  Copyright © 2015年 D_ttang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var keyboardRect = CGRectZero
    let textViewHeight: CGFloat = 300
    
    var editToolBarViewController: EditToolBarViewController!
    @IBOutlet weak var scrollContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var textView: UITextView!

    
    var document: MyDocument?
    var documentUrl: NSURL?
    let filemgr = NSFileManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        self.view.layoutIfNeeded()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        
        scrollContainer.keyboardDismissMode = .Interactive
        
        editToolBarViewController = EditToolBarViewController()
        editToolBarViewController.textViewController = self
        // addChildViewController(editToolBarViewController)
        textView.inputAccessoryView = editToolBarViewController.view

//        dirManager()
//        fileChecker()
//        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let docPath = dirPaths[0] as String

        let dirUrls = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docUrl = dirUrls[0]
        documentUrl = docUrl.URLByAppendingPathComponent("savefile.txt")
        
        document = MyDocument(fileURL: documentUrl!)
//        document?.userText = ""
        
        let dataFile = documentUrl?.path
        
        guard let dataFilePath = dataFile else {
            return
        }
        
        if filemgr.fileExistsAtPath(dataFilePath) == true {
            document?.openWithCompletionHandler({
                (success: Bool) -> Void in
                if success == true {
                    print("file open ok")
                    print( self.document?.userText )
                }else {
                    print("fail to open file")
                }
            })
        }else {
            document?.saveToURL(documentUrl!, forSaveOperation: .ForCreating, completionHandler: {
                (success: Bool) -> Void in
                if success == true {
                    print("file created ok")
                }else {
                    print("failed to create file")
                }
            })
        }
        
        document?.userText = "some text here"
        
        document?.saveToURL(documentUrl!, forSaveOperation: .ForOverwriting, completionHandler: {
            (success: Bool) -> Void in
            if success == true {
                print("file over write ok")
            }else {
                print("fole overwrite failed")
            }
        })
    }
    
    
    
    
    
    func dirManager() {
        
        var contents: [String]?
        
        let filemgr = NSFileManager.defaultManager()
        let currentPath = filemgr.currentDirectoryPath
        print("currentPath: \(currentPath)")
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print("dirPaths: \(dirPaths)")
        
        let docsDir = dirPaths[0]
        print("docsDir: \(docsDir)")
        
        var attribs: [String : AnyObject]?
        do {
            attribs = try filemgr.attributesOfItemAtPath(docsDir)
        }catch _ {
            print("docsDir contents err....")
        }
        
        print("docsDir contents: \(attribs)")
        
        let tmpDir = NSTemporaryDirectory()
        print("tmpDir: \(tmpDir)")
        
        
        if filemgr.changeCurrentDirectoryPath(docsDir) == true {
            let currentPath = filemgr.currentDirectoryPath
            print("currentPath: \(currentPath)")
        }else {
            print("change dir false")
        }
        
        let dirUrls = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let dirUrl = dirUrls[0]
        print("dirUrl: \(dirUrl)")
        
        let newDir = dirUrl.URLByAppendingPathComponent("data")
        print("newDir: \(newDir)")
        
        
        let newDirPath = newDir.path
        print("newDirPath: \(newDirPath)")
        
        
//        do {
//            try filemgr.createDirectoryAtURL(newDir, withIntermediateDirectories: true, attributes: nil)
//        }catch _ {
//            print("err: )")
//            fatalError()
//        }
        


        
        print("contents: \(contents)")
        
        
        if let path = newDirPath {
            
            do {
                try filemgr.removeItemAtPath(path)
            }catch _ {
                print("romove fail: \(path)")
            }
            
            if filemgr.changeCurrentDirectoryPath(path) == true {
                let currentPath = filemgr.currentDirectoryPath
                print("currentPath: \(currentPath)")
                print("newPath has exits...")
            }else  {
                do {
                    try filemgr.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
                }catch _ {
                    print("err")
                }
                
                if filemgr.changeCurrentDirectoryPath(path) == true {
                    let currentPath = filemgr.currentDirectoryPath
                    print("createPath: \(currentPath)")
                }
            }
            
            do {
                contents = try filemgr.contentsOfDirectoryAtPath(path)
            }catch _ {
                print("contents err")
            }
        }
        
    }
    
    func fileChecker() {
        let filemgr = NSFileManager.defaultManager()
//        if filemgr.fileExistsAtPath("/Applications") == true {
//            print("/Applications exist...")
//        }else {
//            print("/Applications not exist...")
//        }
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsPath = dirPaths[0] as NSString
        let newDirPath = docsPath.stringByAppendingPathComponent("data.txt")
        // let newDir = docsPath.stringByAppendingPathExtension("data.txt")..96DCF4B1D7BC/Documents.data.txt

        var isDirectory = ObjCBool(true)
        if filemgr.fileExistsAtPath(newDirPath, isDirectory: &isDirectory) == false {
            if isDirectory.boolValue == true {
                let dataBuffer = filemgr.contentsAtPath(newDirPath)
                if filemgr.createFileAtPath(newDirPath, contents: dataBuffer, attributes: nil) == false {
                    print("createFileAtPathFaile: \(newDirPath)")
                    return
                }
            }
        }
        
        fileHandler(newDirPath)
    }
    
    func fileHandler(filePath: String) {
        let file = NSFileHandle(forReadingAtPath: filePath)
        if file == nil {
            print("openFail...")
            return
        }
//        print("file offsetInFile: \(file?.offsetInFile)")
//        
//        file?.seekToEndOfFile()
//        print("file offsetInFile: \(file?.offsetInFile)")
//        
//        file?.seekToFileOffset(50)
//        print("file offsetInFile: \(file?.offsetInFile)")
        
        let fileDataBuffer: NSData? = file?.readDataToEndOfFile()
        guard let fileData = fileDataBuffer else {
            print("fileDataBuffer is nil")
            return
        }
        let dataStr = NSString(data: fileData, encoding: NSUTF8StringEncoding)
        print("dataStr: \(dataStr)")

        
        let writeStr = "shoule be write into data.txt"
        let data = writeStr.dataUsingEncoding(NSUTF8StringEncoding)
        guard let writeData = data else {
            print("writeData is nil")
            return
        }
        let fileWriter = NSFileHandle(forUpdatingAtPath: filePath)
        print("file offsetInFile: \(file?.offsetInFile)")
        let fileOffSetInfFile = file?.offsetInFile
        fileWriter?.seekToFileOffset(fileOffSetInfFile!)
        print("fileWriter: \(fileWriter?.offsetInFile)")
        fileWriter?.writeData(writeData)
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.frame.size.height = textViewHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
//        if textView.text == textViewPlaceHold {
//            textView.text = ""
//            textView.textColor = UIColor.blackColor()
//        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
//        if textView.text == "" {
//            textView.text = textViewPlaceHold
//            textView.textColor = UIColor.lightGrayColor()
//        }
    }
    
    func textViewDidChange(textView: UITextView) {
        print(textView.contentSize.height)
//        if textView.contentSize.height > textViewHeight {
//            textView.frame.size.height = textView.contentSize.height
//        }

    }
}

extension ViewController {
    func handleKeyboardWillShow (notification: NSNotification){
        let keyboardRectAsObject = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboardRectAsObject.getValue(&keyboardRect)
         // print(keyboardRect.size.height)
        scrollContainerBottom.constant = keyboardRect.height
//        scrollContainer.contentInset.bottom = keyboardRect.height
//        self.textViewBottom.constant = -(44 + self.keyboardRect.size.height)
//        self.toolBarBottom.constant = -(self.keyboardRect.size.height)
//        UIView.animateWithDuration(0.4) { () -> Void in
            self.view.layoutIfNeeded()
//        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification){
        keyboardRect = CGRectZero
        scrollContainerBottom.constant = keyboardRect.height
        self.view.layoutIfNeeded()
    }
}

