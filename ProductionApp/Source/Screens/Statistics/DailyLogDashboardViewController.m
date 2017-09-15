//
//  DailyLogDashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "DailyLogDashboardViewController.h"
#import "DailyStatsViewController.h"
#import "OperatorLogViewController.h"
#import "OperationsLogViewController.h"
#import "DailyEntryHistoryViewController.h"
#import "UIView+RNActivityView.h"
#import <Parse/Parse.h>

@interface DailyLogDashboardViewController ()

@end

@implementation DailyLogDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    logsArray = @[@"Daily Station Log ",@"Daily Operator Log",@"Daily Operations Log", @"Daily History"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    [_dateButton setTitle:[dateFormat stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    selectedDate = [NSDate date];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    [self getParseDailyData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getParseDailyData {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];
    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
    
    NSLog(@"Date selected :%@", [dateFormat stringFromDate:selectedDate]);
    [query whereKey:@"Date" equalTo:[dateFormat stringFromDate:selectedDate]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        //[PFObject pinAllInBackground:objects];
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        operationsArray = [objects mutableCopy];
        [self analyseData:[objects mutableCopy]];
        [self.navigationController.view hideActivityView];
    }];
}

- (void)analyseData:(NSMutableArray*)parseDataArray {
    int totalQty = 0;
    int totalTime = 0;
    int totalOperations =0;
    for (int j=0; j < [parseDataArray count]; ++j) {
        NSMutableDictionary *parseData = parseDataArray[j];
        totalQty = totalQty+[parseData[@"Quantity"] intValue];
        totalTime = totalTime + [parseData[@"Time"] intValue];
        totalOperations = totalOperations+1;
    }
    _quantityLabel.text = [NSString stringWithFormat:@"%d",totalQty];
    _hoursLabel.text = [NSString stringWithFormat:@"%.1f",(float)totalTime/60];
    _operationsLabel.text = [NSString stringWithFormat:@"%d",totalOperations];

}

- (IBAction)dateButtonPressed:(UIButton*)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    [self.view addSubview:self.dateLabel];
}

- (IBAction)todayPressed:(UIButton*)sender {
    selectedDate = [NSDate date];
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
    [self getParseDailyData];
}

- (IBAction)yesterdayPressed:(UIButton*)sender {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    selectedDate = yesterday;
    NSString *dateString = [self.dateFormatter stringFromDate:yesterday];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
    [self getParseDailyData];
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
    selectedDate = date;
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
    [self getParseDailyData];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [logsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = logsArray[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:selectedDate];
    switch (indexPath.row) {
        case 0: {
            DailyStatsViewController *dailyStats = [DailyStatsViewController new];
            [dailyStats setTag:2];
            [dailyStats setParseData:operationsArray];
            [dailyStats setDateString:dateString];
            [self.navigationController pushViewController:dailyStats animated:NO];
        }
            break;
        case 1: {
            OperatorLogViewController *operatorLogVC = [OperatorLogViewController new];
            [operatorLogVC setParseData:operationsArray];
            [operatorLogVC setDateString:dateString];
            [self.navigationController pushViewController:operatorLogVC animated:NO];
        }
            break;
        case 2: {
            OperationsLogViewController *operatorLogVC = [OperationsLogViewController new];
            [operatorLogVC setParseData:operationsArray];
            [operatorLogVC setDateString:dateString];
            [self.navigationController pushViewController:operatorLogVC animated:NO];
        }
            break;
        case 3: {
            DailyEntryHistoryViewController *historyVC= [DailyEntryHistoryViewController new];
            [self.navigationController pushViewController:historyVC animated:NO];
        }
            break;

        default:
            break;
    }

}


@end
