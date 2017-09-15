//
//  DemandListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "DemandListViewController.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "RunDetailsViewController.h"
#import "DataManager.h"
#import "TaskListViewController.h"

@interface DemandListViewController ()

@end

@implementation DemandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Demands";
    _detailView.layer.cornerRadius = 8.0f;
    _shippingEntryView.layer.cornerRadius = 6.0f;
    _shippingEntryView.layer.borderWidth = 1.0f;
    _shippingEntryView.layer.borderColor = [UIColor orangeColor].CGColor;
    productsArray = [[NSMutableArray alloc] init];
    filteredArray = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = false;

   // productsArray = @[@"iCelsius Pro(LT)", @"iCelsius Wireless Comm Unit", @"Wireless RH(connector)", @"Wireless RH(probe)", @"Wireless BBQ probe(dual)", @"Sentinel Next RTD connector", @"Sentinel Next", @"Sentinel Next with Display", @"Sentinel Next RTD", @"iCelsius Blue Pro", @"iCelsius Blue T/RH", @"BBQ Clamp"];

    
    quantityArray = @[@"100", @"100", @"180", @"10", @"100", @"160", @"200", @"550", @"107", @"180", @"90", @"100"];
    
    NSArray *items = @[@"All",@"Immediate", @"Mason", @"Other"];
    
    control = [[DZNSegmentedControl alloc] initWithItems:items];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.frame = CGRectMake(0, 75, self.view.bounds.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    dateActions = [@[@"--", @"Next Week", @"Shipped", @"Pick a date"] mutableCopy];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPressed)];
    self.navigationItem.rightBarButtonItem = rightbtn;
   // [self getDemands];
    productsArray = [__DataManager getDemandList];
    [control setCount:[NSNumber numberWithInt:productsArray.count] forSegmentAtIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = false;
    tasksArray = [__DataManager getTaskList];
    if (!tasksArray) {
        [self getTasks];
    }
    else {
        [_taskButton setBadgeEdgeInsets:UIEdgeInsetsMake(25, 0, 3, 18)];
        [_taskButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)tasksArray.count]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) selectedExpectedShippingWithTag:(int)tag {
    if (filtered) {
        selectedDemand = filteredArray[tag];
    }
    else
        selectedDemand = productsArray[tag];
    selectedTag = tag;
    runsArray = [[NSMutableArray alloc] init];
    NSString *runString = selectedDemand[@"Runs"];
    if (![runString isEqualToString:@""]) {
        NSArray *components = [runString componentsSeparatedByString:@","];
        runsArray = [components mutableCopy];
    }
   /* ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
    [actionPickerView initViewWithArray:dateActions andTag:tag];
    actionPickerView.delegate = self;
    actionPickerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:actionPickerView];
    selectedActionTag = 1;*/
    _shippingEntryTitleLabel.text = selectedDemand[@"Product"];
    _countTextField.text = @"";
    [_pickRunButton setTitle:@"Pick Run" forState:UIControlStateNormal];
    [_pickShippingButton setTitle:@"Pick Shipping" forState:UIControlStateNormal];
    _shippingEntryView.frame = CGRectMake(self.view.frame.size.width/2-_shippingEntryView.frame.size.width/2, self.view.frame.size.height/2-_shippingEntryView.frame.size.height/2-80, _shippingEntryView.frame.size.width, _shippingEntryView.frame.size.height);
    [self.view addSubview:_shippingEntryView];
    _tintedView.hidden = false;
}

- (void) selectedRunButtonWithTag:(int)tag {
    /*NSMutableDictionary *demandData = productsArray[tag];
    RunDetailsViewController *runDetailsVC = [[RunDetailsViewController alloc] initWithNibName:@"RunDetailsViewController" bundle:nil];
    [runDetailsVC setRun:[__DataManager getRunWithId:[demandData[@"Runs"] intValue]]];
    [runDetailsVC setRunData:[__DataManager getParseRunForId:[demandData[@"Runs"] intValue]]];
    [self.navigationController pushViewController:runDetailsVC animated:true];*/
    if (filtered) {
        selectedDemand = filteredArray[tag];
    }
    else
        selectedDemand = productsArray[tag];
    runsArray = [[NSMutableArray alloc] init];
    NSString *runString = selectedDemand[@"Runs"];
    if (![runString isEqualToString:@""]) {
        NSArray *components = [runString componentsSeparatedByString:@","];
        runsArray = [components mutableCopy];
    }
    
    ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
    [actionPickerView initViewWithArray:runsArray andTag:tag];
    actionPickerView.delegate = self;
    actionPickerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:actionPickerView];
    selectedActionTag = 2;
}

