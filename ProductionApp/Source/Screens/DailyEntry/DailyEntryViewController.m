//
//  DailyEntryViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "DailyEntryViewController.h"
#import <Parse/Parse.h>
#import "Station.h"
#import "UIView+RNActivityView.h"
#import "DailyListViewController.h"

@interface DailyEntryViewController ()

@end

@implementation DailyEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Ram",@"Pranali", @"Raman", @"Lalu", @"Sonali", @"Sumit", @"Sadashiv",nil];
    stationsArray = [NSMutableArray arrayWithObjects:@"1-Inward Testing", @"2-Soldering",@"3-Mechanical Assembly",@"4-Final Inspection", @"5-Cleaning & Packaging", @"6-Moulding", @"7-Other",nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"Products" ofType:@"plist"];
    
    self.title = @"Daily Entry";
    // Build the array from the plist
    productArray = [[NSMutableArray alloc] initWithContentsOfFile:path];

    [_operatorButton setTitle:operatorArray[0] forState:UIControlStateNormal];
   // [_processButton setTitle:processArray[0] forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    [_dateButton setTitle:[dateFormat1 stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    //[self getStationProcesses];
    _productNameLabel.text = productData[@"Name"];
    _photoImageView.image = [UIImage imageNamed:productData[@"Photo"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStation:(int)stationId_ {
    stationId = stationId_;
}

- (void)setProduct:(NSMutableDictionary*)productData_ {
    productData = productData_;
    productId = productData[@"Id"];
}

- (void)getStationProcesses {
    processArray = [[NSMutableArray alloc] init];
    stationProcesses = [[NSMutableArray alloc] init];
    if ([productId isEqualToString:@"Other"]) {
         NSString *path = [[NSBundle mainBundle] pathForResource:
         @"Station_Processes" ofType:@"plist"];
         
         NSMutableArray *stationsArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] mutableCopy];
         NSMutableDictionary *stationData = stationsArray[stationId-1];
         NSMutableArray *processesArray = stationData[@"Processes"];
         for (int i=0; i < processesArray.count; ++i) {
         NSMutableDictionary *processData = processesArray[i];
         [processArray addObject:processData[@"Name"]];
         }
         NSLog(@"processesArray = %@",processArray);
         stationProcesses = stationData[@"Processes"];
    }
    else {
        NSString *filename = [NSString stringWithFormat:@"%@_Processes",productId];
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          filename ofType:@"plist"];
        NSMutableArray *processesArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] mutableCopy];
        for (int i=0; i<processesArray.count; ++i) {
            NSMutableDictionary *processData = processesArray[i];
            if ([processData[@"stationId"] intValue] == stationId) {
                [processArray addObject:processData[@"name"]];
                [stationProcesses addObject:processData];
            }
        }
    }
    NSLog(@"stationProcesses = %@",stationProcesses);
    [processArray addObject:@"Other"];
}

- (void)getParseStationProcesses {
    [self.navigationController.view showActivityViewWithLabel:@"fetching station processes"];
    [self.navigationController.view hideActivityViewWithAfterDelay:30];
    processArray = [[NSMutableArray alloc] init];
    stationProcesses = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"StationProcesses"];
    [query whereKey:@"StationId" equalTo:[NSString stringWithFormat:@"%d",stationId]];
    NSArray *objects = [query findObjects];
    //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    int j=0;
    NSLog(@"objects count = %lu",(unsigned long)[objects count]);
    for (j=0; j < [objects count]; ++j) {
        PFObject *parseObject = [objects objectAtIndex:j];
        [processArray addObject:parseObject[@"ProcessName"]];
        [stationProcesses addObject:parseObject];
    }
    [processArray addObject:@"Other"];
    [self.navigationController.view hideActivityView];
}


- (void)addProcessToStation {
    PFObject *parseObject = [PFObject objectWithClassName:@"StationProcesses"];
    parseObject[@"StationId"] = [NSString stringWithFormat:@"%d",stationId];
    parseObject[@"ProcessName"] = _processTF.text;
    parseObject[@"Time"] = _timeTF.text;
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving Data! Please Try Again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
    }];

}


- (IBAction)processButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        _tintView.hidden = false;
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :processArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 3;
        selectedTag = 3;
        dropDown.delegate = self;
    }
    else {
        _tintView.hidden = true;
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) receivedParseData {
   // [self.navigationController.view hideActivityView];
}

