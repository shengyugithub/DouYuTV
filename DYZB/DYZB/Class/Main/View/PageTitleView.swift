//
//  PageTitleView.swift
//  DYZB
//
//  Created by 盛钰 on 25/10/2017.
//  Copyright © 2017 shengyu. All rights reserved.
//

import UIKit

private let CScrollLineH : CGFloat = 2

protocol  PageTitleViewDelegate :class{
    func pageTitleViewClicked(currentIndex : Int)
}

class PageTitleView: UIView {
    
    weak var delegate: PageTitleViewDelegate?
    private var currentIndex : Int
    private var preIndex : Int
    
    private var titles : [String]
    // MARK:- 懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var scrollLine : UIView = {
       let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    // MARK:-  构造函数
    init(frame: CGRect , titles: [String]) {
        self.currentIndex = 0
        self.preIndex = 0
        self.titles = titles
        super.init(frame: frame)
        //设置ui
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

// 设置UI界面
extension PageTitleView{
    private func setupUI(){
        // 1 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
         // 2 添加title对应的label
        setupTitleLabel()
        // 3 设置底线和滚动的滑块
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLabel(){
        //0 确定label的一些frame的值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - CScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated(){
            //1 创建UILabel
            let label = UILabel()
            //2 设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            //3 设置label的frame

            let labelX : CGFloat = labelW * CGFloat(index)
            
            label.frame = CGRect.init(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
            // 4 给label添加手势
            let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(self.clickLabel(ges:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomMenuAndScrollLine(){
        // 1 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect.init(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2 添加scrollLine
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor.orange
         scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect.init(x: firstLabel.frame.origin.x, y: frame.height - CScrollLineH , width: firstLabel.frame.width, height: CScrollLineH)
        
    }
    
}
// MARK:- 监听label的点击
extension PageTitleView{
    @objc private func clickLabel(ges : UIGestureRecognizer){
        preIndex = currentIndex
        guard  let currentLabel = ges.view as? UILabel else {return}
        //改变点击label的颜色
        currentLabel.textColor = UIColor.orange
        titleLabels[preIndex].textColor = UIColor.black
        currentIndex = currentLabel.tag
        //滚动条位置发生变化
        let scrollLineX = currentLabel.frame.width * CGFloat(currentIndex)
        UIView.animate(withDuration: 0.03, animations: {
            self.scrollLine.frame.origin.x = scrollLineX
        })
        //让代理改变pagecontent内容
        self.delegate?.pageTitleViewClicked(currentIndex: currentIndex)
    }
}

// MARK:- 对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        //1 取出source 和target label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        print("progress: \(progress)")
        print("sourceIndex: \(sourceIndex)")
        print("targetIndex: \(targetIndex)")
        
        //2 处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
       
        let moveX = moveTotalX * progress
         print("title view moveTotalX \(moveX)")
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        sourceLabel.textColor = UIColor.black
        targetLabel.textColor = UIColor.orange
        
        currentIndex = targetIndex
        
        
    }
}
