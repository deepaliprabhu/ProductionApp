//
//  BatchesViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 01/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatchViewCell.h"

@interface BatchesViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UICollectionView *_collectionView;

}

@end
