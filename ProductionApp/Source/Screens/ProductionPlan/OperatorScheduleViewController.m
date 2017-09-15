//
//  OperatorScheduleViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperatorScheduleViewController.h"
#import "DataManager.h"

@interface OperatorScheduleViewController ()

@end

@implementation OperatorScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Ram",@"Pranali", @"Raman", @"Lalu", @"Arvind", @"Sadashiv", @"Sonali",nil];
    scheduleArray = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
   // operationsArray = [__DataManager getThisWeekOperations];
    self.title = operatorArray[operatorIndex];
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    control = [[DZNSegmentedControl alloc] initWithItems:scheduleArray];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.selectedSegmentIndex = 0;
    control.frame = CGRectMake(0, 70, screenRect.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:control];
    self.scrollView.values = [self thisWeekArray];
    self.scrollView.delegate = self;
    self.scrollView.updateIndexWhileScrolling = NO;
    //[self initialiseCounts];
    //[self filterOperations];
    _entryView.layer.borderColor = [UIColor orangeColor].CGColor;
    _entryView.layer.borderWidth = 1.0;
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
    startDateString = [dateFormat stringFromDate:startOfTheWeek];
    endDateString = [dateFormat stringFromDate:endOfWeek];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
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
    
    NSLog(@"start date = %@, end date= %@",startDateString,endDateString);
    return weekArray;
}


- (void)setOperatorIndex:(int)index {
    operatorIndex = index;
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

- (void)initialiseCounts {
    for (int i=0; i < scheduleArray.count; ++i) {
        int count =0;
        for (int j=0; j < operationsArray.count; ++j) {
            NSMutableDictionary *operationData = operationsArray[j];
            if (([scheduleArray[i] isEqualToString:operationData[@"Schedule"]])&&([operatorArray[operatorIndex] isEqualToString:operationData[@"Operator"]])) {
                count++;
            }
        }
        [control setCount:[NSNumber numberWithInt:count] forSegmentAtIndex:i];
    }
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    
    [self filterOperations];
}

- (void)filterOperations {
    filteredArray = [[NSMutableArray alloc] init];
    NSString *selectedOperator = operatorArray[operatorIndex];
    for (int i=0; i < operationsArray.count; ++i) {
        NSMutableDictionary *operationData = operationsArray[i];
        if (([operationData[@"Operator"] isEqualToString:selectedOperator])&&([operationData[@"Schedule"] isEqualToString:scheduleArray[control.selectedSegmentIndex]])) {
            [filteredArray addObject:operationData];
        }
    }
    [control setCount:[NSNumber numberWithInt:filteredArray.count] forSegmentAtIndex:control.selectedSegmentIndex];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [operationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"OperatorScheduleViewCell";
    OperatorScheduleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:[operationsArray objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (void) updateStatus:(BOOL)value forIndex:(int)index {
    savingObject = operationsArray[index];
    if (value) {
        [self showEntryView];
        savingObject[@"Status"] = @"CLOSED";
    }
    else {
        savingObject[@"Status"] = @"OPEN";
        [savingObject save];
    }
}

- (void)showEntryView {
    _okayTF.text = savingObject[@"Quantity"];
    _entryView.frame = CGRectMake(self.view.frame.size.width/2-_entryView.frame.size.width/2, self.view.frame.size.height/2-_entryView.frame.size.height/2, _entryView.frame.size.width, _entryView.frame.size.height);
    [self.view addSubview:_entryView];
}

- (IBAction)cancelPressed:(id)sender {
    [_entryView removeFromSuperview];
}

- (IBAction)submitPressed:(id)sender {
    [_entryView removeFromSuperview];
    [savingObject save];
    //[self saveDailyDataInParse];
    [self updateRun];
}

- (void)saveDailyDataInParse {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    //here add elements to data file and write data to file
    PFObject *parseObject = [PFObject objectWithClassName:@"DailyRun"];
    parseObject[@"ProcessName"] = savingObject[@"Process"];
    parseObject[@"Operator"] = savingObject[@"Operator"];
    parseObject[@"Quantity"] = _okayTF.text;
    parseObject[@"ProductName"] = savingObject[@"ProductName"];
    parseObject[@"Rework"] = _reworkTF.text;
    parseObject[@"Reject"] = _rejectTF.text;
    parseObject[@"Station"] = savingObject[@"StationId"];
    parseObject[@"Date"] = dateString;
    parseObject[@"Time"] = savingObject[@"Time"];
    [parseObject save];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return true;
}

- (void)scrollView:(MVSelectorScrollView *)scrollView pageSelected:(NSInteger)pageSelected {
    
    //NSLog(@"%s scroll view %d, selected page: %d", __func__, scrollView.tag, pageSelected);
    [self getPlanForDate:[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex]];
}


- (void)getPlanForDate:(NSString*)dateString {
    operationsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"DateAssigned" equalTo:dateString];
    [query whereKey:@"OperatorName" equalTo:operatorArray[operatorIndex]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        operationsArray = [objects mutableCopy];
        [_tableView reloadData];
    }];
}

- (void)updateRun {
    Run *selectedRun = [__DataManager getRunWithId:[savingObject[@"RunId"] intValue]];
    NSMutableDictionary *runData = [selectedRun getRunData];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:runData[@"Qty"],@"Quantity", _reworkTF.text, @"Rework", _okayTF.text, @"InProcess", _rejectTF.text, @"Reject", runData[@"Shipped"], @"Shipped", runData[@"Status"], @"Status", runData[@"Process"], @"Process", runData[@"Shipping"], @"Shipping", nil];
    [selectedRun updateRunData:dictionary];
    [__DataManager syncRun:[selectedRun getRunId]];
}

@end
