//
//  PageScrollView.swift
//  LZDConsultant
//
//  Created by zhong on 7/28/16.
//  Copyright © 2016 zhong. All rights reserved.
//

import Foundation
import UIKit


let TimeInterval = 2.5          //全局的时间间隔

class PageScrollView: UIView {

    var textViewHeight : CGFloat = 40
    
    fileprivate var timer:              Timer?                //计时器
    
    fileprivate var scrollView:         UIScrollView!
    fileprivate var pageControl:        UIPageControl!
    
    fileprivate var currentImageView:   UIImageView!
    fileprivate var lastImageView:      UIImageView!
    fileprivate var nextImageView:      UIImageView!
    
    fileprivate var currentLabel:       UILabel!
    fileprivate var lastLabel:          UILabel!
    fileprivate var nextLabel:          UILabel!

    fileprivate var currentNameLabel:       UILabel!
    fileprivate var lastNameLabel:          UILabel!
    fileprivate var nextNameLabel:          UILabel!
    
    //var textArray : [String?] = []
    
    var textArray : [String?]!{
        
        willSet(newValue){
            self.textArray = newValue
        }
    }
    
    
    var nameArray : [String?]!{
        
        willSet(newValue){
            self.nameArray = newValue
        }
    }
    
    var imageArray: [String?]!{
        
        willSet(newValue){
            self.imageArray = newValue
        }
        
        didSet {
            scrollView.isScrollEnabled = !(imageArray!.count == 1)
            self.pageControl?.numberOfPages = self.imageArray.count
            self.pageControl.frame = CGRect(x: self.frame.size.width - 20 * CGFloat(imageArray.count), y: self.frame.size.height - textViewHeight - 30, width: 20 * CGFloat(imageArray.count), height: 20)
            self.setScrollViewOfImage()
        }
    }
    
    var urlImageArray: [String]?{
        willSet(newValue){
            self.urlImageArray = newValue
        }
        didSet {
            for  urlStr in self.urlImageArray!{
                imageArray.append(urlStr)
            }
        }
    }
    
    var delegate: PageScrollViewDegetage?
    
