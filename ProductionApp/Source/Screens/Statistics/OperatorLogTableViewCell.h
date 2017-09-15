//
//  OperatorLogTableViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatorLogTableViewCell : UITableViewCell {
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_qtyLabel;
    IBOutlet UILabel *_operationsLabel;
    IBOutlet UILabel *_hoursLabel;
    IBOutlet UILabel *_pointsLabel;
}

- (void)setCellData:(NSMutableDictionary*)cellData;
@end
