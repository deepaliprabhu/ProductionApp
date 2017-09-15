//
//  OrderListDetailViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListDetailViewCell : UITableViewCell {
    IBOutlet UILabel *_partNumberLabel;
    IBOutlet UILabel *_partDetailLabel;
    IBOutlet UILabel *_quantityLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
