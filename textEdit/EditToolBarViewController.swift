//
//  EditToolBarViewController.swift
//  textEdit
//
//  Created by D_ttang on 15/11/30.
//  Copyright © 2015年 D_ttang. All rights reserved.
//

import UIKit

class EditToolBarViewController: UIViewController {

    
    var textViewController: ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func loadView() {
        NSBundle.mainBundle().loadNibNamed("EditToolBarViewController", owner: self, options: nil)
    }

    @IBAction func insertText(sender: AnyObject) {
        let replace = "*"
        textViewController.textView.replaceRange(textViewController.textView.selectedTextRange!, withText: replace)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
