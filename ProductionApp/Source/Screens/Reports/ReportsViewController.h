//
//  ReportsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBFlatDatePicker.h"
#import "CKCalendarView.h"

@interface ReportsViewController : UIViewController<UIDocumentInteractionControllerDelegate, UITextFieldDelegate, CKCalendarDelegate, UIAlertViewDelegate> {
    UIDocumentInteractionController *documentInteractionController;
    IBOutlet UIButton *_dateButton;
    IBOutlet UITextField *_runIdTF;
    NSDate *selectedDate;
    int runId;
    NSMutableArray *parseRuns;
    NSMutableArray *checklistArray;
    NSMutableDictionary *runData;
    int runType;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end
