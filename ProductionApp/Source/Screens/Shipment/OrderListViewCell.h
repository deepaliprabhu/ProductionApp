//
//  OrderListViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewCell : UITableViewCell {
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_statusLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
