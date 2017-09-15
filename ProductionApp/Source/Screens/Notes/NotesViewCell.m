//
//  NotesViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "NotesViewCell.h"

@implementation NotesViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _nameLabel.text = cellData[@"Name"];
    _dateLabel.text = cellData[@"Date"];
    _noteTextView.text = cellData[@"Comment"];
}
@end
