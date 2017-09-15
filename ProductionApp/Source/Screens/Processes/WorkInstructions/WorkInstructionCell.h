//
//  WorkInstructionCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 11/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkInstruction.h"
#import "Defines.h"

@protocol WorkInstructionsCellDelegate;
@interface WorkInstructionCell : UITableViewCell {
    IBOutlet UITextView *instructionTextView;
}
__pd(WorkInstructionsCellDelegate);
- (void)setInstructionData:(WorkInstruction*)instruction;
@end

@protocol WorkInstructionsCellDelegate <NSObject>
- (void) showImage:(UIImage*)image;
@end