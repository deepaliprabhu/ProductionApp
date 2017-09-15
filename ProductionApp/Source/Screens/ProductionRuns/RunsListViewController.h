//
//  RunsListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/07/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunsListCell.h"
#import "ServerManager.h"
#import "BaseViewController.h"
#import "NIDropDown.h"
#import "ParseDataManager.h"
#import "DragAndDropTableView.h"
#import "DataManager.h"
#import "DropDownListView.h"


@interface RunsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NIDropDownDelegate, ParseDataManagerProtocol,DataManagerProtocol> {
    IBOutlet DragAndDropTableView *_tableView;
    IBOutlet UIView *_tintView;
    IBOutlet UIView *_batchView;
    IBOutlet UIView *_runStatusView;
    IBOutlet UIView *_dispatchView;
    IBOutlet UIButton *_statusButton;
    IBOutlet UIButton *_processButton;
    IBOutlet UIButton *_dispatchButton;

    IBOutlet UITextField *_okayTF;
    IBOutlet UITextField *_reworkTF;
    IBOutlet UITextField *_rejectTF;
    IBOutlet UITextField *_operatorTF;
    IBOutlet UITextField *_processTF;
    
    IBOutlet UITextField *_runShippedTF;
    IBOutlet UITextField *_runOkayTF;
    IBOutlet UITextField *_runReworkTF;
    IBOutlet UITextField *_runInProcessTF;
    IBOutlet UITextField *_runRejectTF;
    IBOutlet UITextField *_countTF;
    
    IBOutlet UILabel *_shippedTitleLabel;
    IBOutlet UILabel *_runIDTitle;
    
    IBOutlet UIView *_qtyEntryView;
    IBOutlet UITextField *_qtyTF;
    IBOutlet UILabel *_qtyTitleLabel;

    UIView *processEntryView;
    RunsListCell *runListCell;
    Run *selectedRun;
    NIDropDown *dropDown;
    DropDownListView * dropDownList;

    NSMutableArray *operatorArray;
    NSMutableArray *statusArray;
    NSMutableArray *processArray;
    NSMutableArray *parseRuns;
    NSMutableArray *parseRunProcesses;
    NSMutableArray *processDataArray;
    NSMutableArray *textfieldArray;
    NSMutableArray *dispatchArray;
    NSMutableArray *operationsArray;
    NSMutableArray *processesArray;
    NSString *selectedOperator;
    NSString *selectedStatus;
    NSString *selectedProcess;
    NSString *selectedShipping;
    int destIndex;
    int srcIndex;
    int selectedStatusIndex;
    BOOL multipleUpdates;
}

@end
