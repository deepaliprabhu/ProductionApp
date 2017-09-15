//
//  JobListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "Defines.h"

@protocol JobListCellDelegate;
@interface JobListCell : UICollectionViewCell {
    IBOutlet UILabel *_jobIdLabel;
    IBOutlet UIView *_statusView;
    BOOL selected;
}
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
__pd(JobListCellDelegate);

- (void)setJobData:(Job*)job;
- (void)setSelected:(BOOL)selected;
- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender;
- (void)selectCell;
- (void)deselectCell;
- (BOOL)isCellSelected;
@end

@protocol JobListCellDelegate <NSObject>
- (void) setMultiMode:(BOOL)value;
@end