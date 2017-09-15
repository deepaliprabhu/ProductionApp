//
//  JobListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "JobListCell.h"

@implementation JobListCell

- (void)awakeFromNib {
    // Initialization code
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    [self addGestureRecognizer:self.lpgr];
    self.layer.borderColor = [UIColor colorWithRed:200.0f/255 green:200.0f/255 blue:200.0f/255 alpha:0.5].CGColor;
    self.layer.borderWidth = 1;
}

- (void)setHighlighted:(BOOL)selected {
}

- (void)setSelected:(BOOL)selected {
}

- (void)selectCell {
    selected = true;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 2;
}

- (void)deselectCell {
    selected = false;
    self.layer.borderColor = [UIColor colorWithRed:200.0f/255 green:200.0f/255 blue:200.0f/255 alpha:0.5].CGColor;
    self.layer.borderWidth = 1;
}

- (BOOL)isCellSelected {
    return selected;
}


- (void)setJobData:(Job*)job {
    NSString *jobIdString = [job getJobId];
    NSRange startRange = [jobIdString rangeOfString:@"-"];
    
    NSRange searchRange = NSMakeRange(startRange.location+1 , jobIdString.length-(startRange.location+1));
    NSString *substring = [jobIdString substringWithRange:searchRange];
    _jobIdLabel.text = substring;
    switch ([job getJobType]) {
        case 0:
            _statusView.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:191.0f/255.0f blue:59.0f/255.0f alpha:0.7];
            break;
        case 1:
            _statusView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
            break;
        case 2:
            _statusView.backgroundColor = [UIColor colorWithRed:189.0f/255 green:195.0f/255 blue:199.0f/255 alpha:1];
            break;
        case 3:
            _statusView.backgroundColor = [UIColor colorWithRed:129.0f/255 green:207.0f/255 blue:224.0f/255 alpha:1];
            break;
        case 4:
            _statusView.backgroundColor = [UIColor colorWithRed:231.0f/255 green:76.0f/255 blue:60.0f/255 alpha:1];
            break;
        default:
            break;
    }
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self selectCell];
        [_delegate setMultiMode:true];
    }
}

@end
