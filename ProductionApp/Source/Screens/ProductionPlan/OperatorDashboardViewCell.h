//
//  OperatorDashboardViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatorDashboardViewCell : UICollectionViewCell {
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_timeLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
