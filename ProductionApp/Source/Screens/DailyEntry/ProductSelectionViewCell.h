//
//  ProductSelectionViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductSelectionViewCell : UITableViewCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_updatedLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_versionLabel;
    IBOutlet UIImageView *_photoImageView;
}
- (void)setCellData:(NSMutableDictionary*)productData;
@end
