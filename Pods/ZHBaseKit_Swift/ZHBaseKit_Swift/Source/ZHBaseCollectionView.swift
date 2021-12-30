//
//  ZHBaseCollectionView.swift
//  ZHBaseKit_Swift
//
//  Created by pzh on 2020/7/16.
//  Copyright © 2020 pzh. All rights reserved.
//

import UIKit

open class ZHBaseCollectionView: ZHBaseCell{

   public weak var viewLayoutDelegate: ZHCollectionViewLayoutDelegate?;
    
   public init(_ frame:CGRect, _ viewLayoutDelegate:ZHCollectionViewLayoutDelegate){
        self.viewLayoutDelegate = viewLayoutDelegate;
        super.init(frame: CGRect.zero);
    }
    
   required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   public override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
   public lazy var collectionView : ZHCollectionView = {
        let collectionView = ZHCollectionView.init((self.viewLayoutDelegate != nil) ? self.viewLayoutDelegate!:self);
        self.addSubview(collectionView);
        return collectionView;
    }()
    
   open override func onLoad(){
        super.onLoad();
        self.enabled = false;
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self);
        }
    }

    open override func dataDidChange() {
       
        if self.data == nil {return;}
        
        let model = self.data as! ZHBaseCollectionViewModel;
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            if flowLayout.scrollDirection != model.scrollDirection {
               flowLayout.scrollDirection = model.scrollDirection;
            }
        }
        
        self.collectionView.showsVerticalScrollIndicator = model.showsVerticalScrollIndicator;
        self.collectionView.showsHorizontalScrollIndicator = model.showsHorizontalScrollIndicator;
        self.collectionView.isPagingEnabled = model.pagingEnabled;
        self.collectionView.isScrollEnabled = model.scrollEnabled;
        self.collectionView.sectionsArray   = model.sectionsArray;
        self.collectionView.reloadData();
       
    }
    
    open func reloadData(){
        self.collectionView.reloadData();
    }
}
