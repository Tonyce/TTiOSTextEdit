//
//  MyDocument.swift
//  textEdit
//
//  Created by D_ttang on 15/12/7.
//  Copyright © 2015年 D_ttang. All rights reserved.
//

import UIKit

//enum MyError: ErrorType {
//    case nil
//}

class MyDocument: UIDocument {

    var userText: String?
    
//    override init(fileURL url: NSURL) {
//        super.init(fileURL: url)
//    }
    
    override func contentsForType(typeName: String) throws -> AnyObject {
        if let content = userText {
            let length = content.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            return NSData(bytes: content, length: length)
        }else {
            return NSData()
        }
    }
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        if let userContent = contents as? NSData {
            userText = NSString(bytes: contents.bytes, length: userContent.length, encoding: NSUTF8StringEncoding) as? String
        }
    }
}