    var indexOfCurrentImage: Int!{
        didSet{
            self.pageControl.currentPage = indexOfCurrentImage
        }
    }
    
    
    //MARK:- Begin
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, imageArray: [String?]? , textArray:[String?]? , nameArray:[String?]? ) {
        self.init(frame: frame)
        self.imageArray = imageArray
        self.textArray = textArray
        self.nameArray = nameArray
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    func initPageScrollView(_ imageArray: [String?]?) {
        self.imageArray = imageArray
        
        self.indexOfCurrentImage = 0
    }

    func pageScrollViewInit(_ imageArray: [String?]?){
        
        self.setUpCircleView()
        self.imageArray = imageArray
        self.indexOfCurrentImage = 0

    }
    
    fileprivate func setUpCircleView() {
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        print(self.scrollView.frame)
        
        scrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: 0)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = !(imageArray.count == 1)
        self.addSubview(self.scrollView)
        
        self.currentImageView = UIImageView()
        currentImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.width*3/5 )
        currentImageView.isUserInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.scaleToFill
        currentImageView.clipsToBounds = true
        scrollView.addSubview(currentImageView)
    
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(PageScrollView.imageTapAction(_:)))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.lastImageView = UIImageView()
        lastImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width*3/5)
        lastImageView.contentMode = UIViewContentMode.scaleToFill
        lastImageView.clipsToBounds = true
        scrollView.addSubview(lastImageView)
        
        self.nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: self.frame.size.width, height: self.frame.size.width*3/5)
        nextImageView.contentMode = UIViewContentMode.scaleToFill
        nextImageView.clipsToBounds = true
        scrollView.addSubview(nextImageView)
        
        // LABEL  40
        let font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        lastLabel = UILabel.init(frame: CGRect(x: 10, y: self.frame.size.width*3/5 + 3, width: self.frame.size.width - 20, height: textViewHeight/2))
        lastLabel.textColor = UIColor.darkGray
        lastLabel.font = font
        scrollView.addSubview(lastLabel)
        
        currentLabel = UILabel.init(frame: CGRect(x: self.frame.size.width + 10, y: self.frame.size.width*3/5 + 3, width: self.frame.size.width - 20, height: textViewHeight/2))
        currentLabel.textColor = UIColor.darkGray
        currentLabel.font = font
        scrollView.addSubview(currentLabel)
        
        nextLabel = UILabel.init(frame: CGRect(x: self.frame.size.width * 2 + 10, y: self.frame.size.width*3/5 + 3, width: self.frame.size.width - 20, height: textViewHeight/2))
        nextLabel.textColor = UIColor.darkGray
        nextLabel.font = font
        scrollView.addSubview(nextLabel)
        
        // LABEL2
        let font2 = UIFont.init(name: "PingFangSC-Regular", size: 12)
        lastNameLabel = UILabel.init(frame: CGRect(x: 10, y: self.frame.size.width*3/5 + 20, width: self.frame.size.width - 20, height: textViewHeight/2))
        lastNameLabel.textColor = UIColor.darkGray
        lastNameLabel.font = font2
        scrollView.addSubview(lastNameLabel)
        
        currentNameLabel = UILabel.init(frame: CGRect(x: self.frame.size.width + 10, y: self.frame.size.width*3/5 + 20, width: self.frame.size.width - 20, height: textViewHeight/2))
        currentNameLabel.textColor = UIColor.darkGray
        currentNameLabel.font = font2
        scrollView.addSubview(currentNameLabel)
        
        nextNameLabel = UILabel.init(frame: CGRect(x: self.frame.size.width * 2 + 10, y: self.frame.size.width*3/5 + 20, width: self.frame.size.width - 20, height: textViewHeight/2))
        nextNameLabel.textColor = UIColor.darkGray
        nextNameLabel.font = font2
        scrollView.addSubview(nextNameLabel)
        
        
        self.setScrollViewOfImage()
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //设置分页指示器
        self.pageControl = UIPageControl(frame: CGRect(x: self.frame.size.width - 20 * CGFloat(imageArray.count), y: self.frame.size.height - textViewHeight - 30, width: 20 * CGFloat(imageArray.count), height: 20))
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = imageArray.count
        pageControl.backgroundColor = UIColor.clear
        self.addSubview(pageControl)
        
        //设置计时器
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(PageScrollView.timerAction), userInfo: nil, repeats: true)
    }
    
    //MARK: 设置图片
    fileprivate func setScrollViewOfImage(){
        
        var imageName : String;
        
        imageName = self.imageArray[self.indexOfCurrentImage]! as String
        self.currentImageView.image = UIImage.init(named: imageName)
        
        imageName = self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]! as String
        self.nextImageView.image = UIImage.init(named: imageName)
        
        imageName = self.imageArray[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]! as String
        self.lastImageView.image = UIImage.init(named: imageName)
        
        
        // if use network image, use you image load way
        
        //var urlString:String;
        //urlString = self.imageArray[self.indexOfCurrentImage]! as String
        //self.currentImageView.sd_setImage(with: URL(string: String.checkImageUrl(imageUrl: urlString) ) , placeholderImage: UIImage.init(named:""))
            
        //urlString = self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]! as String
        //self.nextImageView.sd_setImage(with: URL(string: String.checkImageUrl(imageUrl: urlString)) , placeholderImage: UIImage.init(named:""))
        
        //urlString = self.imageArray[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]! as String
        //self.lastImageView.sd_setImage(with: URL(string: String.checkImageUrl(imageUrl: urlString)) , placeholderImage: UIImage.init(named:""))
        
        setScrollViewOfLabel()
    }
    
    
    //MARK: 设置
    fileprivate func setScrollViewOfLabel(){
        
        var urlString : String?;
        
        urlString = self.textArray?[self.indexOfCurrentImage]
        currentLabel.text = urlString

        urlString = self.textArray?[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
        nextLabel.text = urlString
        
        urlString = self.textArray?[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
        lastLabel.text = urlString
        
        var nameString : String?;
        
        nameString = self.nameArray?[self.indexOfCurrentImage]
        currentNameLabel.text = nameString
        
        nameString = self.nameArray?[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
        nextNameLabel.text = nameString
        
        nameString = self.nameArray?[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
        lastNameLabel.text = nameString
    }
    
    // 得到上一张图片的下标
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.imageArray.count - 1
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    fileprivate func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.imageArray.count ? tempIndex : 0
    }
    
    //事件触发方法
    func timerAction() {
        //print("timer", terminator: "")
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
    }
    
    //MARK:- Public Methods
    func imageTapAction(_ tap: UITapGestureRecognizer){
        self.delegate?.clickCurrentImage!(indexOfCurrentImage)
    }
    
}


extension PageScrollView:UIScrollViewDelegate{

    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        let duration : Double = Double(500) / Double(1000)
        UIView.animate(withDuration: duration, animations: { () -> Void in
   
        })
        
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.5)
//        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: true)
//        UIView.commitAnimations()
        
        //重置计时器
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(PageScrollView.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //print("animator", terminator: "")
        self.scrollViewDidEndDecelerating(scrollView)
    }

}


//  MARK: Protocol

@objc protocol PageScrollViewDegetage{
    @objc optional func clickCurrentImage(_ currentIndex: Int)
}
