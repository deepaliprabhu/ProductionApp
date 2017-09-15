//
//  ShipmentViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CKCalendarView.h"
#import "UIView+RNActivityView.h"
#import "ParseDataManager.h"
#import "ConnectionManager.h"
#import "DZNSegmentedControl.h"



//#import "THDatePickerViewController.h"


@interface ShipmentViewController : UIViewController<NIDropDownDelegate, CKCalendarDelegate, UITextFieldDelegate, ParseDataManagerProtocol, ConnectionProtocol> {
    IBOutlet NIDropDown *dropDown;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_transferIdTitleLabel;
    IBOutlet UILabel *_locationTitleLabel;
    IBOutlet UIButton *_productButton;
    IBOutlet UIButton *_transferIdButton;
    IBOutlet UIButton *_locationButton;
    IBOutlet UIButton *_dateButton;
    IBOutlet UITextField *_quantityTF;
    IBOutlet UITextField *_trackingIdTF;
    IBOutlet UIScrollView *_productsScrollView;
    IBOutlet UITextField *_quantityTextfield;
    NSMutableArray *productArray;
    NSMutableArray *locationArray;
    NSMutableArray *partsTransferArray;
    NSMutableArray *transferIdArray;
    NSMutableArray *partDetailsArray;
    
    DZNSegmentedControl *control;
    int selectedListIndex;
    int selectedTag;
    int selectedSegment;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end
