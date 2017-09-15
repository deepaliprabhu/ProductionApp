//
//  LoginViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 10/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "DownPicker.h"
#import "VisibleFormViewController.h"
#import "NIDropDown.h"
#import "SBFlatDatePicker.h"
#import "CKCalendarView.h"

@interface LoginViewController : VisibleFormViewController<ConnectionProtocol, UITextFieldDelegate, NIDropDownDelegate, SBFLatDatePickerDelegate, CKCalendarDelegate> {
    IBOutlet UITextField *_usernameTF;
    IBOutlet UITextField *_passwordTF;
    IBOutlet UIButton *_confirmButton;
    IBOutlet NIDropDown *dropDown;
    IBOutlet UIButton *_dateButton;
    IBOutlet UIButton *_roleButton;
    NSString *selectedRole;
    NSString *selectedDate;
    NSMutableArray *roleArray;
}
@property (strong, nonatomic) DownPicker *downPicker;
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end
