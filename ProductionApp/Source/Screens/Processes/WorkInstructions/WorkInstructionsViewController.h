//
//  WorkInstructionsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkInstructionCell.h"
#import "Defines.h"
#import "BaseViewController.h"

@protocol WorkInstructionsDelegate;
@interface WorkInstructionsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, WorkInstructionsCellDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_imagePopupView;
    IBOutlet UIImageView *_imageView;
    
    UIView *backgroundDimmingView;
    NSMutableArray *instructions;
}
__pd(WorkInstructionsDelegate);
- (void)setInstructions:(NSMutableArray*)instructions_;
@end

@protocol WorkInstructionsDelegate <NSObject>
- (void)workInstructionsDone;
@end