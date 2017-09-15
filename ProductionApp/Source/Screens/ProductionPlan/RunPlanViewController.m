//
//  RunPlanViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 25/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RunPlanViewController.h"
#import "ScheduleOperationsViewController.h"
#import "UIView+RNActivityView.h"
#import "DataManager.h"

@interface RunPlanViewController ()

@end

@implementation RunPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = false;
    operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Ram",@"Pranali", @"Raman", @"Lalu", @"Sumit", @"Sadashiv",nil];
    _runLabel.text = [NSString stringWithFormat:@"%d: %@",[run getRunId], [run getProductName]];
    [self getRunPlan];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRun:(Run*)run_ {
    run = run_;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getRunPlan {
    operationsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (objects.count == 0) {
            [self getProcessesForProductId:[self getProductId]];
            //[self saveOperationsInParse];
            __after(3, ^{
                [_tableView reloadData];
            });
        }
        else {
            operationsArray = [objects mutableCopy];
            [_tableView reloadData];
        }
    }];
}

- (void)saveOperationsInParse {
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];
    for (int i=0; i < operationsArray.count; ++i) {
        NSMutableDictionary *operationData = operationsArray[i];
        PFObject *parseObject = [PFObject objectWithClassName:@"ProductionPlan"];
        parseObject[@"RunId"] = operationData[@"RunId"];
        parseObject[@"ProductName"] = operationData[@"ProductName"];
        parseObject[@"ProductNumber"] = operationData[@"ProductNumber"];
        parseObject[@"DateAssigned"] = operationData[@"DateAssigned"];
        parseObject[@"Quantity"] = operationData[@"Quantity"];
        if (operationData[@"OperatorName"]) {
            parseObject[@"OperatorName"] = operationData[@"OperatorName"];
        }
        parseObject[@"OperationName"] = operationData[@"OperationName"];

        parseObject[@"StationId"] = operationData[@"StationId"];
        parseObject[@"Status"] = @"OPEN";
        parseObject[@"Time"] = operationData[@"Time"];
        [parseObject save];
        [operationsArray addObject:parseObject];
    }
    __after(3, ^{
        [self.navigationController.view hideActivityView];
    });
   // [self getRunPlan];
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
    _tintView.hidden = false;
    _okayTF.text = savingObject[@"Quantity"];
    _entryView.frame = CGRectMake(self.view.frame.size.width/2-_entryView.frame.size.width/2, self.view.frame.size.height/2-_entryView.frame.size.height/2, _entryView.frame.size.width, _entryView.frame.size.height);
    [self.view addSubview:_entryView];
}

