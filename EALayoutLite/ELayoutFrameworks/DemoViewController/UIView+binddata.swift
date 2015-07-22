

import Foundation
/********************** 绑定基本数据到对象 *********************************/

//MARK: 绑定view最常用数据 UIView(bindData)

struct BD_Url {
    init(_ url:String?) {
        value = url
    }
    var value : String?
}

extension UIView {

    func bindData(data:Any?) {
        switch (self) {
        case is UILabel:
            self.bindForUILabel(data)
            
        case is UIImageView:
            self.bindForUIImageView(data)
            
        case is UIButton:
            bindForUIButton(data)
       /*
        case is EAButton:
            bindForEAButton(data)
            
        case is TQRichTextView:
            bindForTQRichTextView(data)
*/
            
        default:
            break;
        }
    }
    
    func bindForUILabel(var data:Any?) {
        data = data ?? ""
        if let str = data as? NSString {
            (self as! UILabel).text = str as String
        }
    }
    
    func bindForUIImageView(var data:Any?) {
        if nil == data || data is UIImage {
            (self as! UIImageView).image = data as? UIImage
        }
//        else if let url = data as? NSString {
//            (self as! UIImageView).setUrl(url)
//        }
    }
    
    func bindForUIButton(var data:Any?) {
        if let str = data as? String {
            (self as! UIButton).setTitle(str, forState: UIControlState.Normal)
        } else if nil == data || data is UIImage {
            (self as! UIButton).setImage(data as? UIImage, forState: UIControlState.Normal)
        }
    }
    
//    func bindForEAButton(var data:Any?) {
//        if let str = data as? NSString {
//            (self as! EAButton).text = str.stringValue
//        } else if let url = data as? BD_Url {
//            (self as! EAButton).setUrl(url.value)
//        } else if data is UIImage {
//            (self as! EAButton).image = data as? UIImage
//        }
//    }
//    
//    func bindForTQRichTextView(var data:Any?) {
//        data = data ?? ""
//        if let str = data as? NSString {
//            (self as! TQRichTextView).text = str.stringValue
//        }
//    }
    
    func bindByTag(tag:NSInteger, data:Any?)->UIView? {
        var subView = viewWithTag(tag)
        subView?.bindData(data)
        return subView;
    }
    
    func bindByTag(tag:String, data:Any?)->UIView? {
        var subView = viewWithStrTag(tag)
        subView?.bindData(data)
        return subView;
    }
    
    //设置圆角
    func setCorners(corner:Float,byRoundingCorners:UIRectCorner)
    {
        var maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: byRoundingCorners, cornerRadii: CGSizeMake(CGFloat(corner), CGFloat(corner)))
        var maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
    
    //清除
    func removeAllSubviews()
    {
        for subview in self.subviews
        {
            subview.removeFromSuperview()
        }
    }
    
}

func createBlurView(frame:CGRect) -> UIView?
{
    if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0
    {
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView = UIVisualEffectView(effect: blur)
        effectView.frame = frame
        return effectView
    }
    return nil
}



