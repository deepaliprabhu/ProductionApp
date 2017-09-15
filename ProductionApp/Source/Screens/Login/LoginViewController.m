//
//  LoginViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 10/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "LoginViewController.h"
#import "RunsListViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import "ReportsViewController.h"
#import "DashboardViewController.h"
#import "ShipmentViewController.h"
#import "DailyEntryViewController.h"
#import "DailyStatsViewController.h"
#import "ProductSelectionViewController.h"
#import "ProductionPlanViewController.h"
#import "ChecklistGenViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    roleArray = [NSMutableArray arrayWithObjects:@"Data Entry", @"Guest", @"Daily Entry", @"Production Plan", @"Checklist Generator",nil];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"Username"]) {
        _usernameTF.text = [userDefaults stringForKey:@"Username"];
        _passwordTF.text = [userDefaults stringForKey:@"Password"];
    }
    else {
        _usernameTF.text = @"admin";
        _passwordTF.text = @"pass";
    }
    self.lastVisibleView = _confirmButton;
    selectedRole = [userDefaults valueForKey:@"SelectedRole"];
    
    if (!selectedRole) {
        selectedRole = @"Guest";
    }
    [_roleButton setTitle:selectedRole forState:UIControlStateNormal];

}

-(void)dropDownSelected {
    //NSString* selectedValue = [downPicker text];
    // do what you want
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString*)MD5:(NSString*)string
{
    // Create pointer to the string as UTF8
    const char *ptr = [string UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    NSLog(@"password = %@",output);
    
    return output;
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (IBAction)loginPressed: (id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:selectedRole forKey:@"SelectedRole"];
    [userDefaults synchronize];
    if (!selectedRole) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please pick a role to continue" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    /*if (!selectedDate) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please pick a date to continue" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        return;
    }*/
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSTimeInterval interval = [today timeIntervalSince1970];
    [__User setUsername:_usernameTF.text];
    [__User setLoginTime:interval];
    [__User setRole:selectedRole];
    [__User setDateString:[dateFormat stringFromDate:[NSDate date]]];

    if ([selectedRole isEqualToString:@"Guest"]) {
        DashboardViewController *dashboardVC = [DashboardViewController new];
        [self.navigationController pushViewController:dashboardVC animated:true];
    }
    else if ([selectedRole isEqualToString:@"Shipment"]) {
        ShipmentViewController *shipmentVC = [ShipmentViewController new];
        [self.navigationController pushViewController:shipmentVC animated:true];
    }
    else if ([selectedRole isEqualToString:@"Daily Entry"]) {
        ProductSelectionViewController *productionSelectionVC = [ProductSelectionViewController new];
        //DailyStatsViewController *dailyStatsVC = [DailyStatsViewController new];
        //[dailyStatsVC setTag:1];
        [self.navigationController pushViewController:productionSelectionVC animated:true];
    }
    else if ([selectedRole isEqualToString:@"Production Plan"]) {
        ProductionPlanViewController *productionSelectionVC = [ProductionPlanViewController new];
        [self.navigationController pushViewController:productionSelectionVC animated:true];
    }
    else if ([selectedRole isEqualToString:@"Checklist Generator"]) {
        ChecklistGenViewController *checklistGenVC = [ChecklistGenViewController new];
        [self.navigationController pushViewController:checklistGenVC animated:true];
    }
    else {
        RunsListViewController *runListVC = [[RunsListViewController alloc] initWithNibName:@"RunsListViewController" bundle:nil];
        [self.navigationController pushViewController:runListVC animated:true];
    }
}

- (IBAction)pickDatePressed:(UIButton*)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd MMM yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"01 Jan 2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
    //[self showDatePickerWithTag:0];
}

- (IBAction)pickRolePressed:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :roleArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    dropDown = nil;
    selectedRole = roleArray[index];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (void) parseJsonResponse:(NSData*)jsonData {
    NSError* error;
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        // [self displaySuccess];
        
        NSLog(@"json is Array class");
        for (NSDictionary *dictionary in json) {
         int val =[[dictionary objectForKey:@"result"] intValue];
            if (val == 1) {
                NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
                 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                 [dateFormat setDateFormat:@"dd MMM yyyy, hh:mma"];
                 NSTimeInterval interval = [today timeIntervalSince1970];
                 [__User setUsername:_usernameTF.text];
                 [__User setLoginTime:interval];
                [__User setRole:selectedRole];
                [__User setDateString:_dateButton.titleLabel.text];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_usernameTF.text forKey:@"Username"];
                [userDefaults setObject:_passwordTF.text forKey:@"Password"];
                [userDefaults synchronize];
                 RunsListViewController *runListVC = [[RunsListViewController alloc] initWithNibName:@"RunsListViewController" bundle:nil];
                 [self.navigationController pushViewController:runListVC animated:true];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid Username/Password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
            }
         
         }
    }
}

- (IBAction)signUpPressed: (id)sender{
    SignUpViewController *signUpVC = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:true];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

// UITextfieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    if ([textField isEqual:_usernameTF]) {
        [_passwordTF becomeFirstResponder];
    }
    else {
        [_passwordTF resignFirstResponder];
    }
    return YES;
}


- (void)showDatePickerWithTag:(int)tag_ {
    NSLog(@"showing date picker");
    
    //Init the datePicker view and set self as delegate
    SBFlatDatePicker *datePicker = [[SBFlatDatePicker alloc] initWithFrame:self.view.bounds];
    [datePicker setDelegate:self];
    datePicker.tag = tag_;
    
    //OPTIONAL: Choose the background color
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    
    //OPTIONAL - Choose Date Range (0 starts At Today. Non continous sets acceptable (use some enumartion for [indexSet addIndex:yourIndex];
    datePicker.dayRange = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 365)];
    
    
    //OPTIONAL - Choose Minute  Non continous sets acceptable (use some enumartion for [indexSet addIndex:yourIndex];
    datePicker.minuterange = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 59)];
    
    //Customize date format
    datePicker.dayFormat = @"EEE MMM dd yyyy";
    
    
    //Set the data picker as view of the new view controller
    [self.view addSubview:datePicker];
    
    //Present the view controller
    //[self presentViewController:pickerViewController animated:YES completion:nil];
}

//Delegate
-(void)flatDatePicker:(SBFlatDatePicker *)datePicker saveDate:(NSDate *)date{
    NSLog(@"%@",[date description]);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy, hh:mma"];
    selectedDate = [dateFormat stringFromDate:date];
    _dateButton.titleLabel.text = selectedDate;
    //_dateButton.titleLabel.frame = CGRectMake(_dateButton.titleLabel.frame.origin.x, _dateButton.titleLabel.frame.origin.y, _dateButton.titleLabel.frame.size.width*2, _dateButton.titleLabel.frame.size.height);
}


#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    // dateItem.backgroundColor = [UIColor redColor];
    // dateItem.textColor = [UIColor whiteColor];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return true;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    selectedDate = dateString;
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
       // self.calendar.backgroundColor = [UIColor orangeColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


@end
