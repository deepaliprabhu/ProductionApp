//
//  PartsTransferDetailViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartsTransferDetailViewCell : UITableViewCell {
    IBOutlet UILabel *_partNumberLabel;
    IBOutlet UILabel *_partDetailLabel;
    IBOutlet UILabel *_quantityLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
