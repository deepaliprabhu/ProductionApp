//
//  RunStatsCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "RunStatsCell.h"

@implementation RunStatsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellData: (NSMutableDictionary*)cellData notes:(BOOL)show {
    //NSLog(@"cellData = %@",cellData);
    if ([cellData[@"Category"] isEqualToString:@"PCB"]) {
        _titleLabel.text = [NSString stringWithFormat:@"[PCB] %@: %@",[cellData objectForKey:@"Run"], [cellData objectForKey:@"Product"]];

    }
    else {
        _titleLabel.text = [NSString stringWithFormat:@"[ASSM] %@: %@",[cellData objectForKey:@"Run"], [cellData objectForKey:@"Product"]];

    }
    //_closedProcLabel.text = cellData[@"Ready"];
    //_openProcLabel.text = cellData[@"OpenProcesses"];
    //_rejectLabel.text = cellData[@"Rejects"];
    //_reworkLabel.text = cellData[@"Reworks"];
    //_defectLabel.text = cellData[@"Defects"];
    if (cellData[@"Shipping"]) {
        _shippingLabel.text = cellData[@"Shipping"];
    }
    
   /* if (([cellData[@"ProcessName"] isEqualToString:@"Shipped"])||([cellData[@"ProcessName"] isEqualToString:@"Dispatched"])) {
        _processLabel.text = [NSString stringWithFormat:@"%@(%@)", cellData[@"ProcessName"],cellData[@"Shipped"]];
    }
    else if ([cellData[@"ProcessName"] isEqualToString:@"Ready To Dispatch"]) {
        _processLabel.text = [NSString stringWithFormat:@"%@(%@)", cellData[@"ProcessName"],cellData[@"Okay"]];
    }
    else if ([cellData[@"ProcessName"] isEqualToString:@"NEW"]) {
        _processLabel.text = cellData[@"Status"];
    }
    else
        _processLabel.text = [NSString stringWithFormat:@"%@(%@)", cellData[@"ProcessName"],cellData[@"Reworks"]];
    _quantityLabel.text = cellData[@"Quantity"];*/
    
    if ([cellData[@"Reworks"] intValue]> 0) {
        _processLabel.text = [NSString stringWithFormat:@"In Process(%@)", cellData[@"Reworks"]];
    }
    else if([cellData[@"Okay"] intValue]> 0) {
        if ([cellData[@"ProcessType"] intValue] == 0) {
            _processLabel.text = [NSString stringWithFormat:@"Ready To Dispatch(%@)", cellData[@"Okay"]];
        }
        else {
            _processLabel.text = [NSString stringWithFormat:@"Ready To Ship(%@)", cellData[@"Okay"]];
        }
    }
    else if([cellData[@"Shipped"] intValue]> 0) {
        if ([cellData[@"Category"] isEqualToString:@"PCB"]) {
            _processLabel.text = [NSString stringWithFormat:@"Dispatched(%@)", cellData[@"Shipped"]];
        }
        else {
            _processLabel.text = [NSString stringWithFormat:@"Shipped(%@)", cellData[@"Shipped"]];
        }
    }
    
    if ([_processLabel.text isEqualToString:@""]) {
        _processLabel.text = cellData[@"Status"];
    }
    if ([_processLabel.text isEqualToString:@"Open"]) {
        _processLabel.text = @"NEW";
    }
    NSString *status = cellData[@"Status"];
    _processLabel.text = status;

    if (([status isEqualToString:@"In Progress"])||([status isEqualToString:@"IN PROGRESS"])||([status isEqualToString:@"IN PROCESS"])) {
        _statusView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        _typeLabel.textColor = [UIColor whiteColor];
        _sequenceLabel.textColor = [UIColor whiteColor];
        _processLabel.text = [NSString stringWithFormat:@"%@ (%@)",@"IN PROCESS",cellData[@"Inprocess"]];
    }
    else if ([[status lowercaseString] isEqualToString:@"ready for dispatch"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        _typeLabel.textColor = [UIColor whiteColor];
        _sequenceLabel.textColor = [UIColor whiteColor];
        _processLabel.text = [NSString stringWithFormat:@"%@ (%@)",status,cellData[@"Ready"]];
    }
    else if ([[status lowercaseString] isEqualToString:@"shipped"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        _typeLabel.textColor = [UIColor whiteColor];
        _sequenceLabel.textColor = [UIColor whiteColor];
        _processLabel.text = [NSString stringWithFormat:@"%@ (%@)",status,cellData[@"Shipped"]];
    }
    else if ([status isEqualToString:@"Closed"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.7];
        _typeLabel.textColor = [UIColor whiteColor];
        _sequenceLabel.textColor = [UIColor whiteColor];
    }
    else if ([[status lowercaseString] containsString:@"low priority"]) {
        _statusView.backgroundColor = [UIColor grayColor];
        _typeLabel.textColor = [UIColor whiteColor];
        _sequenceLabel.textColor = [UIColor whiteColor];
        _processLabel.text = status;
    }
    else if ([[status lowercaseString] containsString:@"parts short"]||[[status lowercaseString] containsString:@"on hold"]) {
        _statusView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.7];
        _typeLabel.textColor = [UIColor whiteColor];
        _sequenceLabel.textColor = [UIColor whiteColor];
        _processLabel.text = status;
    }
    else {
        _typeLabel.textColor = [UIColor darkGrayColor];
        _sequenceLabel.textColor = [UIColor darkGrayColor];
        _statusView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:227.0f/255.0f blue:167.0f/255.0f alpha:0.7];
    }
    _quantityLabel.text = cellData[@"Qty"];
    _sequenceLabel.text = [NSString stringWithFormat:@"%d",[cellData[@"Sequence"] intValue]+1];
    if ([cellData[@"Run Type"] isEqualToString:@"Development"]) {
        _typeLabel.hidden = false;
    }
    else {
        _typeLabel.hidden = true;
    }
    
    if (show) {
        _notesButton.hidden = false;
    }
}

@end
