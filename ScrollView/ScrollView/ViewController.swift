//
//  ViewController.swift
//  ScrollView
//
//  Created by zhongyi on 2017/8/30.
//  Copyright © 2017年 zhongyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var adPageScrollView: PageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScrollHeadView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addScrollHeadView(){
        
        let imageArray: [String?] = ["1","2","3"]  // you can set image url, then modify the function setScrollViewOfImage
        
        let textArray : [String?] = ["Title Text 1","Title Text 2","Title Text 3"]
        let nameArray : [String?] = ["Detail text one","Detail text two","Detail text three"]
        
        self.adPageScrollView = PageScrollView(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.width*3/5 + 40 ), imageArray: imageArray, textArray: textArray, nameArray: nameArray)
        self.adPageScrollView.delegate = self
        
        self.view.addSubview(self.adPageScrollView)
    }


}


extension ViewController:PageScrollViewDegetage{
    
    func clickCurrentImage(_ currentIndxe: Int) {
        
        print(currentIndxe, " click");
        
    }
}
