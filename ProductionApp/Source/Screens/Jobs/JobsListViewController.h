//
//  JobsListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGridMenuController.h"
#import "Run.h"
#import "CZPicker.h"
#import "ActionPickerView.h"
#import "SBFlatDatePicker.h"
#import "JobListCell.h"
#import "BaseViewController.h"
#import "M13Checkbox.h"
#import "JCDemo1.h"


@interface JobsListViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, JCGridMenuControllerDelegate, ActionPickerDelegate, SBFLatDatePickerDelegate, JobListCellDelegate,SearchProtocol> {
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UIButton *_selectButton;
    IBOutlet UIView *_selectedJobBarView;
    IBOutlet UIView *_actionButton;
    IBOutlet UIView *_menuView;
    
    NSArray *jobIdArray;
    NSMutableArray *filteredJobArray;
    NSMutableArray *jobActions;
    NSMutableArray *statusActions;
    NSMutableArray *jobTypeActions;
    Run *run;
    BOOL multiMode;
    BOOL selectedAll;
    BOOL filtered;
    int selectedJobType;
    M13Checkbox *modeCheckbox;
}
@property (nonatomic, strong) JCGridMenuController *gmDemo;
- (void)setRun:(Run*)run_;
- (void)setJobType:(int)jobType;
- (void)setJobTypeArray:(NSMutableArray*)jobTypeArray_;

@end
