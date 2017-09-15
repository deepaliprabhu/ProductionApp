//
//  RunDetailsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"
#import "BaseViewController.h"
#import <Parse/Parse.h>
#import "ServerManager.h"
#import "ConnectionManager.h"
#import "NotesViewController.h"
#import "MIBadgeButton.h"


@interface RunDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, ConnectionProtocol, NotesViewControllerDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UITableView *_partDetailsTableView;
    IBOutlet UITableView *_partShortTableView;
    IBOutlet UILabel *_runIdLabel;
    IBOutlet UILabel *_productIdLabel;
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_vendorNameLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_shippedLabel;
    IBOutlet UILabel *_readyLabel;
    IBOutlet UILabel *_inProcessLabel;
    IBOutlet UILabel *_reworkLabel;
    IBOutlet UILabel *_rejectLabel;
    IBOutlet UILabel *_requestDateLabel;
    IBOutlet UILabel *_runDateLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_priorityLabel;
    IBOutlet UILabel *_descriptionLabel;
    IBOutlet UILabel *_lastActivityLabel;
    IBOutlet UILabel *_shippedTitleLabel;
    IBOutlet UILabel *_shippingLabel;
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UILabel *_puneLabel;
    IBOutlet UILabel *_masonLabel;
    IBOutlet UILabel *_lausanneLabel;
    IBOutlet UILabel *_s2Label;
    IBOutlet UILabel *_totalStockLabel;
    IBOutlet UILabel *_partNameLabel;
    IBOutlet UILabel *_shortCountLabel;
    IBOutlet UILabel *_needTotalLabel;
    IBOutlet UILabel *_balLabel;
    IBOutlet UILabel *_poIdLabel;
    IBOutlet UILabel *_progressLabel;
    IBOutlet UIButton *_transferIdButton;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIImageView *_pointerImageView;
    IBOutlet UIImageView *_productImageView;
    IBOutlet UIView *_processStepsView;
    IBOutlet UIView *_processListView;
    IBOutlet UIView *_runpartDetailsView;
    IBOutlet UIView *_tintView;
    IBOutlet UIView *_whiteTintView;
    IBOutlet UIView *_inStockDetailView;
    IBOutlet UIView *_needDetailView;
    IBOutlet UIView *_partsAllocationView;
    IBOutlet UIView *_progressView;
    IBOutlet MIBadgeButton *_notesButton;
    IBOutlet MIBadgeButton *_feedbackButton;
    UIView *processEntryView;
    
    Run* run;
    
    NSMutableDictionary *runData;
    UIBarButtonItem *statusButton;
    NSMutableArray *dataArray;
    NSMutableArray *processArray;
    NSMutableArray *parseRunProcesses;
    NSMutableDictionary *processData;
    NSMutableArray *partsTransferList;
    NSMutableArray *partDetailsArray;
    NSMutableArray *partsArray;
    NSMutableArray *feedbackArray;
    
    int selectedListIndex;
}
- (void)setRun:(Run*)run_;
- (void)setRunData:(NSMutableDictionary*)runData;
- (void) parseJsonResponse:(NSData*)jsonData;

@end
