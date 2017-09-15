//
//  ChecklistGenViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChecklistGenCell.h"
#import "Run.h"

@interface ChecklistGenViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ChecklistGenCellDelegate, UITextFieldDelegate> {
    IBOutlet UILabel *_productLabel;
    IBOutlet UILabel *_countLabel;
    IBOutlet UIButton *_generateButton;
    IBOutlet UIButton *_addEntryButton;
    IBOutlet UITextField *_runIdTF;
    IBOutlet UITextField *_startIdTF;
    IBOutlet UITextField *_quantityTF;
    IBOutlet UITextField *_macAddrTF;
    IBOutlet UITextField *_sensorIdTF;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_addEntryView;
    IBOutlet UIView *_addUnitEntryView;
    
    Run *run;
    
    NSMutableArray *checklistArray;
    NSMutableArray *checklistHeaderArray;
    
    int runType;
    int runId;
    int editingIndex;
    BOOL editMode;
}
- (void)setRun:(Run*)run_;


@end