- (IBAction)productButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        _tintView.hidden = false;
        CGFloat f = 195;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :productArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        _tintView.hidden = true;
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)stationButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        _tintView.hidden = false;
        CGFloat f = 230;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :stationsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 1;
        selectedTag = 1;
        dropDown.delegate = self;
    }
    else {
        _tintView.hidden = true;
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)operatorButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        _tintView.hidden = false;
        CGFloat f = 195;
        dropDown.tag = 2;
        selectedTag = 2;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :operatorArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        _tintView.hidden = true;
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    switch (selectedTag) {
        case 1:{
            stationId = index+1;
            if ([_productNameLabel.text isEqualToString:@"Other"]) {
                [self getParseStationProcesses];
            }
            else
                [self getStationProcesses];
            _processButton.enabled = true;
            [_processButton setTitle:@"Pick Process" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            _okayTF.text = @"";
            _reworkTF.text = @"";
            _rejectTF.text = @"";
            _totalTimeLabel.text = @"";
            if (index == processArray.count-1) {
                _customEntryView.frame = CGRectMake(self.view.frame.size.width/2-_customEntryView.frame.size.width/2, 150, _customEntryView.frame.size.width, _customEntryView.frame.size.height);
                [self.view addSubview:_customEntryView];
                _tintView.hidden = false;
            }
            else {
                selectedProcessData = stationProcesses[index];
                NSLog(@"selectedProcessData=%@",selectedProcessData);
            }
        }
            break;
        default:
            break;
    }
    dropDown = nil;
    _tintView.hidden = true;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (IBAction)cancelButtonPressed:(UIButton*)sender {
    _tintView.hidden = true;
    [_customEntryView removeFromSuperview];
}

- (IBAction)saveButtonPressed:(UIButton*)sender {
    selectedProcessData = [[NSMutableDictionary alloc] init];
    [selectedProcessData setValue:_processTF.text forKey:@"name"];
    [selectedProcessData setValue:_timeTF.text forKey:@"Time"];
    NSLog(@"selectedProcessData=%@",selectedProcessData);
    [self addProcessToStation];
    [_processButton setTitle:_processTF.text forState:UIControlStateNormal];
    _tintView.hidden = true;
    [_customEntryView removeFromSuperview];
}

- (IBAction)dateButtonPressed:(UIButton*)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    [self.view addSubview:self.dateLabel];
}

- (IBAction)viewEntriesPressed {
    DailyListViewController *dailyListVC = [DailyListViewController new];
    [self.navigationController pushViewController:dailyListVC animated:NO];
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
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        //self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (IBAction)submitButtonPressed:(id)sender {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_okayTF.text,@"Okay", _reworkTF.text, @"Rework", _rejectTF.text, @"Reject", _operatorButton.titleLabel.text, @"Operator", _processButton.titleLabel.text, @"Process", _productNameLabel.text, @"Product", nil];
    
    [self saveDailyDataInParse:dictionary];
    [self saveDailyStatsInParse];
}

- (void)saveDailyDataInParse:(NSDictionary*)processData {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat1 dateFromString:_dateButton.titleLabel.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //here add elements to data file and write data to file
            PFObject *parseObject = [PFObject objectWithClassName:@"DailyRun"];
             parseObject[@"ProcessName"] = [processData objectForKey:@"Process"];
            parseObject[@"Operator"] = [processData objectForKey:@"Operator"];
            parseObject[@"Quantity"] = [processData objectForKey:@"Okay"];
            parseObject[@"ProductName"] = [processData objectForKey:@"Product"];
            parseObject[@"Rework"] = [processData objectForKey:@"Rework"];
            parseObject[@"Reject"] = [processData objectForKey:@"Reject"];
            parseObject[@"Station"] = [NSString stringWithFormat:@"%d",stationId];
            parseObject[@"Date"] = dateString;
            parseObject[@"Time"] = _totalTimeLabel.text;
            NSLog(@"saving parse object = %@",parseObject);
            [__ParseDataManager setDelegate:self];
            [__ParseDataManager saveParseData:parseObject];
}

- (void)saveDailyStatsInParse {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat1 dateFromString:_dateButton.titleLabel.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //here add elements to data file and write data to file
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyStats"];
    [query whereKey:@"Date" equalTo:dateString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        /*if (objects.count > 0) {
         [PFObject pinAllInBackground:objects];
         }*/
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseObject = [objects objectAtIndex:i];
                parseObject[@"TotalQuantity"] = [NSString stringWithFormat:@"%d",[parseObject[@"TotalQuantity"] intValue]+[_okayTF.text intValue]];
                parseObject[@"TotalTime"] = [NSString stringWithFormat:@"%d",[parseObject[@"TotalTime"] intValue]+[_totalTimeLabel.text intValue]];
                parseObject[@"TotalOperations"] = [NSString stringWithFormat:@"%d",[parseObject[@"TotalOperations"] intValue]+1];
                [__ParseDataManager setDelegate:self];
                [__ParseDataManager saveParseData:parseObject];
                //[parseObject saveInBackground];
                break;
         }
        if (i == [objects count]) {
            PFObject *parseObject = [PFObject objectWithClassName:@"DailyStats"];
            parseObject[@"TotalQuantity"] = _okayTF.text;
            parseObject[@"TotalTime"] = _totalTimeLabel.text;
            parseObject[@"Date"] = dateString;
            NSLog(@"saving parse object = %@",parseObject);
            [__ParseDataManager setDelegate:self];
            [__ParseDataManager saveParseData:parseObject];
            //[parseObject saveInBackground];
        }
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    if (selectedProcessData[@"Time"]) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%.0f",[_okayTF.text intValue]*[selectedProcessData[@"Time"] floatValue]];
    }
    else {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%.0f",[_okayTF.text intValue]*[selectedProcessData[@"time"] floatValue]];
    }
    return YES;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    self.view.transform = CGAffineTransformMakeTranslation(0, -50);
}

- (void)keyboardDidHide: (NSNotification *) notif{
    if (self.view.frame.origin.y < 0) {
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _tintView.hidden = true;
        [dropDown hideDropDown:_processButton];
        dropDown = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