- (void) selectedActionIndex:(int)index withTag:(int)tag {
    if (selectedActionTag == 1) {
        if (index == 4) {
            CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
            self.calendar = calendar;
            calendar.delegate = self;
            calendar.tag = tag;
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
            self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
            
            calendar.onlyShowCurrentMonth = NO;
            calendar.adaptHeightToNumberOfWeeksInMonth = YES;
            
            calendar.frame = CGRectMake(10, 260, 300, 320);
            [self.view addSubview:calendar];
        }
        else {
            selectedShipping = dateActions[index];
            selectedIndex = index;
            selectedTag = tag;
            _shippingEntryView.hidden = false;
            _tintedView.hidden = false;
        }
    }
    else {
        RunDetailsViewController *runDetailsVC = [[RunDetailsViewController alloc] initWithNibName:@"RunDetailsViewController" bundle:nil];
        [runDetailsVC setRun:[__DataManager getRunWithId:[runsArray[index] intValue]]];
        [self.navigationController pushViewController:runDetailsVC animated:true];
    }
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
    selectedShipping = dateString;
    DemandListCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:calendar.tag inSection:0]];
    [cell setExpectedDate:dateString];
    selectedIndex = 4;
    //selectedTag = calendar.tag;
    //_shippingEntryView.hidden = false;
    //_tintedView.hidden = false;
   // [_dateButton setTitle:dateString forState:UIControlStateNormal];
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


