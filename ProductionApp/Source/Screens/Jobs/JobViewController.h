//
//  JobViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Run.h"
#import "Process.h"
#import "WorkInstructionsViewController.h"
#import "ChecklistViewController.h"
#import "MZTimerLabel.h"
#import "ScannerViewController.h"
#import "Job.h"

@interface JobViewController : BaseViewController <ScannerViewDelegate, UISearchBarDelegate, UIAlertViewDelegate> {
    IBOutlet UIView *_jobView;
    IBOutlet UIView *_checklistView;
    IBOutlet UIView *_backView;
    IBOutlet UILabel *_jobIdLabel;
    IBOutlet UILabel *_jobCount;
    IBOutlet UILabel *_jobsRemaining;
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_nextButton;
    IBOutlet UIButton *_prevButton;
    IBOutlet MZTimerLabel *_timerLabel;
    IBOutlet UITextView *_checklistTextView;

    BOOL jobStarted;
    BOOL showingChecklist;
    int currentJobIndex;
    int currentChecklistIndex;
    
    Run *run;
    Process *process;
    Job *currentJob;

    NSMutableArray *jobs;
    NSMutableArray *checklistArray;
}
- (void)setProcess:(Process*)process_;
@end
