//
//  DailyStatsViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface DailyStatsViewCell : UICollectionViewCell {
    IBOutlet UILabel *_indexLabel;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_qtyLabel;
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_timeLabel;
}

- (void) setCellData:(Station*)station;

@end