- (void)selectedSegment:(DZNSegmentedControl *)control {
    [self filterArrayForIndex:control.selectedSegmentIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"productsArray count = %lu",(unsigned long)[[productsArray mutableCopy] count]);
    if (filtered) {
        return [filteredArray count];
    }
    return [[productsArray mutableCopy] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DemandListCell";
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    if (filtered) {
        [cell setCellData:filteredArray[indexPath.row] withTag:indexPath.row];
    }
    else
        [cell setCellData:productsArray[indexPath.row] withTag:indexPath.row];
    [cell setDelegate:self];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _detailView.hidden = false;
    _tintedView.hidden = false;
    if (filtered) {
        selectedDemand = filteredArray[indexPath.row];
    }
    else
        selectedDemand = productsArray[indexPath.row];
    _titleLabel.text = selectedDemand[@"Product"];
    _commentsTextView.text = selectedDemand[@"Notes"];
    _asapCountLabel.text = selectedDemand[@"urgent_qty"];
    _asapDateLabel.text = selectedDemand[@"urgent_when"];
    _masonCountLabel.text = selectedDemand[@"Mason_Stock"];
    _masonDateLabel.text = selectedDemand[@"stock_when"];
    _longCountLabel.text = selectedDemand[@"long_term_qty"];
    _longDateLabel.text = selectedDemand[@"long_when"];
}

- (IBAction)closeDetailPressed:(id)sender {
    _tintedView.hidden = true;
    _detailView.hidden = true;
}

- (IBAction)shippingButtonPressed:(id)sender {
    
}

- (void)refreshPressed {
    [self getDemands];
}

- (IBAction)cancelButtonPressed:(id)sender {
    _tintedView.hidden = true;
    [_shippingEntryView removeFromSuperview];
}

- (IBAction)doneButtonPressed:(id)sender {
    if ([_pickShippingButton.titleLabel.text isEqualToString:@"Pick Shipping"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter Shipping" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    _tintedView.hidden = true;
    [_shippingEntryView removeFromSuperview];
    DemandListCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedTag inSection:0]];
    if ([selectedShipping isEqualToString:@"--"]) {
        [cell setExpectedDate:selectedShipping];
    }
    else {
        [cell setExpectedDate:[NSString stringWithFormat:@"%@(%d)",selectedShipping,[_countTextField.text intValue]]];
    }

    [self updateDemand];
    //[self saveExpectedShipping:[NSString stringWithFormat:@"%@(%d)",dateActions[selectedIndex], [_countTextField.text intValue]] forTag:selectedTag];
}

- (IBAction)pickRunPressed:(id)sender {
    dropDownTag = 2;
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :runsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 2;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickShippingPressed:(id)sender {
    dropDownTag = 1;
    if(dropDown == nil) {
        CGFloat f = 180;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dateActions :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    //selectedOperator = operatorArray[index];
    if (dropDown.tag == 1) {
        if (index == 3) {
            CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
            self.calendar = calendar;
            calendar.delegate = self;
            calendar.tag = index;
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
            self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
            
            calendar.onlyShowCurrentMonth = NO;
            calendar.adaptHeightToNumberOfWeeksInMonth = YES;
            
            calendar.frame = CGRectMake(10, 260, 300, 320);
            [self.view addSubview:calendar];
        }
        else {
            selectedShipping = dateActions[index];
        }
    }
    else
        selectedRunId = [runsArray[index] intValue];
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (void)getDemands {
    [self.navigationController.view showActivityViewWithLabel:@"fetching demands"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://www.aginova.info/aginova/json/demands.php";
    [connectionManager makeRequest:reqString withTag:5];
}

- (void)updateDemand {
    NSString *encodedString;
    if ([selectedShipping isEqualToString:@"--"]) {
        encodedString = @"--";
    }
    else {
        encodedString = [self urlEncodeUsingEncoding:[NSString stringWithFormat:@"%@(%d)",selectedShipping, [_countTextField.text intValue]]];
    }
    [self.navigationController.view showActivityViewWithLabel:@"updating demand"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    
    NSString *reqString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?do=update&call=update_demand_details&demandid=%@&shipping=%@&RunID=%d",selectedDemand[@"Demand Id"],encodedString,selectedRunId];
    [connectionManager makeRequest:reqString withTag:5];
}

- (NSString*)getLowestRunId {
    int runId = 0;
    NSString *runString = selectedDemand[@"Runs"];
    if (![runString isEqualToString:@""]) {
        NSArray *components = [runString componentsSeparatedByString:@","];
        runId = [components[0] intValue];
        for (int i=1; i < components.count; ++i) {
            if (runId > [components[i] intValue]) {
                runId = [components[i] intValue];
            }
        }
    }
    if (runId == 0) {
        return @"NONE";
    }
    return [NSString stringWithFormat:@"%d",runId];
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    NSLog(@"jsonData = %@", jsonData);

    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];

    NSLog(@"datastring = %@", dataString);
    dataString = [dataString stringByReplacingOccurrencesOfString:@"4\" PROBE" withString:@"4 PROBE"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];
    if ([dataString isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            productsArray = [[NSMutableArray alloc] init];
            for (int i=0; i < json.count; ++i) {
                NSMutableDictionary *demandData = json[i];
                //NSLog(@"demandData = %@",demandData);
                [productsArray addObject:demandData];
            }
            //[self saveDemandDataInParse];
            [_tableView reloadData];
        }
        NSLog(@"part short string = %@", partShortString);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

/*- (void)saveDemandDataInParse {
    for (int i=0; i < productsArray.count; ++i) {
        NSMutableDictionary *demandData = [productsArray[i] mutableCopy];
        NSLog(@"checking demandData:%@",demandData);
        PFQuery *query = [PFQuery queryWithClassName:@"Demands"];
         NSArray *objects = [query findObjects];
        //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            int j=0;
            NSLog(@"objects count = %lu",(unsigned long)[objects count]);
            for (j=0; j < [objects count]; ++j) {
                PFObject *parseObject = [objects objectAtIndex:j];
                if ([parseObject[@"ProductName"] isEqualToString:demandData[@"Product"]]) {
                    if (parseObject[@"Shipping"]) {
                         [demandData setValue:parseObject[@"Shipping"] forKey:@"Shipping"];
                        [productsArray replaceObjectAtIndex:i withObject:demandData];
                        [_tableView reloadData];
                    }
                    parseObject[@"Run"] = productsArray[i][@"Runs"];
                    [parseObject save];
                    break;
                }
            }
            if (j == [objects count]) {
                PFObject *parseObject = [PFObject objectWithClassName:@"Demands"];
                parseObject[@"ProductName"] = demandData[@"Product"];
                [parseObject save];
            }
    }
    control.selectedSegmentIndex = 3;
    [self selectedSegment:control];
    control.selectedSegmentIndex = 2;
    [self selectedSegment:control];
    control.selectedSegmentIndex = 1;
    [self selectedSegment:control];
    control.selectedSegmentIndex = 0;
    [self selectedSegment:control];
}
*/


- (void)filterArrayForIndex:(int)index {
    filtered = true;
    [filteredArray removeAllObjects];
    NSLog(@"selected segment = %d",index);
    switch (index) {
        case 0:{
            filtered = false;
            [control setCount:[NSNumber numberWithInteger:[productsArray count]] forSegmentAtIndex:control.selectedSegmentIndex];
            [_tableView reloadData];
            return;
        }
            break;
        case 1:{
            for (int i=0; i < productsArray.count; ++i) {
                NSMutableDictionary *demandData = productsArray[i];
                if (![demandData[@"urgent_qty"] isEqualToString:@"0"]) {
                    [filteredArray addObject:productsArray[i]];
                }
            }
        }
            break;
        case 2:{
            for (int i=0; i < productsArray.count; ++i) {
                NSMutableDictionary *demandData = productsArray[i];
                if (![demandData[@"Mason_Stock"] isEqualToString:@""]) {
                    [filteredArray addObject:productsArray[i]];
                }
            }
        }
            break;
        case 3:{
            for (int i=0; i < productsArray.count; ++i) {
                NSMutableDictionary *demandData = productsArray[i];
                if (![demandData[@"long_term_qty"] isEqualToString:@"0"]) {
                    [filteredArray addObject:productsArray[i]];
                }
            }
        }
            break;
            
        default:
            break;
    }
    NSLog(@"filteredArray = %@",filteredArray);
    [control setCount:[NSNumber numberWithInteger:[filteredArray count]] forSegmentAtIndex:control.selectedSegmentIndex];
    [_tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tasklistPressed:(id)sender {
    TaskListViewController *taskListVC = [TaskListViewController new];
    [taskListVC setTasks:tasksArray];
    [self.navigationController pushViewController:taskListVC animated:NO];
}

- (void)getTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"TaskList"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        tasksArray = objects;
        [_taskButton setBadgeEdgeInsets:UIEdgeInsetsMake(25, 0, 3, 18)];
        [_taskButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)objects.count]];
        [__DataManager setTaskList:tasksArray];
    }];
}

@end
