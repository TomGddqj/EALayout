
import UIKit
import Foundation

let EA_selfView             = "selfView";
let EA_contentView          = "contentView";
let EA_contentHeaderView    = "contentHeaderView";
let EA_bottomView           = "bottomView";
let EA_titleBgView          = "titleBgView";
let EA_tableView            = "tableView";
let EA_tableHeaderView      = "tableHeaderView";
let EA_titleLeftView        = "titleLeftView";
let EA_titleMiddleView      = "titleMiddleView";
let EA_titleRightView       = "titleRightView";

enum UpdateTitleMask : Int {
    case EUpdateTitle = 1
    case EUpdateLeft = 2
    case EUpdateMiddle = 4
    case EUpdateRight = 8
    case EUpdateBg = 16
    case EUpdateAll = 31
}

class EAViewController : UIViewController
{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _skinParser = SkinParser.getParserByName(NSStringFromClass(self.classForCoder))
        _skinParser?.eventTarget = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView()
    {
        super.loadView()
        _skinParser?.parse(EA_selfView, view: self.view)
        var contentView = _skinParser?.parse(EA_contentView)
        if (contentView != nil)
        {
            self.view.addSubview(contentView!)
        }
        self._contentLayoutView = contentView
        
        var contentHeaderView = _skinParser?.parse(EA_contentHeaderView)
        if (contentHeaderView != nil)
        {
            self.view.addSubview(contentHeaderView!)
        }
        self._contentHeaderLayoutView = contentHeaderView
        
        var bottomView = _skinParser?.parse(EA_bottomView, view: nil)
        if (bottomView != nil)
        {
            self.view.addSubview(bottomView!)
        }
        self._bottomLayoutView = bottomView
        
        updateTilteView(UpdateTitleMask.EUpdateAll.rawValue)
    }
    
    override func viewDidLoad()
    {
        self.view.spUpdateLayout()
        layoutSelfView()
        self.view.spUpdateLayout()
        if nil != _titleBgView
        {
            self.view.bringSubviewToFront(_titleBgView!)
        }
    }

    #if DEBUG
    func freshSkin()
    {
        
        #if (arch(x86_64) || arch(i386))
            
            self.view = UIView()
            _skinParser = SkinParser.getParserByName( NSStringFromClass(self.classForCoder) )
            loadView()
            viewDidLoad()
            
        #else
            //真机上调试界面
        #endif

    }
    #endif
    
    func updateTilteView(var _ mask:Int=UpdateTitleMask.EUpdateTitle.rawValue)
    {
        var newTitleBgView = _titleBgView
        
        if 0 != UpdateTitleMask.EUpdateBg.rawValue & mask
        {
            newTitleBgView = createTitleBgView()
            self._topLayoutView = newTitleBgView
        }
        
        if nil == newTitleBgView
        {
            _titleBgView?.removeFromSuperview()
            _titleBgView = newTitleBgView
            return
        }
        
        if newTitleBgView != _titleBgView
        {
            if nil != _titleLeftView
            {
                newTitleBgView?.addSubview(_titleLeftView!)
            }
            
            if nil != _titleMiddleView
            {
                newTitleBgView?.addSubview(_titleMiddleView!)
            }
            
            if nil != _titleRightView
            {
                newTitleBgView?.addSubview(_titleRightView!)
            }
            _titleBgView?.removeFromSuperview()
            _titleBgView = newTitleBgView
            self.view.addSubview(newTitleBgView!)
        }
        
        if 0 != UpdateTitleMask.EUpdateLeft.rawValue & mask
        {
            _titleLeftView?.removeFromSuperview()
            _titleLeftView = createTitleLeftView()
            if nil != _titleLeftView
            {
                newTitleBgView?.addSubview(_titleLeftView!)
            }
        }
        
        if 0 != UpdateTitleMask.EUpdateRight.rawValue & mask
        {
            _titleRightView?.removeFromSuperview()
            _titleRightView = createTitleRightView()
            if nil != _titleRightView
            {
                newTitleBgView?.addSubview(_titleRightView!)
            }
        }
        
        if 0 != UpdateTitleMask.EUpdateMiddle.rawValue & mask
        {
            _titleMiddleView?.removeFromSuperview()
            _titleMiddleView = createTitleMiddleView()
            if nil != _titleMiddleView
            {
                newTitleBgView?.addSubview(_titleMiddleView!)
            }
            
            mask |= UpdateTitleMask.EUpdateTitle.rawValue
        }
        
        if 0 != UpdateTitleMask.EUpdateTitle.rawValue & mask
        {
            var textTitle = getTitle()
            if nil != textTitle
            {
                (_titleMiddleView as? UILabel)?.text =  textTitle! as String
            }
            _titleBgView?.spUpdateLayout()
        }
    }
    
