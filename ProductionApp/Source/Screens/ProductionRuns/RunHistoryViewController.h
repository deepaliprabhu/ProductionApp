//
//  RunHistoryViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Run.h"

@interface RunHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *parseRuns;
    int runId;
}
- (void)setRunId:(int)runId_;
@end
