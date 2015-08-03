

let defaultCell = "defaultCell"

class EATableViewController: EAViewController,UITableViewDataSource,UITableViewDelegate
{
    override func loadView()
    {
        super.loadView()
        cacheViews = Dictionary<String, UIView>()
        createTableView();
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return self.createCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0;
    }
    
    func createTableView()->UITableView?
    {
        _tableView = _skinParser?.parse(EA_tableView, view: nil) as? UITableView
        self._contentLayoutView?.removeFromSuperview()
        self._contentLayoutView = _tableView;
        if(_contentLayoutView != nil)
        {
            self.view.addSubview(_contentLayoutView!);
        }
        _tableView?.delegate=self;
        _tableView?.dataSource=self;
        
        var headerView = _skinParser?.parse(EA_tableHeaderView)
        resetTableHeaderView(headerView)
        
        return _tableView;
    }
    
    func resetTableHeaderView(tableHeaderView:UIView?)
    {
        var rect = self.view.frame
        tableHeaderView?.frame = rect
        tableHeaderView?.spUpdateLayout()
        tableHeaderView?.calcWidth(nil)
        tableHeaderView?.spUpdateLayout()
        tableHeaderView?.calcHeight()
        self._tableView?.tableHeaderView = nil
        self._tableView?.tableHeaderView = tableHeaderView
    }
    
    func createCell()->UITableViewCell
    {
        return createCell(defaultCell)
    }

    func createCell(identifier:String)->UITableViewCell
    {
        return createCell(identifier, nil)
    }
    
    func createCell(identifier:String, _ created:((UITableViewCell)->Void)?)->UITableViewCell
    {
        var cell = _tableView?.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell;
        if(cell == nil)
        {
            cell = EATableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier);
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            _skinParser?.parse(identifier, view: cell);
            if created != nil
            {
                created!(cell!)
            }
        }
        return cell!;
    }
    
    lazy var cacheViews = Dictionary<String, UIView>()
    func createCacheCell(var identifier:String)->UITableViewCell
    {
        var dentifier_cache = identifier+"_cache"
        var cacheView = cacheViews[dentifier_cache] as? UITableViewCell
        
        if nil == cacheView
        {
            cacheView = _tableView?.dequeueReusableCellWithIdentifier(dentifier_cache) as? UITableViewCell
            if nil == cacheView
            {
                cacheView = EATableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: dentifier_cache)
                _skinParser?.parse(identifier, view: cacheView)
            }
            cacheView!.selectionStyle = UITableViewCellSelectionStyle.None
            cacheViews[dentifier_cache] = cacheView
        }
        return cacheView!
    }
    
    func indexPath(view:UIView?) ->NSIndexPath?
    {
        if let cell = getSuperCell(view)
        {
            return self._tableView?.indexPathForCell(cell)
        }
        return nil
    }
    
    var _tableView:UITableView?;
}
