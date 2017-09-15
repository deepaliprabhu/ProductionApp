//
//  ProcessFlowViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/08/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol ProcessFlowViewCellDelegate;
@interface ProcessFlowViewCell : UITableViewCell {
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_indexLabel;
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_stationLabel;
    
    int index;
}
__pd(ProcessFlowViewCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_;
@end

@protocol ProcessFlowViewCellDelegate <NSObject>
- (void) deleteProcessAtIndex:(int)index;
@end
