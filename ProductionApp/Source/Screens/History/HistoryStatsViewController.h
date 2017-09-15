//
//  HistoryStatsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import "MVSelectorScrollView.h"

@interface HistoryStatsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MVSelectorScrollViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_producedLabel;
    IBOutlet UILabel *_shippedLabel;
    
    DZNSegmentedControl *control;
    
    NSMutableArray *productsArray;
    NSMutableArray *monthArray;
    NSMutableArray *statsArray;
    NSMutableDictionary *producedDict;
    NSMutableDictionary *shippedDict;
}
@property IBOutlet MVSelectorScrollView *scrollView;

@end
