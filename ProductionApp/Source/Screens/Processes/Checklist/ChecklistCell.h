//
//  ChecklistCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 12/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13Checkbox.h"
#import "Checklist.h"

@interface ChecklistCell : UITableViewCell {
    IBOutlet UITextView *checklistTextView;
}
- (void)setChecklistData:(Checklist*)checklist_;
@end