- (void) editOperationforIndex:(int)index {
    _processLabel.text = operationsArray[index][@"OperationName"];
    _quantityTF.text = operationsArray[index][@"Quantity"];
    if (operationsArray[index][@"DateAssigned"]) {
        [_pickOperatorButton setTitle:operationsArray[index][@"DateAssigned"] forState:UIControlStateNormal];
    }
    if (operationsArray[index][@"OperatorName"]) {
        [_pickOperatorButton setTitle:operationsArray[index][@"OperatorName"] forState:UIControlStateNormal];
    }
    selectedListIndex = index;
    _editOperationView.frame = CGRectMake(self.view.frame.size.width/2-_editOperationView.frame.size.width/2, self.view.frame.size.height/2-_editOperationView.frame.size.height/2, _editOperationView.frame.size.width, _editOperationView.frame.size.height);
    [self.view addSubview:_editOperationView];
    _tintView.hidden = false;
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

- (void)updateProcessPlanForIndex:(int)index {
    PFObject *parseObject = operationsArray[index];
    parseObject[@"Quantity"] = _quantityTF.text;
    parseObject[@"OperatorName"] = _pickOperatorButton.titleLabel.text;
    parseObject[@"DateAssigned"] = _pickDateButton.titleLabel.text;
    [parseObject save];
    __after(2, ^{
        [_tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [operationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RunPlanViewCell";
    RunPlanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:[operationsArray objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)addOperationPressed:(id)sender {
    //[self getProcessesForProductId:[self getProductId]];
    ScheduleOperationsViewController *scheduleOperationsVC = [ScheduleOperationsViewController new];
    [self.navigationController pushViewController:scheduleOperationsVC animated:true];
}

- (NSString*)getProductId {
    NSString *productNumber = [run getProductNumber];
    NSLog(@"ProductNumber = %@",productNumber);
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"ProductsData" ofType:@"plist"];
    
    NSMutableArray *productsArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSLog(@"productsArray=%@",productsArray);
    for (int i=0; i < productsArray.count; ++i) {
        NSMutableDictionary *productData = productsArray[i];
        if ([productNumber isEqualToString:productData[@"Number"]]) {
            return productData[@"Id"];
        }
    }
    return nil;
}

- (void)getProcessesForProductId:(NSString*)productId {
    NSLog(@"ProductId=%@",productId);
    processesArray = [[NSMutableArray alloc] init];
    
    NSString *filename = [NSString stringWithFormat:@"%@_Processes",productId];
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      filename ofType:@"plist"];
    processesArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] mutableCopy];
    NSLog(@"processesArray=%@",processesArray);
    if (processesArray) {
        [self setUpOperationArray];
    }
}

- (void)setUpOperationArray {
    [self.navigationController.view showActivityViewWithLabel:@"Setting Up Run Processes"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    operationsArray = [[NSMutableArray alloc] init];
    for(int i=0; i < processesArray.count; ++i) {
        NSMutableDictionary *processData = processesArray[i];
        PFObject *operationData = [PFObject objectWithClassName:@"ProductionPlan"];
        operationData[@"RunId"] = [NSString stringWithFormat:@"%d",[run getRunId]];
        operationData[@"ProductName"] = [run getProductName];
        operationData[@"ProductNumber"] = [run getProductNumber];
        operationData[@"OperationName"] = processData[@"name"];
        operationData[@"StationId"] = processData[@"stationId"];
        if (processData[@"operator"]) {
            operationData[@"OperatorName"] = processData[@"operator"];
        }
        operationData[@"DateAssigned"] = @"--";
        if ([processData[@"time"] intValue] >=3 ) {
            operationData[@"Time"] = processData[@"time"];
        }
        else {
            operationData[@"Time"] = [NSString stringWithFormat:@"%f",[processData[@"time"] floatValue]*[[run getRunData][@"Inprocess"] intValue]];
        }
        operationData[@"Quantity"] = [run getRunData][@"Inprocess"];
        operationData[@"Status"] = @"OPEN";
        [operationsArray addObject:operationData];
        [operationData save];
    }
    NSLog(@"operationsArray=%@",operationsArray);
    __after(8, ^{
        [_tableView reloadData];
    });
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
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
        NSDictionary *processData = [self getOperationWithId:process];
        //[self removeRunWithId:runId];
        //[self saveProcessPlanForRun:runsArray[selectedRunIndex] process:processData];
    }
    //[self filterList];
}

- (NSDictionary*)getOperationWithId:(NSString*)processName {
    for (int i=0; i < operationsArray.count; ++i) {
        NSDictionary *processData = operationsArray[i];
        if ([processName isEqualToString:processData[@"name"]]) {
            NSMutableDictionary *processDict = [[NSMutableDictionary alloc] init];
            [processDict setObject:processData[@"name"] forKey:@"Process"];
            [processDict setObject:processData[@"stationId"] forKey:@"StationId"];
            [processDict setObject:processData[@"time"] forKey:@"Time"];
            if (processData[@"operator"]) {
                [processDict setObject:processData[@"operator"] forKey:@"Operator"];
            }
            else {
                [processDict setObject:@"--" forKey:@"Operator"];
            }
            return processDict;
        }
    }
    return nil;
}


- (void)saveProcessPlanForRun:(NSDictionary*)runData process:(NSDictionary*)processData{
    PFObject *parseObject = [PFObject objectWithClassName:@"ProductionPlan"];
    parseObject[@"RunId"] = runData[@"RunId"];
    parseObject[@"ProductName"] = runData[@"ProductName"];
    parseObject[@"ProductNumber"] = runData[@"ProductNumber"];
   // parseObject[@"DateAssigned"] = [_scrollView.values objectAtIndex:_scrollView.selectedIndex];
    parseObject[@"Quantity"] = runData[@"InProcess"];
    parseObject[@"OperationName"] = processData[@"Process"];
    parseObject[@"OperatorName"] = processData[@"Operator"];
    parseObject[@"StationId"] = processData[@"StationId"];
    parseObject[@"Status"] = @"OPEN";
    if ([processData[@"Time"] intValue] >=4 ) {
        parseObject[@"Time"] = processData[@"Time"];
    }
    else {
        parseObject[@"Time"] = [NSString stringWithFormat:@"%d",[processData[@"Time"] intValue]*[runData[@"Inprocess"] intValue]];
    }
    
    
    NSLog(@"saving parse object = %@",parseObject);
    BOOL succeeded = [parseObject save];
    if (succeeded) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data Saved Successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        [self getRunPlan];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error in saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
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

- (IBAction)pickDatePressed:(id)sender {
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
    [_pickDateButton setTitle:dateString forState:UIControlStateNormal];
    [calendar removeFromSuperview];
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

- (IBAction)cancelEntryPressed:(id)sender {
    _tintView.hidden = true;
    [_entryView removeFromSuperview];
}

- (IBAction)submitEntryPressed:(id)sender {
    _tintView.hidden = true;
    [_entryView removeFromSuperview];
    [savingObject save];
    //[self saveDailyDataInParse];
    [self updateRun];
}

- (void)updateRun {
    NSMutableDictionary *runData = [run getRunData];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:runData[@"Qty"],@"Quantity", _reworkTF.text, @"Rework", _okayTF.text, @"InProcess", _rejectTF.text, @"Reject", runData[@"Shipped"], @"Shipped", runData[@"Status"], @"Status", runData[@"Process"], @"Process", runData[@"Shipping"], @"Shipping", nil];
    [run updateRunData:dictionary];
    [__DataManager syncRun:[run getRunId]];
}

@end
