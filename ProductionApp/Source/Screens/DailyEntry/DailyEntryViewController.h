//
//  DailyEntryViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CKCalendarView.h"
#import "ParseDataManager.h"


@interface DailyEntryViewController : UIViewController<NIDropDownDelegate, CKCalendarDelegate, UITextFieldDelegate, ParseDataManagerProtocol> {
    IBOutlet UILabel *_totalTimeLabel;
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UITextField *_okayTF;
    IBOutlet UITextField *_reworkTF;
    IBOutlet UITextField *_rejectTF;
    IBOutlet UITextField *_processTF;
    IBOutlet UITextField *_timeTF;
    IBOutlet UIButton *_dateButton;
    IBOutlet UIButton *_operatorButton;
    IBOutlet UIButton *_processButton;
    IBOutlet UIButton *_productButton;
    IBOutlet UIImageView *_photoImageView;
    IBOutlet UIView *_customEntryView;
    IBOutlet UIView *_tintView;
    
    NSMutableArray *processArray;
    NSMutableArray *operatorArray;
    NSMutableArray *productArray;
    NSMutableArray *stationsArray;
    NSMutableArray *stationProcesses;
    IBOutlet NIDropDown *dropDown;
    
    NSDictionary *selectedProcessData;
    NSMutableDictionary*productData;
    NSString *productId;
    int stationId;
    int selectedTag;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;

- (void)setStation:(int)stationId;
- (void)setProduct:(NSMutableDictionary*)productData;
@end
