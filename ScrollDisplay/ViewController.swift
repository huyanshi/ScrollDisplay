//
//  ViewController.swift
//  ScrollDisplay
//
//  Created by 胡琰士 on 16/3/9.
//  Copyright © 2016年 胡琰士. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ScrollDisplayViewControllerDelegate,UITableViewDelegate {

    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgNames:[String] = ["1","2","3","4"]
        let sdVC = ScrollDisplayViewController(names: imgNames)
        sdVC.delegate = self
        view.addSubview(sdVC.view)
        sdVC.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(50)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(200)
        }
        let label = UILabel()
        label.text = "  这个测试文本  "
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(11)
        label.layer.borderColor = UIColor.blackColor().CGColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 8
        view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-30)
            make.left.equalTo(50)
            make.height.equalTo(24)
        }
        /*
        let watch = imageAndText("icon-24", text: "999")
        view.addSubview(watch)
        watch.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-60)
            make.left.equalTo(50)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        */
        let imgText = UIButton(type: UIButtonType.Custom)
        imgText.backgroundColor = UIColor.redColor()
        btn.setTitle("999", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
//                imgText.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        btn.setImage(UIImage(named: "icon-24"), forState: UIControlState.Normal)
                btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
//        self.view.addSubview(btn)
//        imgText.snp_makeConstraints { (make) -> Void in
//            make.bottom.equalTo(-60)
//            make.left.equalTo(50)
//            make.size.equalTo(CGSize(width: 50, height: 20))
//        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - ScrollDisplayViewControllerDelegate
    func scrollDisplayViewController(scrollDisplayViewController: ScrollDisplayViewController, currentIndex index: NSInteger) {
        print("=====\(index)")
    }
    func scrollDisplayViewController(scrollDisplayViewController: ScrollDisplayViewController, didSelectedIndex index: NSInteger) {
        print(index)
    }
    func imageAndText(imageName:String,text:String) -> (UIButton) {
        let imgText = UIButton(type: UIButtonType.Custom)
        imgText.setTitle(text, forState: UIControlState.Normal)
        imgText.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        imgText.titleLabel?.font = UIFont.systemFontOfSize(10)
//        imgText.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        imgText.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
//        imgText.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        return imgText
    }
    
}

