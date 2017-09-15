//
//  PartViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 20/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "PartViewCell.h"

@implementation PartViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _needView.layer.borderColor = [UIColor orangeColor].CGColor;
    _needView.layer.borderWidth = 2.0f;
    _stockView.layer.borderColor = [UIColor orangeColor].CGColor;
    _stockView.layer.borderWidth = 2.0f;
    _nameLabel.text = cellData[@"PartName"];
    [_needButton setTitle:cellData[@"Need"] forState:UIControlStateNormal];
    [_stockButton setTitle:cellData[@"Stock"] forState:UIControlStateNormal];
    [self fillStock:[_stockButton.titleLabel.text intValue]];
}

- (IBAction)lockPressed:(id)sender {
    if (!locked) {
        locked = true;
        [_lockButton setImage:[UIImage imageNamed:@"lock_close.png"] forState:UIControlStateNormal];
    }
    else {
        locked = false;
        [_lockButton setImage:[UIImage imageNamed:@"lock_open.png"] forState:UIControlStateNormal];
    }
}

- (void)fillPartView:(int)need {
    int totalNeed = [_needButton.titleLabel.text intValue];
    int fill = (40*need)/totalNeed;
    NSLog(@"fill=%d",fill);
    for (int i=40-fill; i < 40; ++i) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i, _needView.frame.size.width, 1)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [_needView addSubview:view];
    }
    [_needView bringSubviewToFront:_needButton];
}

- (void)fillStock:(int)need {
    int stock = [_stockButton.titleLabel.text intValue];
    
    int fill = (40*need)/stock;
    for (int i=40-fill; i < 40; ++i) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i, _needView.frame.size.width, 1)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [_stockView addSubview:view];
    }
    [_stockView bringSubviewToFront:_stockButton];
}

- (IBAction)stockPressed:(id)sender {
    int need = [_needButton.titleLabel.text intValue];
    int stock = [_stockButton.titleLabel.text intValue];
    if (stock >= need) {
        [self fillPartView:need];
        [self fillStock:stock-need];
    }
    else {
        int fill = 0;
        [self fillPartView:stock];
        [self fillStock:0];
    }
}

@end
