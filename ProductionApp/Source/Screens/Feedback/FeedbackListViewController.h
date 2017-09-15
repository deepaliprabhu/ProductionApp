//
//  FeedbackListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"

typedef enum {
    LISTTYPESTATUS = 1,
    LISTTYPEOWNER = 2,
    LISTTYPECATEGORY = 3,
    LISTTYPEPRODUCT = 4
}ListType;

@interface FeedbackListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, kDropDownListViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_feedbackIdLabel;
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UILabel *_transferIdLabel;
    IBOutlet UILabel *_runIdLabel;
    IBOutlet UILabel *_categoryLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_createdByLabel;
    IBOutlet UILabel *_ownerLabel;
    IBOutlet UILabel *_receivedLabel;
    IBOutlet UILabel *_totalQtyLabel;
    IBOutlet UILabel *_defectQtyLabel;
    IBOutlet UILabel *_productLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_countLabel;
    IBOutlet UIButton *_pickButton;
    IBOutlet UITextView *_issuesTextView;
    IBOutlet UIView *_feedbackDetailView;
    IBOutlet UIView *_tintView;
    IBOutlet UIWebView *_webView;
    
    NSMutableArray *feedbackArray;
    NSMutableArray *filteredArray;
    NSMutableArray *statusArray;
    NSMutableArray *ownerArray;
    NSMutableArray *productArray;
    NSMutableArray *categoryArray;
    NSMutableArray *dropdownArray;
    DropDownListView * dropDownList;
    
    BOOL filtered;
    ListType listType;
    int selectedIndex;
}
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple;
- (void)setListType:(ListType)listType_;
- (void)setSelectedIndex:(int)index;
@end