    func getTitle()->NSString?
    {
        return self.title;
    }

    func createTitleBgView()->UIView?
    {
        return _skinParser?.parse(EA_titleBgView, view: nil)
    }
    
    func createTitleLeftView()->UIView?
    {
        return _skinParser?.parse(EA_titleLeftView, view: nil)
    }
    
    func createTitleMiddleView()->UIView?
    {
        return _skinParser?.parse(EA_titleMiddleView, view: nil)
    }
    
    func createTitleRightView()->UIView?
    {
        return _skinParser?.parse(EA_titleRightView, view: nil)
    }
    
    var _titleBgView : UIView?
    var _titleLeftView : UIView?
    var _titleMiddleView : UIView?
    var _titleRightView : UIView?
    
    //MARK:Layout controller views
    var _topLayoutView : UIView?
    {
        didSet
        {
            if oldValue != _topLayoutView
            {
                layoutSelfView()
            }
        }
    }
    
    var _contentHeaderLayoutView : UIView?
    {
        didSet
        {
            if oldValue != _contentHeaderLayoutView
            {
                layoutSelfView()
            }
        }
    }
    
    var _contentLayoutView : UIView?
    {
        didSet
        {
            if oldValue != _contentLayoutView
            {
                layoutSelfView()
            }
        }
    }
    
    var _bottomLayoutView : UIView?
    {
        didSet
        {
            if oldValue != _bottomLayoutView
            {
                layoutSelfView()
            }
        }
    }

    func layoutSelfView()
    {
        var bound = self.view.bounds
        var topFrame = CGRectZero
        if nil != _topLayoutView
        {
            topFrame = _topLayoutView!.frame
            topFrame.origin.y = 0
            _topLayoutView!.frame = topFrame
            var layoutDes = _topLayoutView?.createViewLayoutDesIfNil()
            layoutDes?.setTop(0, forTag: 0)
        }
        
        var contentHeaderFrame = CGRectZero
        if nil != _contentHeaderLayoutView
        {
            contentHeaderFrame = _contentHeaderLayoutView!.frame
            contentHeaderFrame.origin.y = CGRectGetMaxY(topFrame)
            var layoutDes = _contentHeaderLayoutView?.createViewLayoutDesIfNil()
            
            if 0 != (layoutDes!.styleTypeByTag(0).value & ELayoutTop.value)
            {
                contentHeaderFrame.origin.y = layoutDes!.topByTag(0)
            }
            else
            {
                layoutDes!.setTop(contentHeaderFrame.origin.y, forTag: 0)
            }
            _contentHeaderLayoutView!.frame = contentHeaderFrame
        }
        
        var bottomFrame = CGRectZero
        if nil != _bottomLayoutView
        {
            _bottomLayoutView!.calcHeight();
            bottomFrame = _bottomLayoutView!.frame
            bottomFrame.origin.y = CGRectGetHeight(bound) - CGRectGetHeight(bottomFrame)
            _bottomLayoutView!.frame = bottomFrame
            var layoutDes = _bottomLayoutView?.createViewLayoutDesIfNil()
            layoutDes?.setBottom(0, forTag: 0)
        }
        
        var contentFrame = CGRectZero
        if nil != _contentLayoutView
        {
            contentFrame = _contentLayoutView!.frame
            contentFrame.origin.y = CGRectGetMaxY(topFrame) + CGRectGetHeight(contentHeaderFrame)
            contentFrame.size.height =
                CGRectGetHeight(bound) - CGRectGetHeight(topFrame) - CGRectGetHeight(bottomFrame) - CGRectGetHeight(contentHeaderFrame)
            
            var layoutDes = _contentLayoutView?.createViewLayoutDesIfNil()
            
            if 0 != (layoutDes!.styleTypeByTag(0).value & ELayoutTop.value)
            {
                contentFrame.origin.y = layoutDes!.topByTag(0)
            }
            else
            {
                layoutDes!.setTop(contentFrame.origin.y, forTag: 0)
            }
            
            if 0 != (layoutDes!.styleTypeByTag(0).value & ELayoutBottom.value)
            {
                contentFrame.size.height = CGRectGetHeight(bound) - layoutDes!.topByTag(0) - layoutDes!.bottomByTag(0)
            }
            _contentLayoutView!.frame = contentFrame
        }
        
        for childViewControler in self.childViewControllers
        {
            if childViewControler.isKindOfClass(EAViewController)
            {
                childViewControler.layoutSelfView()
            }
        }
    }
    
    internal var _skinParser : SkinParser?
}
