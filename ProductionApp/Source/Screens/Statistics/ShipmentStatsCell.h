//
//  ShipmentStatsCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Defines.h"

@protocol ShipmentStatsCellDelegate;
@interface ShipmentStatsCell : UITableViewCell {
    IBOutlet UILabel *_productLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_dateLabel;
    PFObject *parseObject;

}
__pd(ShipmentStatsCellDelegate);
- (void)setCellData: (PFObject*)cellData;

@end

@protocol ShipmentStatsCellDelegate <NSObject>
- (void) reloadData;
@end
