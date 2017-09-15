//
//  WorkInstructionCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 11/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "WorkInstructionCell.h"

@implementation WorkInstructionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInstructionData:(WorkInstruction*)instruction {
    NSLog(@"setting instruction: %@",[instruction getInstructionText]);
    instructionTextView.text = [instruction getInstructionText];
}

- (IBAction)imagePressed:(UIButton*)sender {
    [_delegate showImage:sender.imageView.image];
}
@end
