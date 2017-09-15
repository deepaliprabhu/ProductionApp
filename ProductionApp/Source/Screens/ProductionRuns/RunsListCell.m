//
//  RunsListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/07/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "RunsListCell.h"
#import "Run.h"

@implementation RunsListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRunData:(Run*)run {
    //if (![run isActivated]) {
       // _runIdLabel.textColor = [UIColor lightGrayColor];
    //}
    if([run getCategory]==0) {
        _runIdLabel.text = [NSString stringWithFormat:@"[PCB] %ld: %@",(long)run.runId,run.productName];
    }
    else {
        _runIdLabel.text = [NSString stringWithFormat:@"[ASSM] %ld: %@",(long)run.runId,run.productName];
    }
        
    _quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)run.quantity];
    _requestDateLabel.text = [run getStatus];
    _seqNumLabel.text = [NSString stringWithFormat:@"%ld",(long)run.sequence];
    
    NSString *status = run.status;
    if (([status isEqualToString:@"In Progress"])||([status isEqualToString:@"IN PROGRESS"])||([status isEqualToString:@"IN PROCESS"])) {
        _statusView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        _requestDateLabel.text = [NSString stringWithFormat:@"%@ (%@)",@"IN PROCESS",[run getRunData][@"Inprocess"]];
    }
    else if ([status isEqualToString:@"Ready For Dispatch"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        _requestDateLabel.text = [NSString stringWithFormat:@"%@ (%@)",@"Ready",[run getRunData][@"Ready"]];
    }
    else if ([status isEqualToString:@"Closed"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.7];
    }
    else if ([[status lowercaseString] containsString:@"low priority"]) {
        _statusView.backgroundColor = [UIColor grayColor];
    }
    else if ([[status lowercaseString] containsString:@"parts short"]||[[status lowercaseString] containsString:@"on hold"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.7];
    }
    else {
        _statusView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:227.0f/255.0f blue:167.0f/255.0f alpha:0.7];
    }

}

@end
