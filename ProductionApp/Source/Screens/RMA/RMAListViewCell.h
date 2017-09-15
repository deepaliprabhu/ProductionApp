//
//  RMAListViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 16/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol RMAListCellDelegate;
@interface RMAListViewCell : UITableViewCell {
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UILabel *_createdByLabel;
    IBOutlet UILabel *_descriptionLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_productLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_locationLabel;
    
    int cellIndex;
}
__pd(RMAListCellDelegate);

- (void)setCellData:(NSMutableDictionary*)cellData;

@end

@protocol RMAListCellDelegate <NSObject>
- (void) selectedCellWithIndex:(int)index;
@end
