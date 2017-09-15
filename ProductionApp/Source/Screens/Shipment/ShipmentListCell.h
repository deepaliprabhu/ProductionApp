//
//  ShipmentListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipmentListCell : UITableViewCell {
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_qtyLabel;
}

-(void)setCellData:(NSMutableDictionary*)cellData;
@end
