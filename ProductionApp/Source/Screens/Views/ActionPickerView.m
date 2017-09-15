//
//  ActionListView.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "ActionPickerView.h"
@implementation ActionPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initViewWithArray:(NSMutableArray*)actionArray_ andTag:(int)tag_{
    actionArray = actionArray_;
    tag = tag_;
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Select Action" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    [picker show];
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return actionArray[row];
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return actionArray.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    [_delegate selectedActionIndex:row withTag:tag];
}

-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows{
    for(NSNumber *n in rows){
        NSInteger row = [n integerValue];
    }
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    NSLog(@"Canceled.");
}


@end

