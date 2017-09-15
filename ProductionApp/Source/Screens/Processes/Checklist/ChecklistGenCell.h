//
//  ChecklistGenCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol ChecklistGenCellDelegate;
@interface ChecklistGenCell : UITableViewCell {
    IBOutlet UILabel *_sensorIdLabel;
    IBOutlet UIButton *_statusButton;
    
    int index;
}
__pd(ChecklistGenCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_;
@end

@protocol ChecklistGenCellDelegate <NSObject>
- (void) editCellWithIndex:(int)index;
@end
