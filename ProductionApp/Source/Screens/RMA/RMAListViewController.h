//
//  RMAListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 15/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "DZNSegmentedControl.h"

typedef enum {
    RMALISTTYPESTATUS = 1,
    RMALISTTYPELOCATION = 2,
    RMALISTTYPEPRODUCT = 3,
    RMALISTTYPECLOSED = 4,
    RMALISTTYPEALL = 5

}RMAListType;

@interface RMAListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ConnectionProtocol> {
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UILabel *_productLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_orderIdLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_purposeLabel;
    IBOutlet UILabel *_createdByLabel;
    IBOutlet UILabel *_sensorsLabel;
    IBOutlet UITextView *_descriptionTextView;
    IBOutlet UIView *_rmaDetailView;
    IBOutlet UIView *_tintView;

    DZNSegmentedControl *periodControl;
    DZNSegmentedControl *listTypeControl;

    NSMutableArray *rmaArray;
    NSMutableArray *filteredPeriodArray;
    NSMutableArray *filteredArray;
    NSArray *listTypeArray;
    RMAListType listType;
    
    int selectedPeriodIndex;
    int selectedListTypeIndex;
}
- (void)setListType:(RMAListType)listType withIndex:(int)listIndex;
- (void)setRMAList:(NSMutableArray*)rmalist;

@end
