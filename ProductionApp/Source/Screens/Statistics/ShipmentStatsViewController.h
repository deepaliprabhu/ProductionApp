//
//  ShipmentStatsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ShipmentStatsCell.h"
#import "DZNSegmentedControl.h"

@interface ShipmentStatsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, ShipmentStatsCellDelegate> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *parseRuns;
    NSMutableArray *parseDemands;
    NSMutableArray *filteredArray;
    PFObject *selectedParseObject;
    DZNSegmentedControl *shipmentLocationControl;
    DZNSegmentedControl *shipmentTimeControl;
    DZNSegmentedControl *shipmentStatusControl;
    
    BOOL filtered;
}

@end
