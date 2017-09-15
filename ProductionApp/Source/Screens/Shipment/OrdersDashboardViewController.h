//
//  OrdersDashboardViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 26/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "DZNSegmentedControl.h"

@interface OrdersDashboardViewController : UIViewController<ConnectionProtocol> {
    IBOutlet UILabel *_createdLabel;
    IBOutlet UILabel *_approvedLabel;
    IBOutlet UILabel *_shippedLabel;
    IBOutlet UILabel *_iCelsiusLabel;
    IBOutlet UILabel *_sentinelLabel;
    IBOutlet UILabel *_receptorLabel;
    IBOutlet UILabel *_iCelsiusRMALabel;
    IBOutlet UILabel *_sentinelRMALabel;
    IBOutlet UILabel *_receptorRMALabel;
    IBOutlet UIButton *_allButton;
    IBOutlet UIButton *_allRMAButton;
    
    DZNSegmentedControl *periodControl;

    NSMutableArray *ordersArray;
    NSMutableArray *rmaArray;
    NSMutableArray *filteredRMAArray;
    int selectedPeriodIndex;
}

@end
