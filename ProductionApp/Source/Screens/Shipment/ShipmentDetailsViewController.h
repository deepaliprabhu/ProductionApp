//
//  ShipmentDetailsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ShipmentDetailsViewController : UIViewController {
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_transferIdLabel;
    IBOutlet UILabel *_trackingIdLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UIButton *_trackingIdButton;
    IBOutlet UIScrollView *_productsScrollView;
    
    NSMutableArray *parseShipmentArray;
    PFObject *shipmentData;
}
- (void)setShipmentData:(PFObject*)shipmentData_;
@end
