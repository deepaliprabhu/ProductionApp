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
    IBOutlet UIButton *_operator1Button;
    IBOutlet UIButton *_operator2Button;
    IBOutlet UIButton *_operator3Button;
    IBOutlet UITextField *_stationIdTF;
    IBOutlet UITextField *_processNameTF;
    IBOutlet UITextField *_timeTF;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_editView;
    IBOutlet UIView *_tintView;
    IBOutlet UISearchBar *_searchBar;
    
    NIDropDown *dropDown;
    NSMutableArray *processesArray;
    NSMutableArray *stationsArray;
    NSMutableArray *operatorArray;
    
    int selectedIndex;
    int selectedStation;
    int selectedOperatorIndex;
}

@end
