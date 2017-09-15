//
//  ProcessFlowViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 10/08/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"
#import "ProcessFlowViewCell.h"
#import "NIDropDown.h"

@interface ProcessFlowViewController : UIViewController<UITextFieldDelegate, NIDropDownDelegate> {
    IBOutlet UILabel *_versionLabel;
    IBOutlet UILabel *_originatorLabel;
    IBOutlet UILabel *_approverLabel;
    IBOutlet UIButton *_stationButton;
    IBOutlet UIButton *_statusButton;
    IBOutlet UIButton *_pickOriginatorButton;
    IBOutlet UIButton *_pickApproverButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_versionEntryView;
    IBOutlet UITextField *_stationIdTF;
    IBOutlet UITextField *_processNameTF;
    IBOutlet UITextField *_versionTF;
    IBOutlet UITextField *_originatorTF;
    IBOutlet UITextField *_approverTF;
    IBOutlet UITextView *_commentsTextView;
    IBOutlet UIView *_addProcessView;
    IBOutlet UIView *_tintView;
    IBOutlet UIView *_editView;
    
    DropDownListView * dropDownList;
    NIDropDown *dropDown;

    NSMutableArray *processNamesArray;
    NSMutableArray *processesArray;
    NSMutableArray *commonProcessesArray;
    NSMutableArray *saveOptionsArray;
    NSMutableArray *statusOptionsArray;
    NSMutableArray *selectedProcessesArray;
    NSMutableArray *stationsArray;
    NSMutableArray *originatorArray;
    NSMutableArray *approverArray;
    NSMutableDictionary *product;
    
    NSString *processCntrlId;
    int selectedStation;
}
- (void)setSelectedProduct:(NSMutableDictionary*)product_;

@end
