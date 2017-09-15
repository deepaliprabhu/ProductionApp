//
//  StatsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunStatsCell.h"
#import "BaseViewController.h"
#import "DragAndDropTableView.h"
#import "DZNSegmentedControl.h"
#import "MIBadgeButton.h"

@interface OpenRunsStatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet DragAndDropTableView *_tableView;
    IBOutlet UIView *_tintedView;
    IBOutlet UIView *_cellDetailView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_openProcLabel;
    IBOutlet UILabel *_closedProcLabel;
    IBOutlet UILabel *_reworkLabel;
    IBOutlet UILabel *_rejectLabel;
    IBOutlet UILabel *_defectLabel;
    IBOutlet MIBadgeButton *_taskButton;


    DZNSegmentedControl *periodControl;
    
    NSArray *runTypeFilters;
    NSMutableArray *parseRuns;
    NSMutableArray *serverRuns;
    NSMutableArray *filteredRuns;
    NSMutableArray *tasksArray;
    int destIndex;
    int srcIndex;
    BOOL multipleUpdates;
}
- (void)setParseData:(NSMutableArray*)parseRuns_;
@end
