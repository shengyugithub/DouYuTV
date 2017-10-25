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
        return titleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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
