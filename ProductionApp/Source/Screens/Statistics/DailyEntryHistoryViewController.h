//
//  DailyEntryHistoryViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/01/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryGraphView.h"


@interface DailyEntryHistoryViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_viewGraphButton;
    
    HistoryGraphView *historyGraphView;
    NSMutableArray *historyStatsArray;
    NSMutableArray *operationsArray;

}
- (void)setParseData:(NSMutableArray*)parseArray;


@end
