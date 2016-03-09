//
//  ScrollDisplayViewController.swift
//  scrollDisplay
//
//  Created by hiersun on 16/1/3.
//  Copyright © 2016年 hiersun. All rights reserved.
//

import UIKit

protocol ScrollDisplayViewControllerDelegate: NSObjectProtocol {
    /// 用户点击某一行触发
    func scrollDisplayViewController(scrollDisplayViewController:ScrollDisplayViewController ,didSelectedIndex index:NSInteger)
    /// 实时回传当前索引值
    func scrollDisplayViewController(scrollDisplayViewController:ScrollDisplayViewController,currentIndex index:NSInteger)
}

class ScrollDisplayViewController: UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    private var controllers : [UIViewController]?
    private var pageControl = UIPageControl()
    private var timer = NSTimer()
    //MARK: - 可变参数设置
    /// 设置设置是否循环滚动，默认为YES，表示可以循环
    var canCycle = true  //已实现
    /// 设置是否定时滚动，默认为YES，表示定时滚动
    var autoCyle = true  {
        didSet{
            setAutoCycle()
        }
    }
    /// 滚动的时间,默认3秒
    var duration: NSTimeInterval = 3
    /// 是否显示 页数提示， 默认YES，显示
    var showPageControl = true {
        didSet {
            pageControl.hidden = !showPageControl
        }
    }
    /// 当前页数默认是0页
    var currentPage: NSInteger = 0 {
        didSet{
            setCurrentPage()
        }
    }
    /// 设置页数提示的垂直偏移量，正数表示向下移动
    var pageControlOffset: CGFloat = 0
    /// 设置页数的圆点正常颜色默认灰色
    var pageControlColor = UIColor.grayColor()
    /// 设置页数圆点高亮颜色默认红的......
    var pageControlHightColor = UIColor.redColor()
    
    weak var delegate:ScrollDisplayViewControllerDelegate?
    //MARK: - 构造化方法
    init(controllers:[UIViewController]){
        super.init(nibName: nil, bundle: nil)
        self.controllers = controllers
    }
    init(paths:[String]){
        super.init(nibName: nil, bundle: nil)
        let arr = NSMutableArray()
        for var i = 0; i < paths.count; i++ {
            let path = paths[i]
            let btn = UIButton(type: .Custom)
            btn.sd_setBackgroundImageWithURL(NSURL(string: path), forState: UIControlState.Normal)
            let vc = UIViewController()
            vc.view = btn
            btn.tag = 1000 + i
            btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            arr.addObject(vc)
        }
        controllers = arr.copy() as? [UIViewController]
        
    }
    init(names:[String]){
        super.init(nibName: nil, bundle: nil)
        let arr = NSMutableArray()
        for var i = 0; i < names.count; i++ {
            let name = names[i]
            let btn = UIButton(type: .Custom)
            btn.setBackgroundImage(UIImage(named: name), forState: UIControlState.Normal)
            let vc = UIViewController()
            vc.view = btn
            btn.tag = 1000 + i
            btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            arr.addObject(vc)
        }
        controllers = arr.copy() as? [UIViewController]
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnAction(sender:UIButton) {
        self.delegate?.scrollDisplayViewController(self, didSelectedIndex: sender.tag - 1000)
    }
    //MARK: - View的生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.controllers == nil || self.controllers?.count == 0 {
            return
        }
        
        self.addChildViewController(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.view.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        pageVC.setViewControllers([controllers!.first!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true , completion: nil)
        pageControl.numberOfPages = controllers!.count
        self.view.addSubview(pageControl)
        pageControl.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(-10)
        }
        pageControl.userInteractionEnabled = false
        setAutoCycle()
        setCurrentPage()
        self.pageControl.hidden = !self.showPageControl
        self.pageControl.pageIndicatorTintColor = self.pageControlColor
        self.pageControl.currentPageIndicatorTintColor = self.pageControlHightColor
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func setCurrentPage() {
        let vc = controllers![currentPage]
        pageVC.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    func setAutoCycle() {
        timer.invalidate()
        if !autoCyle {
            return
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    
    }
    func timerAction() {
        let vc = pageVC.viewControllers?.first
        let index = controllers?.indexOf(vc!)
        var nextVC:UIViewController?
        if index == (controllers?.count)! - 1 {
            if !canCycle {
                return
            }
            nextVC = (controllers?.first)!
        }else {
            nextVC = controllers![index! + 1]
        }
        pageVC.setViewControllers([nextVC!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true) { [weak self](finish) -> Void in
            self!.configPageControl()
        }
    }
    /// 操作圆点位置
    func configPageControl() {
        let index: NSInteger = controllers!.indexOf(pageVC.viewControllers!.first!)!
        pageControl.currentPage = index
    }
    //MARK: - ScrollDisplayViewControllerDelegate实现方法
    
    //MARK: - UIPageViewController
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed && finished {
            configPageControl()
            let index = controllers!.indexOf((pageViewController.viewControllers?.first)!)
            //有待添加
            if ((self.delegate?.respondsToSelector("scrollDisplayViewController:currentIndex:")) != nil) {
                self.delegate?.scrollDisplayViewController(self, currentIndex: index!)
            }
            
            
        }
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = controllers!.indexOf(viewController)
        if index == 0 {
            return canCycle ? controllers!.last : nil
        }
        return controllers![index! - 1]
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = controllers!.indexOf(viewController)
        if index == controllers!.count - 1 {
            return canCycle ? controllers!.first : nil
        }
        return controllers![index! + 1]
    }
    //MARK: - 懒加载
    /// pageVC
    lazy var pageVC: UIPageViewController = {
       let pageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
    

    

}
