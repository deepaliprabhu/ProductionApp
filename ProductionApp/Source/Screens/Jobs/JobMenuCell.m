//
//  JobMenuCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 26/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "JobMenuCell.h"

@implementation JobMenuCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.borderColor = [UIColor colorWithRed:200.0f/255 green:200.0f/255 blue:200.0f/255 alpha:0.7].CGColor;
    self.layer.borderWidth = 1;
}

- (void)selectCell {
    selected = true;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 2;
}

- (void)deselectCell {
    selected = false;
    self.layer.borderColor = [UIColor colorWithRed:200.0f/255 green:200.0f/255 blue:200.0f/255 alpha:0.7].CGColor;
    self.layer.borderWidth = 1;
}

- (BOOL)isCellSelected {
    return selected;
}

- (void)initCellWithTitle:(NSString*)title count:(int)count index:(int)index {
    if (index == 0) {
        _plusImageView.hidden = false;
    }
    else {
        _plusImageView.hidden = true;
        _titleLabel.text = title;
        _countLabel.text = [NSString stringWithFormat:@"%d",count];
        switch (index) {
            case 1:
                _colorView.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:191.0f/255.0f blue:59.0f/255.0f alpha:0.7];
                break;
            case 2:
                _colorView.backgroundColor = [UIColor colorWithRed:63.0f/255 green:195.0f/255 blue:128.0f/255 alpha:1];
                break;
            case 3:
                _colorView.backgroundColor = [UIColor colorWithRed:189.0f/255 green:195.0f/255 blue:199.0f/255 alpha:1];
                break;
            case 4:
                _colorView.backgroundColor = [UIColor colorWithRed:129.0f/255 green:207.0f/255 blue:224.0f/255 alpha:1];
                break;
            case 5:
                _colorView.backgroundColor = [UIColor colorWithRed:231.0f/255 green:76.0f/255 blue:60.0f/255 alpha:1];
                break;
            default:
               _colorView.backgroundColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
                break;
        }
        if (index > 5) {
            self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
            self.lpgr.minimumPressDuration = 1.0f;
            self.lpgr.allowableMovement = 100.0f;
            [self addGestureRecognizer:self.lpgr];
        }
    }
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self selectCell];
        [_delegate setMultiMode:true];
    }
}
@end
