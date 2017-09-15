//
//  JobDetailsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 06/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "BaseViewController.h"
#import "ServerManager.h"

@interface JobDetailsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, ServerProtocol> {
    IBOutlet UILabel *productIdLabel;
    IBOutlet UILabel *productNameLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *defectsLabel;
    IBOutlet UILabel *startDateLabel;
    IBOutlet UILabel *stopDateLabel;
    IBOutlet UITableView *_tableView;
    UIBarButtonItem *statusButton;
    Job *job;
    NSMutableArray *dataArray;
}
- (void)setJob:(Job*)job_;
@end
