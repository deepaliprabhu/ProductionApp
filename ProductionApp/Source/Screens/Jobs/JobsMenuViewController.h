//
//  JobsMenuViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 26/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobMenuCell.h"
#import "BaseViewController.h"
#import "ServerManager.h"

@interface JobsMenuViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, JobMenuCellDelegate, UITextViewDelegate, ServerProtocol> {
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UIView *_newJobTypeView;
    IBOutlet UIView *_trashView;
    IBOutlet UITextView *_titleTextView;
    UIView *_backgroundDimmingView;
    NSMutableArray *jobTypeArray;
    
    BOOL multiMode;
}

@end
