//
//  ShipmentListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"


@interface ShipmentListViewController : UIViewController {
    IBOutlet UITableView *_tableView;
    BOOL filtered;
    NSMutableArray *filteredArray;
    NSMutableArray *parseShipmentArray;
}

@end
