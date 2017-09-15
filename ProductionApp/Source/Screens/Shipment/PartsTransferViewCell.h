//
//  PartsTransferViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartsTransferViewCell : UITableViewCell {
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_locationToLabel;
    IBOutlet UILabel *_statusLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
