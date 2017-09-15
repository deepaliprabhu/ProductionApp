//
//  ScheduleOperationsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ScheduleOperationsViewController.h"
#import "DataManager.h"

@interface ScheduleOperationsViewController ()

@end

@implementation ScheduleOperationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Ram",@"Pranali", @"Raman", @"Lalu", @"Sonali", @"Sumit", @"Sadashiv",nil];
    scheduleArray = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    control = [[DZNSegmentedControl alloc] initWithItems:scheduleArray];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.selectedSegmentIndex = 0;
    control.frame = CGRectMake(0, 70, screenRect.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
   // [self.view addSubview:control];
    self.scrollView.values = [self thisWeekArray];
    self.scrollView.delegate = self;
    self.scrollView.updateIndexWhileScrolling = NO;
    monArray = [[NSMutableArray alloc] init];
    tuesArray = [[NSMutableArray alloc] init];
    wedArray = [[NSMutableArray alloc] init];
    thuArray = [[NSMutableArray alloc] init];
    friArray = [[NSMutableArray alloc] init];
    satArray = [[NSMutableArray alloc] init];
    
    runsArray = [__DataManager getInProgressRuns];
    [self setUpRunIds];
   /* [self setUpOperations];
    [control setCount:[NSNumber numberWithInt:monArray.count] forSegmentAtIndex:0];
    [control setCount:[NSNumber numberWithInt:tuesArray.count] forSegmentAtIndex:1];
    [control setCount:[NSNumber numberWithInt:wedArray.count] forSegmentAtIndex:2];
    [control setCount:[NSNumber numberWithInt:thuArray.count] forSegmentAtIndex:3];
    [control setCount:[NSNumber numberWithInt:friArray.count] forSegmentAtIndex:4];
    [control setCount:[NSNumber numberWithInt:satArray.count] forSegmentAtIndex:5];*/
    [self getPlanForDate:_scrollView.values[0]];
    
    _editOperationView.layer.borderColor = [UIColor orangeColor].CGColor;
    _editOperationView.layer.borderWidth = 1;
    
    _entryView.layer.borderColor = [UIColor orangeColor].CGColor;
    _entryView.layer.borderWidth = 1.0;
    self.title = @"Daily Operations Plan";
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
    
    NSLog(@"start date = %d, end date= %d",startDate,endDate);
    return weekArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpRunIds {
    runIdsArray = [[NSMutableArray alloc] init];
    for (int i=0; i < runsArray.count; ++i) {
        NSMutableDictionary *runData = [runsArray[i] getRunData];
        NSLog(@"runData=%@",runData);

        [runIdsArray addObject:[NSString stringWithFormat:@"%@: %@",runData[@"Run"], runData[@"Product"]]];
        NSLog(@"runidsarray=%@",runIdsArray);
    }
}

- (void)setOperations {
    [self getProcessesForProductId:[self getProductId]];
}

- (NSString*)getProductId {
    NSMutableDictionary *runData = runsArray[selectedRunIndex];
    NSString *productNumber = runData[@"ProductNumber"];
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"ProductsData" ofType:@"plist"];
    
    NSMutableArray *productsArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (int i=0; i < productsArray.count; ++i) {
        NSMutableDictionary *productData = productsArray[i];
        if ([productNumber isEqualToString:productData[@"Number"]]) {
            return productData[@"Id"];
        }
    }
    return nil;
}

- (void)getProcessesForProductId:(NSString*)productId {
    operationsArray = [[NSMutableArray alloc] init];
    processesArray = [[NSMutableArray alloc] init];

    NSString *filename = [NSString stringWithFormat:@"%@_Processes",productId];
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      filename ofType:@"plist"];
    operationsArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] mutableCopy];
    for (int i=0; i<operationsArray.count; ++i) {
        NSMutableDictionary *processData = operationsArray[i];
        [processesArray addObject:processData[@"name"]];
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

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    
    //[self filterList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredRunsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ScheduleOperationsViewCell";
    ScheduleOperationsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:[filteredRunsArray objectAtIndex:indexPath.row] forRun:runsArray[selectedRunIndex] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedListIndex = indexPath.row;
    [self showEditViewForIndex:indexPath.row];
}

