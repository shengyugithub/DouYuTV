//
//  PageContentView.swift
//  DYZB
//
//  Created by 盛钰 on 30/10/2017.
//  Copyright © 2017 shengyu. All rights reserved.
//

import UIKit
let pageContentCellId : String = "pageContentCellId"

protocol PageContentViewDelegate : class{
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

class PageContentView: UIView {
    //MARK:- 定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    private var isForbidScrollDelegate : Bool = false
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = { [weak self] in
            //1 创建layout
            let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
            //2 创建UICollecionView
            let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.bounces = false
            collectionView.isPagingEnabled = true
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: pageContentCellId)
            return collectionView
        }()
    // MARK:- 自定义构造函数
    init(frame: CGRect , childVcs: [UIViewController], parentViewController: UIViewController) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
    //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


//MARK:- 设置UI界面
extension PageContentView{
    private func setupUI(){
     // 1 将所有子控制器加入到父控制器中
        for childVc in childVcs{
            parentViewController?.addChildViewController(childVc)
        }
        //2 添加uicollectionview，用于在cell中存放控制器的view
        collectionView.frame = bounds
        collectionView.backgroundColor = UIColor.purple
        self.addSubview(collectionView)
    }
}


//MARK:- 遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pageContentCellId, for: indexPath)
        //2 给cell设置内容
        
        //cell 使用很多次，加了很多subview，回收使用需要把之前的subviews清空
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK:- collectionView的cell移动到制定位置
extension PageContentView{
    func scrollCollectionViewTo(index: Int){
        //记录禁止直行代理方法
        isForbidScrollDelegate = true
        self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: false)
    }
    
}
//MARK:- 实现UIScrollViewDelegate
extension  PageContentView : UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("end dragging!")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0 判断是否点击事件
        if isForbidScrollDelegate {return}
        
        //1 progress 2 sourceIndex 3 targetIndex
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //判断左右滑动
        var  currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            // 左滑
            var ratio = currentOffsetX / scrollViewW
            progress = ratio - floor(ratio)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            //完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
        }
        
        self.delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
}


