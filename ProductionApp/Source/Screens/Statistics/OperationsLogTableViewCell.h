//
//  OperationsLogTableViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationsLogTableViewCell : UITableViewCell {
    IBOutlet UILabel *_operationLabel;
    IBOutlet UILabel *_qtyLabel;
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_hoursLabel;
    IBOutlet UILabel *_pointsLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;

@end
