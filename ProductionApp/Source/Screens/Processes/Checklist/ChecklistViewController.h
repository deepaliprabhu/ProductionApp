//
//  ChecklistViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 12/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChecklistCell.h"
#import "Defines.h"
#import "BaseViewController.h"

@protocol ChecklistDelegate;
@interface ChecklistViewController : BaseViewController {
    IBOutlet UITableView *_tableView;
}
__pd(ChecklistDelegate);
@end

@protocol ChecklistDelegate <NSObject>
- (void)checklistDone;
@end