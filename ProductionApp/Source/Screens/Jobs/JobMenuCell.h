//
//  JobMenuCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 26/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol JobMenuCellDelegate;
@interface JobMenuCell : UICollectionViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_countLabel;
    IBOutlet UIImageView *_plusImageView;
    IBOutlet UIView *_colorView;
    BOOL selected;
}
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
__pd(JobMenuCellDelegate);

- (void)initCellWithTitle:(NSString*)title count:(int)count index:(int)index;
- (void)selectCell;
- (void)deselectCell;
- (BOOL)isCellSelected;
@end

@protocol JobMenuCellDelegate <NSObject>
- (void) setMultiMode:(BOOL)value;
@end