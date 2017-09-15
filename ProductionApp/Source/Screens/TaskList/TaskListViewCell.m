//
//  TaskListViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "TaskListViewCell.h"

@implementation TaskListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_ {
    index = index_;
    _assignedByLabel.text = cellData[@"AssignedBy"];
    _assignedToLabel.text = cellData[@"AssignedTo"];
    _dueLabel.text = cellData[@"DueDate"];
    _textView.text = cellData[@"Task"];
    if ([cellData[@"Status"] isEqualToString:@"Open"]) {
        [_statusButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    }
    else {
        [_statusButton setImage:[UIImage imageNamed:@"doneCheck.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)statusPressed:(id)sender {
    if (closed) {
        closed = false;
        [_statusButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
        [_delegate updateStatus:false forIndex:index];
    }
    else {
        closed = true;
        [_statusButton setImage:[UIImage imageNamed:@"doneCheck.png"] forState:UIControlStateNormal];
        [_delegate updateStatus:true forIndex:index];
    }
}

- (IBAction)deletePressed:(id)sender {
    [_delegate deleteTaskAtIndex:index];
}

@end
