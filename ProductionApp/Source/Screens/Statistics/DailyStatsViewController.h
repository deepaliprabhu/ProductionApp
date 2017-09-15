//
//  DailyStatsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"


@interface DailyStatsViewController : UIViewController<CKCalendarDelegate> {
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UIButton *_dateButton;
    IBOutlet UILabel *_qtyLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_stationTitleLabel;
    IBOutlet UIView *_stationDetailsView;
    IBOutlet UIView *_stationEntriesView;
    IBOutlet UIView *_tintView;
    
    NSMutableArray *processArray;
    NSMutableArray *operatorArray;
    NSMutableArray *stationsArray;
    NSMutableArray *operationsArray;
    int tag;
    NSDate *selectedDate;
    NSString *selectedDateString;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
-(void)setTag:(int)tag_;
- (void)setParseData:(NSMutableArray*)parseArray;
- (void)setDateString:(NSString*)dateString;

@end
