//
//  ProductSelectionViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProductSelectionViewCell.h"

@implementation ProductSelectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)productData {
    _nameLabel.text = productData[@"Name"];
    _statusLabel.text = productData[@"Status"];
    _updatedLabel.text = productData[@"last updated"];
    _versionLabel.text = productData[@"last version"];
    _photoImageView.image = [UIImage imageNamed:productData[@"Product Number"]];
}

@end
