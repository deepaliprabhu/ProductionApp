//
//  DailyListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "DailyListCell.h"

@implementation DailyListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData: (PFObject*)cellData {
    NSLog(@"cellData = %@",cellData);
    parseObject = cellData;
    _titleLabel.text = [NSString stringWithFormat:@"%@: %@", [cellData objectForKey:@"Station"],[cellData objectForKey:@"ProcessName"]];
    _rejectLabel.text = cellData[@"Reject"];
    _reworkLabel.text = cellData[@"Rework"];
    _quantityLabel.text = cellData[@"Quantity"];
    _operatorLabel.text = cellData[@"Operator"];

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
