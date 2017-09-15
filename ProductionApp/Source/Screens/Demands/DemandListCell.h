//
//  DemandListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/05/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"


@protocol DemandListCellDelegate;
@interface DemandListCell : UITableViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIButton *_runButton;
    IBOutlet UIButton *_expectedDateButton;
    
    int tag;
}
__pd(DemandListCellDelegate);

- (void)setCellData:(NSDictionary*)cellData withTag:(int)tag_;
- (void)setExpectedDate:(NSString*)dateString;
@end

@protocol DemandListCellDelegate <NSObject>
- (void) selectedExpectedShippingWithTag:(int)tag;
- (void) selectedRunButtonWithTag:(int)tag;
@end
