//
//  CommonProcessListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/09/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface CommonProcessListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NIDropDownDelegate, UITextFieldDelegate> {
    IBOutlet UIButton *_stationButton;
    IBOutlet UITextField *_stationIdTF;
    IBOutlet UITextField *_processNameTF;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_editView;
    IBOutlet UIView *_tintView;
    
    NIDropDown *dropDown;
    NSMutableArray *processesArray;
    NSMutableArray *stationsArray;
    
    int selectedIndex;
    int selectedStation;
}

@end
