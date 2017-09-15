//
//  SearchViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import "MVSelectorScrollView.h"


@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MVSelectorScrollViewDelegate> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *parseRuns;
    DZNSegmentedControl *control;
}
@property IBOutlet MVSelectorScrollView *scrollView;
@end
