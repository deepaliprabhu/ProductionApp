//
//  ActionListView.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZPicker.h"
#import "Defines.h"

@protocol ActionPickerDelegate;
@interface ActionPickerView : UIView<CZPickerViewDataSource,CZPickerViewDelegate> {
    NSMutableArray *actionArray;
    int tag;
}
__pd(ActionPickerDelegate);
- (void)initViewWithArray:(NSMutableArray*)actionArray_ andTag:(int)tag_;
@end

@protocol ActionPickerDelegate <NSObject>
- (void) selectedActionIndex:(int)index withTag:(int)tag_;

@end
