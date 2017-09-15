//
//  SearchViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "HistoryViewController.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = false;
    // Do any additional setup after loading the view from its nib.
    parseRuns = [[NSMutableArray alloc] init];
    NSArray *items = @[@"Week", @"Month", @"Year"];
    
    control = [[DZNSegmentedControl alloc] initWithItems:items];
    control.tintColor = [UIColor orangeColor];
   // control.delegate = self;
    control.selectedSegmentIndex = 1;
    control.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    self.scrollView.values = @[ @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec" ];
    self.scrollView.delegate = self;
    self.scrollView.updateIndexWhileScrolling = NO;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int month = [[dateFormat stringFromDate:[NSDate date]] intValue];
    [self.scrollView setSelectedIndex:month-1];
    
    [self fetchParseRuns];
}

- (void)scrollView:(MVSelectorScrollView *)scrollView pageSelected:(NSInteger)pageSelected {
    
    //NSLog(@"%s scroll view %d, selected page: %d", __func__, scrollView.tag, pageSelected);
    [self fetchParseRuns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchParseRuns {
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    parseRuns = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    PFQuery *query = [PFQuery queryWithClassName:@"ShipmentProducts"];
    
    switch (control.selectedSegmentIndex) {
        case 0: {

           // [query whereKey:@"Date" lessThan:endDate];
            [query whereKey:@"ShippingDate" equalTo:[[self thisWeekArray] objectAtIndex:self.scrollView.selectedIndex]];
        }
            break;
        case 1: {
            [dateFormat setDateFormat:@"yyyy"];
            NSString *selectedMonthString = [NSString stringWithFormat:@"%@ %@",[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex], [dateFormat stringFromDate:[NSDate date]]];
            NSLog(@"Selected Month string = %@",selectedMonthString);
            [query whereKey:@"ShippingDate" hasSuffix:selectedMonthString];
        }
            break;
        default: {
            NSLog(@"Selected year string = %@",[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex]);

            [query whereKey:@"ShippingDate" hasSuffix:[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex]];
        }

            break;
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [parseRuns addObjectsFromArray:objects];
        NSLog(@"parse runs = %@",parseRuns);
        [self.navigationController.view hideActivityView];
        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            [self filterData];
        }
        [self setTotalQuantity];
        [_tableView reloadData];
    }];
}

- (NSMutableArray*)thisWeekArray {
    NSMutableArray *weekArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    int startDate, endDate;

    [cal rangeOfUnit:NSWeekCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
    
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    startDate = [[dateFormat stringFromDate:startOfTheWeek] intValue];
    endDate = [[dateFormat stringFromDate:endOfWeek] intValue];
    [dateFormat setDateFormat:@"dd MMM yyyy"];

    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    NSComparisonResult startCompare = [startOfTheWeek compare: endOfWeek];
    int i=0;
    NSDate *weekDate;
    while((startCompare == NSOrderedAscending)&&(startCompare != NSOrderedSame)) {
        weekDate = [startOfTheWeek dateByAddingTimeInterval:24*60*60*i];
        [weekArray addObject:[dateFormat stringFromDate:weekDate]];
         startCompare = [weekDate compare: endOfWeek];
        NSLog(@"week array = %@",weekArray);
        i++;
    }
    
    NSLog(@"start date = %d, end date= %d",startDate,endDate);
    return weekArray;
}

- (void) filterData {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < [parseRuns count]; ++i) {
        PFObject *run = [parseRuns objectAtIndex:i];

        int j=0;
        for (j = 0; j < [filteredArray count]; ++j) {
            PFObject *object = [filteredArray objectAtIndex:j];
            if ([object[@"ProductName"] isEqualToString:run[@"ProductName"]]) {
                object[@"Quantity"] = [NSString stringWithFormat:@"%d", ([object[@"Quantity"] intValue]+[run[@"Quantity"] intValue])];
                break;
            }
        }
        if (j == filteredArray.count) {
            [filteredArray addObject:run];
        }
    }
    parseRuns = filteredArray;
}

- (void)setTotalQuantity {
    int quantity = 0;
    for (int i=0; i < [parseRuns count]; ++i) {
        PFObject *run = [parseRuns objectAtIndex:i];
        quantity = quantity + [run[@"Quantity"] intValue];
    }
    [control setCount:[NSNumber numberWithInt:quantity] forSegmentAtIndex:control.selectedSegmentIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [parseRuns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DailyStatsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject *run = [parseRuns objectAtIndex:indexPath.row];
    cell.textLabel.text = run[@"ProductName"];
    cell.detailTextLabel.text = run[@"Quantity"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    switch (control.selectedSegmentIndex) {
        case 0:
            self.scrollView.selectedIndex = [components day];
            self.scrollView.values = @[ @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
            [self.scrollView setSelectedIndex:[components day] animated:YES];

            break;
        case 1: {
            self.scrollView.values = @[ @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec" ];
            [self.scrollView setSelectedIndex:[components month] animated:YES];
        }
            break;
        case 2: {
            int year = [components year];
            NSLog(@"current year = %d",year);
            self.scrollView.values = @[ @"2015", @"2016", @"2017", @"2018", @"2019", @"2020"];
            self.scrollView.selectedIndex = [self.scrollView.values indexOfObject:[NSString stringWithFormat:@"%d",year]];
            NSLog(@"selected scroll index = %ld",(long)self.scrollView.selectedIndex);
            [self.scrollView setSelectedIndex: self.scrollView.selectedIndex animated:YES];
        }
            break;
        default:
            break;
    }
    [self fetchParseRuns];
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
