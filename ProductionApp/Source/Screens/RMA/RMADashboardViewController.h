//
//  RMADashboardViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"


@interface RMADashboardViewController : UIViewController<ConnectionProtocol> {
    IBOutlet UILabel *_authorizedLabel;
    IBOutlet UILabel *_autopsyLabel;
    IBOutlet UILabel *_allStatusLabel;
    IBOutlet UILabel *_masonLabel;
    IBOutlet UILabel *_lausanneLabel;
    IBOutlet UILabel *_allLocationLabel;
    IBOutlet UILabel *_sentinelLabel;
    IBOutlet UILabel *_iCelsiusLabel;
    IBOutlet UILabel *_allProductLabel;
    IBOutlet UILabel *_closed3Label;
    IBOutlet UILabel *_closed6Label;
    IBOutlet UILabel *_closedAllLabel;
    IBOutlet UIButton *_allButton;
    NSMutableArray *rmaArray;
}

@end
