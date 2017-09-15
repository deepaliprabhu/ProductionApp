//
//  DefectsListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defect.h"

@interface DefectsListCell : UITableViewCell {
    IBOutlet UITextView *_textView;
    IBOutlet UIImageView *_typeImageView;
    
    Defect *defect;
}
- (void)setDefect:(Defect*)defect_;

@end
