//
//  DailyListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "DailyListViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "Utilities.h"


@interface DailyListViewController ()

@end

@implementation DailyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Daily Log";
    _cellDetailView.layer.borderColor = [UIColor orangeColor].CGColor;
    _cellDetailView.layer.borderWidth = 1.0f;
    _cellDetailView.layer.cornerRadius = 10.0f;
    parseRuns = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    [_dateButton setTitle:[dateFormat1 stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [self fetchParseRuns];
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

- (void)fetchParseRuns {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat1 dateFromString:_dateButton.titleLabel.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];
    parseRuns = [[NSMutableArray alloc] init];

    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
    /*if (![Utilities isNetworkReachable]) {
        [query fromLocalDatastore];
    }
    else{
        [PFObject unpinAllObjects];
    }*/

    NSLog(@"Date selected :%@", [dateFormat stringFromDate:date]);
    [query whereKey:@"Date" equalTo:[dateFormat stringFromDate:date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        //[PFObject pinAllInBackground:objects];
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [parseRuns addObjectsFromArray:objects];
        NSLog(@"parse runs = %@",parseRuns);
        [self.navigationController.view hideActivityView];

        [_tableView reloadData];
        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [parseRuns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DailyListCell";
    DailyListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    PFObject *run = [parseRuns objectAtIndex:indexPath.row];
    [cell setCellData:run];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *cellData = [parseRuns objectAtIndex:indexPath.row];
    _cellDetailView.hidden = false;
    _tintedView.hidden = false;
    _titleLabel.text = [NSString stringWithFormat:@"%@:%@",[cellData objectForKey:@"RunId"], [cellData objectForKey:@"ProductName"]];

    _processLabel.text = cellData[@"ProcessName"];
    _rejectLabel.text = cellData[@"Reject"];
    _reworkLabel.text = cellData[@"Rework"];
    _quantityLabel.text = cellData[@"Quantity"];
}

- (IBAction)closeDetailView:(id)sender {
    _cellDetailView.hidden = true;
    _tintedView.hidden = true;
}

- (void) reloadData {
    [self fetchParseRuns];
}

- (IBAction)dateButtonPressed:(id)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd MMM yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20 Jan 2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
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
    [self performSelector:@selector(fetchParseRuns) withObject:nil afterDelay:1];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
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
