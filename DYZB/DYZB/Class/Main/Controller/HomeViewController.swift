//
//  HomeViewController.swift
//  DYZB
//
//  Created by 盛钰 on 20/10/2017.
//  Copyright © 2017 shengyu. All rights reserved.
//
import Foundation
import UIKit

private let CTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
    
    // MARK: - 懒加载属性
    private lazy var pageTitleView : PageTitleView = {
        let titleFrame = CGRect.init(x: 0, y: CStatusBarH + CNavigationBarH, width: CScreenW, height: CTitleViewH)
        let titles = ["推荐","手游","娱乐","游戏","趣玩"]
        let titleView = PageTitleView.init(frame: titleFrame, titles: titles)
        //titleView.backgroundColor = UIColor.purple
        titleView.delegate = self
        return titleView
    }()
    
    //MARK: - PagecontentView
    private lazy var pageContentView : PageContentView = { [weak self] in
       // 1 确定frame
       let contentH = CScreenH - CStatusBarH - CNavigationBarH - CTabBarH
       let contentFrame = CGRect.init(x: 0, y: CStatusBarH + CNavigationBarH + CTitleViewH, width: CScreenW, height: contentH)
        //2 确定子控制器
       var childs = [UIViewController]()
        for _ in 0..<5{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.init(r : CGFloat(arc4random_uniform(255)), g : CGFloat(arc4random_uniform(255)), b : CGFloat(arc4random_uniform(255)))
            childs.append(vc)
        }
        
        let contentView = PageContentView.init(frame: contentFrame, childVcs: childs, parentViewController: self!)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // pageContentView.delegate = self
        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension HomeViewController{
    private func setupUI(){
        // 1.设置导航栏
        setupNavigationBar()
        // 2. 添加titleview
        view.addSubview(pageTitleView)
        // 3 添加contentview
        view.addSubview(pageContentView)
    }
    
    private func setupNavigationBar(){
        //1.设置左侧的item
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "logo"), for: .normal)
        btn.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
        let historyItem = UIBarButtonItem.init(imageName: "viewHistoryIcon", size: CGSize.init(width: 40, height: 40))
        
         let searchItem = UIBarButtonItem.init(imageName: "search", size: CGSize.init(width: 40, height: 40))
        
         let qrcodeItem = UIBarButtonItem.init(imageName: "scanIcon", size: CGSize.init(width: 40, height: 40))
        
        let searchView = Bundle.main.loadNibNamed("searchBar", owner: self, options: nil)?.first as! UIView
        searchView.layer.cornerRadius = 10
        let searchBarItem = UIBarButtonItem.init(customView: searchView)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.rightBarButtonItems = [historyItem, searchBarItem]
    }
    
    
}

//作为PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleViewClicked(currentIndex: Int) {
        self.pageContentView.scrollCollectionViewTo(index: currentIndex)
    }
}

//作为PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        self.pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
