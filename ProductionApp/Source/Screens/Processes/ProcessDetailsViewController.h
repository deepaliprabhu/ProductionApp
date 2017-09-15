//
//  ProcessDetailsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 10/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
#import "Process.h"
#import "WorkInstructionsViewController.h"
#import "ChecklistViewController.h"
#import "BaseViewController.h"
#import "Job.h"

@interface ProcessDetailsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, WorkInstructionsDelegate, ChecklistDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_timerButton;
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_startDateLabel;
    IBOutlet UILabel *_stopDateLabel;
    IBOutlet UILabel *_timedLoggedLabel;
    IBOutlet MZTimerLabel *_timerLabel;

    NSMutableArray *dataArray;
    BOOL timerRunning;
    UIBarButtonItem *statusButton;
    Process *process;
    Job *job;
}
- (void)setJob:(Job*)job_;
- (void)setProcess:(Process*)process_;
@end
