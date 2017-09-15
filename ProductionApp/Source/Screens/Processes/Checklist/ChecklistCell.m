//
//  ChecklistCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 12/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "ChecklistCell.h"

@implementation ChecklistCell

- (void)awakeFromNib {
    // Initialization code
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    M13Checkbox *checkbox = [[M13Checkbox alloc] init];
    checkbox.checkColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    checkbox.strokeColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];

    checkbox.frame = CGRectMake(screenRect.size.width -30, screenRect.origin.y+15, 35, 35);
    //[allDefaults addTarget:self action:@selector(checkChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:checkbox];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChecklistData:(Checklist*)checklist {
    checklistTextView.text = [checklist getChecklistText];
}

@end