- (IBAction)addOperationPressed:(id)sender {
    selectedDropDownTag = 0;
    [self showPopUpWithTitle:@"Select Option" withOption:runIdsArray xy:CGPointMake(16, 80) size:CGSizeMake(287, 280) isMultiple:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    // [_pickLocationButton setTitle:runIdsArray[anIndex] forState:UIControlStateNormal];
    if (selectedDropDownTag == 0) {
        selectedRunIndex = anIndex;
        //[self setOperations];
        selectedDropDownTag = 1;
        [self getUnAssignedOperationsForRunId:[runsArray[selectedRunIndex] getRunId]];
        //[self showPopUpWithTitle:runsArray[selectedRunIndex][@"RunId"] withOption:processesArray xy:CGPointMake(16, 80) size:CGSizeMake(287, 280) isMultiple:YES];
    }
    else {

    }
   // [self filterList];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    NSLog(@"selected Array = %@",ArryData);
    [self addOperationsWithIds:ArryData];
}

- (void)DropDownListViewDidCancel{
    
}

- (void)addOperationsWithIds:(NSMutableArray*)arrayData {
    for (int i=0; i < arrayData.count; ++i) {
        NSString* process= arrayData[i];
        [self saveOperationWithId:process];
    }
    
    __after(3, ^{
        [self getPlanForDate:_scrollView.values[_scrollView.selectedIndex]];
    });
    //[self filterList];
}

- (void)saveOperationWithId:(NSString*)processName {
    for (int i=0; i < operationsArray.count; ++i) {
        PFObject *processData = operationsArray[i];
        if ([processName isEqualToString:processData[@"OperationName"]]) {
            processData[@"DateAssigned"] = self.scrollView.values[self.scrollView.selectedIndex];
            [processData save];
        }
    }
}


- (void)saveProcessPlanForRun:(NSDictionary*)runData process:(NSDictionary*)processData{
    
    PFObject *parseObject = [PFObject objectWithClassName:@"ProductionPlan"];
    parseObject[@"RunId"] = runData[@"Run"];
    parseObject[@"ProductName"] = runData[@"Product"];
    parseObject[@"ProductNumber"] = runData[@"Product ID"];
    parseObject[@"DateAssigned"] = [_scrollView.values objectAtIndex:_scrollView.selectedIndex];
    parseObject[@"Quantity"] = runData[@"Qty"];
    parseObject[@"OperationName"] = processData[@"Process"];
    parseObject[@"OperatorName"] = processData[@"Operator"];
    parseObject[@"StationId"] = processData[@"StationId"];
    parseObject[@"Status"] = @"OPEN";
    if ([processData[@"Time"] intValue] >=4 ) {
        parseObject[@"Time"] = processData[@"Time"];
    }
    else {
        parseObject[@"Time"] = [NSString stringWithFormat:@"%d",[processData[@"Time"] intValue]*[runData[@"Quantity"] intValue]];
    }

    
    NSLog(@"saving parse object = %@",parseObject);
    BOOL succeeded = [parseObject save];
    if (succeeded) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data Saved Successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        [self getPlanForDate:_scrollView.values[_scrollView.selectedIndex]];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error in saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)updateProcessPlanForIndex:(int)index {
    PFObject *parseObject = filteredRunsArray[index];
    parseObject[@"OperationName"] = _processTF.text;
    parseObject[@"Quantity"] = _quantityTF.text;
    parseObject[@"OperatorName"] = _pickOperatorButton.titleLabel.text;

    [parseObject save];
}

- (void) deleteOperationAtIndex:(int)index {
    PFObject *parseObject = filteredRunsArray[index];
    [parseObject delete];
    [filteredRunsArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

- (void)showEditViewForIndex:(int)index {
    _tintView.hidden = false;
    NSMutableDictionary *processData = filteredRunsArray[index];
    _processTF.text = processData[@"OperationName"];
    _quantityTF.text = processData[@"Quantity"];
    
    _editOperationView.frame = CGRectMake(self.view.frame.size.width/2-_editOperationView.frame.size.width/2, self.view.frame.size.height/2-_editOperationView.frame.size.height/2, _editOperationView.frame.size.width, _editOperationView.frame.size.height);
    [self.view addSubview:_editOperationView];
}

- (IBAction)cancelPressed:(id)sender {
    _tintView.hidden = true;
    [_editOperationView removeFromSuperview];
}

- (IBAction)savePressed:(id)sender {
    _tintView.hidden = true;
    [_editOperationView removeFromSuperview];
    [self updateProcessPlanForIndex:selectedListIndex];
}

- (IBAction)pickOperatorPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :operatorArray :nil :@"down"];
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
    // selectedName = namesArray[index];
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return true;
}

- (void) updateStatus:(BOOL)value forIndex:(int)index {
    savingObject = filteredRunsArray[index];
    if (value) {
        [self showEntryView];
        savingObject[@"Status"] = @"Closed";
    }
    else {
        savingObject[@"Status"] = @"Open";
    }
}

- (void)showEntryView {
    _okayTF.text = savingObject[@"Quantity"];
    _entryView.frame = CGRectMake(self.view.frame.size.width/2-_entryView.frame.size.width/2, self.view.frame.size.height/2-_entryView.frame.size.height/2, _entryView.frame.size.width, _entryView.frame.size.height);
    [self.view addSubview:_entryView];
}

- (IBAction)cancelEntryPressed:(id)sender {
    [_entryView removeFromSuperview];
}

- (IBAction)submitPressed:(id)sender {
    [_entryView removeFromSuperview];
    [savingObject save];
    [self saveDailyDataInParse];
}

- (void)saveDailyDataInParse {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    //here add elements to data file and write data to file
    PFObject *parseObject = [PFObject objectWithClassName:@"DailyRun"];
    parseObject[@"ProcessName"] = savingObject[@"OperationName"];
    parseObject[@"Operator"] = savingObject[@"OperatorName"];
    parseObject[@"Quantity"] = _okayTF.text;
    parseObject[@"ProductName"] = savingObject[@"ProductName"];
    parseObject[@"Rework"] = _reworkTF.text;
    parseObject[@"Reject"] = _rejectTF.text;
    parseObject[@"Station"] = savingObject[@"StationId"];
    parseObject[@"Date"] = dateString;
    parseObject[@"Time"] = savingObject[@"Time"];
    [parseObject save];
}

- (void)scrollView:(MVSelectorScrollView *)scrollView pageSelected:(NSInteger)pageSelected {
    
    //NSLog(@"%s scroll view %d, selected page: %d", __func__, scrollView.tag, pageSelected);
    [self getPlanForDate:[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex]];
}

- (void)getPlanForDate:(NSString*)dateString {
    filteredRunsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"DateAssigned" equalTo:dateString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        filteredRunsArray = [objects mutableCopy];
        [_tableView reloadData];
    }];
}

- (void)getUnAssignedOperationsForRunId:(int)runId {
    NSMutableArray *processesArray = [[NSMutableArray alloc] init];
    operationsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",runId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        for (int i=0; i < objects.count; ++i) {
            PFObject *parseObj = objects[i];
            if ([parseObj[@"DateAssigned"] isEqualToString:@"--"]) {
                [operationsArray addObject:parseObj];
                [processesArray addObject:parseObj[@"OperationName"]];
            }
        }
        selectedDropDownTag = 1;

        [self showPopUpWithTitle:[NSString stringWithFormat:@"%d",[runsArray[selectedRunIndex] getRunId]] withOption:processesArray xy:CGPointMake(16, 60) size:CGSizeMake(287, 280) isMultiple:YES];
    }];
}


@end
