//
//  DailyListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Defines.h"

@protocol DailyListCellDelegate;
@interface DailyListCell : UITableViewCell<UIAlertViewDelegate> {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_reworkLabel;
    IBOutlet UILabel *_rejectLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_operatorLabel;

    
    PFObject *parseObject;
}
__pd(DailyListCellDelegate);
- (void)setCellData: (PFObject*)cellData;

@end

@protocol DailyListCellDelegate <NSObject>
- (void) reloadData;
@end