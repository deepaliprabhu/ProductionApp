//
//  RunFeedbackListController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"


@interface RunFeedbackListController : UIViewController<UITableViewDelegate, UITableViewDataSource, kDropDownListViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_countLabel;
    IBOutlet UIButton *_pickButton;
    
    DropDownListView * dropDownList;
    NSMutableArray *feedbackArray;
    NSMutableArray *filteredArray;
    NSMutableArray *dropDownArray;
}
- (void)setFeedbackArray:(NSMutableArray*)feedbackArray_;

@end
