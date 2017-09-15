//
//  ShipmentStatsCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ShipmentStatsCell.h"

@implementation ShipmentStatsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData: (PFObject*)cellData {
    //NSLog(@"cellData = %@",cellData);
    parseObject = cellData;
    if (cellData[@"Product"]) {
        _productLabel.text = cellData[@"Product"];
    }
    else {
        _productLabel.text = cellData[@"ProductName"];
    }
    
    if (cellData[@"Quantity"]) {
        _quantityLabel.text = cellData[@"Quantity"];
    }
    else {
        NSString *countString = cellData[@"Shipping"];
        countString = [countString stringByReplacingOccurrencesOfString:@"This Week" withString:@""];
        countString =[countString stringByReplacingOccurrencesOfString:@"Next Week" withString:@""];
        countString =[countString stringByReplacingOccurrencesOfString:@"(" withString:@""];

        countString =[countString stringByReplacingOccurrencesOfString:@")" withString:@""];
        countString =[countString stringByReplacingOccurrencesOfString:@"Today" withString:@""];

        _quantityLabel.text = countString;
    }

    _locationLabel.text = cellData[@"Location"];
    _dateLabel.text = cellData[@"Date"];
}

- (IBAction)trashButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Are you sure you want to delete this Report?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)deleteStat {
    [parseObject deleteInBackground];
    [_delegate reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            [self deleteStat];
        }
            break;
        default:
            break;
    }
}

@end
