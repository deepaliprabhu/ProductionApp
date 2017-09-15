//
//  StockViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 22/07/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import "NIDropDown.h"


@interface StockViewController : UIViewController<NIDropDownDelegate, UITableViewDelegate, UITableViewDataSource> {
    DZNSegmentedControl *control;
    NIDropDown *dropDown;

    IBOutlet UIView *_addProductView;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_productButton;
    IBOutlet UIButton *_locationButton;
    IBOutlet UITextField *_countTextfield;
    NSArray *locationArray;
    NSArray *productArray;
    NSMutableArray *stockArray;
    NSMutableArray *puneStockArray;
    NSMutableArray *masonStockArray;
    NSMutableArray *lausanneStockArray;
    NSMutableArray *filteredArray;
}

@end
