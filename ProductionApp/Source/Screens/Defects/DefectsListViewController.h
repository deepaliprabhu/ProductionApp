//
//  DefectsListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefectsListCell.h"
#import "Job.h"
#import "BaseViewController.h"
#import "Process.h"

@interface DefectsListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_jobTypesView;
    //0:View Defect, 1:Add Defect
    int listType;
    int selectedJobType;
    NSMutableArray *defectsArray;
    
    Job *selectedJob;
    Process *process;
}
- (void)setListType:(int)type;
- (void)setSelectedJob:(Job*)job_;
- (void)setProcess:(Process*)process_;

@end
