//
//  ViewController.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "ProcessListViewController.h"
#import "SKSTableView.h"
#import "ProcessListCell.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Process.h"
#import "ProcessDetailsViewController.h"
#import "JobViewController.h"
#import "ReportsViewController.h"
#import "DefectsListViewController.h"
#import "AddDefectViewController.h"
#import <Parse/Parse.h>

@interface ProcessListViewController ()

@property (nonatomic, strong) NSArray *contents;

@end

@implementation ProcessListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.tableView.SKSTableViewDelegate = self;
    statusActions = [@[@"Open", @"In Progress", @"Completed"] mutableCopy];
    operatorArray = [NSMutableArray arrayWithObjects:@"Arvind Ramane", @"Mantu Gupta",@"Ram Todkar", @"Govind Borade", @"Govind Betkar", @"Archana Shinde",nil];

    
    // In order to expand just one cell at a time. If you set this value YES, when you expand an cell, the already-expanded cell is collapsed automatically.
//    self.tableView.shouldExpandOnlyOneCell = YES;
    
    self.navigationItem.title = @"Processes";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reports"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightButtonPressed)];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
   // NSLog(@"run processes =: %d", [run.processes count]);

    //if ([run.processes count]==0) {
        [__ServerManager getProcessListForRunId:[run getRunId]];
    /*}
    else {
        [__DataManager setProcessList:run.processes forRunId:[run getRunId]];
        [run setRunProcesses:run.processes];

    }*/
    NSLog(@"run processes = %@",[run getRunProcesses]);
    [self.tableView reloadData];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delaysTouchesBegan = YES;
    [self.tableView addGestureRecognizer:lpgr];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    NSLog(@"long press detected");

    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        // get the cell at indexPath (the one you long pressed)
        UITableViewCell* cell =
        [self.tableView cellForRowAtIndexPath:indexPath];
        selectedProcessIndex = indexPath.row;
        _batchView.hidden = false;
        _tintView.hidden = false;
    }
}

- (void)setMultiMode:(BOOL)value {
    multiMode = value;
}

- (void)setRun:(Run*)run_ {
    run = run_;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"run processes count = %d",[[run getRunProcesses] count]);
    return [[run getRunProcesses] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    Process *process = [[run getRunProcesses] objectAtIndex:indexPath.row];
    return[[process getSubProcesses] count];
}

- (BOOL)tableView:(UITableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProcessListCell";
    
    ProcessListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil][0];
    
    Process *process = [[run getRunProcesses] objectAtIndex:indexPath.row];
    cell.textLabel.text = process.processName;
    //cell.detailTextLabel.text = [process getProcessStatusDescription];
    cell.backgroundColor = [UIColor clearColor];
    [cell setProcessData:process];
    if ([[process getSubProcesses] count]>0)
        cell.expandable = YES;
    else
        cell.expandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProcessListCell";
    
    ProcessListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil][0];
    Process *process = [[run getRunProcesses] objectAtIndex:indexPath.row];
    Process *subProcess = [[process getSubProcesses] objectAtIndex:indexPath.subRow-1];
    cell.textLabel.text = [subProcess getProcessName];
   // cell.detailTextLabel.text = [process getProcessStatusDescription];
    [cell setProcessData:process];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (multiMode) {
        ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
        [actionPickerView initViewWithArray:statusActions andTag:indexPath.row];
        actionPickerView.delegate = self;
        actionPickerView.backgroundColor = [UIColor clearColor];
    }
    else if ([[__User getRole] isEqualToString:@"Operator"]) {
        Process *process = [[run getRunProcesses] objectAtIndex:indexPath.row];
        JobViewController *jobVC = [[JobViewController alloc] initWithNibName:@"JobViewController" bundle:nil];
        jobVC.title = process.processName;
        [jobVC setProcess:process];
        [self.navigationController pushViewController:jobVC animated:true];
    }
    else {
        selectedProcessIndex = indexPath.row;
        optionAlertView = [[UIAlertView alloc] initWithTitle:@"Select Option" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Data", @"Log Defect", nil];
        [optionAlertView show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (multiMode) {
        ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
        [actionPickerView initViewWithArray:statusActions andTag:indexPath.row];
        actionPickerView.delegate = self;
        actionPickerView.backgroundColor = [UIColor clearColor];
    }
    else {
        /*Process *process = [[[[__DataManager getProcesses] objectAtIndex:indexPath.row] getSubProcesses] objectAtIndex:indexPath.subRow-1];
        ProcessDetailsViewController *processDetailsVC = [[ProcessDetailsViewController alloc] initWithNibName:@"ProcessDetailsViewController" bundle:nil];
        [processDetailsVC setProcess:process];
        [self.navigationController pushViewController:processDetailsVC animated:true];*/
        JobViewController *jobVC = [[JobViewController alloc] initWithNibName:@"JobViewController" bundle:nil];
        [self.navigationController pushViewController:jobVC animated:true];
    }
}

- (void)showEntryDialog {
    _batchView.hidden = false;
    _tintView.hidden = false;
    _okayTF.text = @"";
    _rejectTF.text = @"";
    _reworkTF.text = @"";
}

#pragma mark - Actions

- (void)rightButtonPressed{
    //Added for test purpose
    ReportsViewController *reportsVC = [[ReportsViewController alloc] initWithNibName:@"ReportsViewController" bundle:nil];
    [self.navigationController pushViewController:reportsVC animated:true];
    /*DefectsListViewController *defectsListVC = [[DefectsListViewController alloc] initWithNibName:@"DefectsListViewController" bundle:nil];
    [defectsListVC setListType:1];
    [self.navigationController pushViewController:defectsListVC animated:true];*/
}

//UIAlertViewDelegate method callback
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {

        case 1:{
            [self showEntryDialog];
        }
            break;
        case 2:{
            Process *process = [[run getRunProcesses] objectAtIndex:selectedProcessIndex];
            AddDefectViewController *addDefectVC = [[AddDefectViewController alloc] initWithNibName:@"AddDefectViewController" bundle:nil];
            [addDefectVC setProcess:process];
            [self.navigationController pushViewController:addDefectVC animated:true];
        }
            break;
        default:
            break;
    }
}


/*- (void)reloadTableViewWithData:(NSArray *)array
{
    [self.tableView refreshDataWithScrollingToIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}*/

- (IBAction)pickOperatorPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :operatorArray :nil :@"down"];
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
    selectedOperator = operatorArray[index];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

//ActionPickerDelegate methods
- (void) selectedActionIndex:(int)index withTag:(int)tag {
    NSLog(@"action selected");
    NSMutableArray *processArray = [run getRunProcesses];
    NSLog(@"process count = %lu",(unsigned long)[processArray count]);
    Process *process = [processArray objectAtIndex:tag];
    [process setProcessStatus:index];
    [_tableView reloadData];
    _batchView.hidden = false;
    _tintView.hidden = false;
    selectedProcessIndex = tag;
}

- (void)closeProcess {
    
}


- (IBAction)cancelButtonPressed:(id)sender {
    _batchView.hidden = true;
    _tintView.hidden = true;
}
- (IBAction)okButtonPressed:(id)sender {
    NSMutableArray *processArray = [run getRunProcesses];
    Process *process = [processArray objectAtIndex:selectedProcessIndex];
    int processIndex = [[[process getProcessId] substringFromIndex:2] intValue]-1;
    int count = 0;
    /*NSMutableArray *processJobs = [process getProcessJobs];
    for (int i=0; i < [processJobs count]; ++i) {
        Job *job = processJobs[i];
        if ([job getJobType] < 2 ) {
            NSLog(@"completing job: %@",[job getJobId]);
            [job setJobType:2];
            [process finishedJob:[job getJobId]];
            count++;
            if (count == [_okayTF.text intValue]) {
                break;
            }
        }
    }*/
    _batchView.hidden = true;
    _tintView.hidden = true;
    [self writeProcessData];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_okayTF.text,@"Okay", _reworkTF.text, @"Rework", _rejectTF.text, @"Reject", selectedOperator, @"Operator", nil];
   // [self writeJobData:dictionary];
   // [self writeRunData:dictionary];
    [self saveDailyDataInParse:dictionary];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_okayTF resignFirstResponder];
        [_reworkTF resignFirstResponder];
        [_rejectTF resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)writeProcessData {
    Process *process = [[run getRunProcesses] objectAtIndex:selectedProcessIndex];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"DailyProduction.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"DailyProduction" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    NSLog(@"path = %@",path);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat1 dateFromString:[__User getDateString]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //here add elements to data file and write data to file

    NSMutableDictionary *dictionary = [data objectForKey:dateString];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[process getProcessName],@"Name",[NSString stringWithFormat:@"%d",[run getRunId]],@"RunId",[run getProductNumber],@"Id",@"0",@"Quantity",@"0",@"Rework",@"0",@"Reject", [__User getUsername],@"Operator" , nil];
        [dictionary setObject:processDictionary forKey:[process getProcessName]];
    }
    else {
        NSMutableDictionary *processDictionary = [dictionary objectForKey:[process getProcessName]];
        if (!processDictionary) {
            NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[process getProcessName],@"Name",[NSString stringWithFormat:@"%d",[run getRunId]],@"RunId",[run getProductNumber],@"Id",@"0",@"Quantity",@"0",@"Rework",@"0",@"Reject", [__User getUsername],@"Operator" , nil];
            [dictionary setObject:processDictionary forKey:[process getProcessName]];
        }
    }

    [data setObject:dictionary forKey:dateString];
    NSLog(@"data = %@",data);
    [data writeToFile: path atomically:YES];
}

- (void)writeJobData:(NSDictionary*)jobData {
    Process *process = [[run getRunProcesses] objectAtIndex:selectedProcessIndex];

    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"DailyProduction.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"DailyProduction" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat1 dateFromString:[__User getDateString]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //here add elements to data file and write data to file
    NSMutableDictionary *dictionary = [data objectForKey:dateString];
    NSMutableDictionary *processDictionary = [dictionary objectForKey:[process getProcessName]];
    
    int quantity = [[processDictionary valueForKey:@"Quantity"] intValue];
    int rework = [[processDictionary valueForKey:@"Rework"] intValue];
    int reject = [[processDictionary valueForKey:@"Reject"] intValue];

    [processDictionary setObject:[NSString stringWithFormat:@"%d",[run getRunId]] forKey:@"RunId"];
    [processDictionary setObject:[run getProductNumber] forKey:@"Id"];
    [processDictionary setObject:[process getProcessName] forKey:@"Name"];
    [processDictionary setObject:[[NSNumber numberWithInt:quantity+[[jobData objectForKey:@"Okay"] intValue]] stringValue] forKey:@"Quantity"];
    [processDictionary setObject:[[NSNumber numberWithInt:reject+[[jobData objectForKey:@"Reject"] intValue]] stringValue] forKey:@"Reject"];
    [processDictionary setObject:[[NSNumber numberWithInt:rework+[[jobData objectForKey:@"Rework"] intValue]] stringValue] forKey:@"Rework"];
    [processDictionary setObject:[jobData objectForKey:@"Operator"] forKey:@"Operator"];


    [dictionary setObject:processDictionary forKey:[process getProcessName]];
    [data setObject:dictionary forKey:dateString];
    [data writeToFile: path atomically:YES];
}


- (void)writeRunData:(NSDictionary*)jobData {
    Process *process = [[run getRunProcesses] objectAtIndex:selectedProcessIndex];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RunList.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"RunList" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }

    //here add elements to data file and write data to file
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] init];

    NSMutableDictionary *dictionary = [data objectForKey:[NSString stringWithFormat:@"%d",[run getRunId]]];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
        [processDictionary setObject:[[NSNumber numberWithInt:[[jobData objectForKey:@"Okay"] intValue]] stringValue] forKey:@"Quantity"];
        [processDictionary setObject:[[NSNumber numberWithInt:[[jobData objectForKey:@"Reject"] intValue]] stringValue] forKey:@"Reject"];
        [processDictionary setObject:[[NSNumber numberWithInt:[[jobData objectForKey:@"Rework"] intValue]] stringValue] forKey:@"Rework"];
        [processDictionary setObject:[jobData objectForKey:@"Operator"] forKey:@"Operator"];
    }
    else {
        processDictionary = [dictionary objectForKey:[process getProcessName]];
        if (!processDictionary) {
            processDictionary = [[NSMutableDictionary alloc] init];
            [processDictionary setObject:[[NSNumber numberWithInt:[[jobData objectForKey:@"Okay"] intValue]] stringValue] forKey:@"Quantity"];
            [processDictionary setObject:[[NSNumber numberWithInt:[[jobData objectForKey:@"Reject"] intValue]] stringValue] forKey:@"Reject"];
            [processDictionary setObject:[[NSNumber numberWithInt:[[jobData objectForKey:@"Rework"] intValue]] stringValue] forKey:@"Rework"];
            [processDictionary setObject:[jobData objectForKey:@"Operator"] forKey:@"Operator"];
        }
        else {
            int quantity = [[processDictionary valueForKey:@"Quantity"] intValue];
            int rework = [[processDictionary valueForKey:@"Rework"] intValue];
            int reject = [[processDictionary valueForKey:@"Reject"] intValue];
            
            [processDictionary setObject:[[NSNumber numberWithInt:quantity+[[jobData objectForKey:@"Okay"] intValue]] stringValue] forKey:@"Quantity"];
            [processDictionary setObject:[[NSNumber numberWithInt:reject+[[jobData objectForKey:@"Reject"] intValue]] stringValue] forKey:@"Reject"];
            [processDictionary setObject:[[NSNumber numberWithInt:rework+[[jobData objectForKey:@"Rework"] intValue]] stringValue] forKey:@"Rework"];
            [processDictionary setObject:[jobData objectForKey:@"Operator"] forKey:@"Operator"];
        }
    }
    [processDictionary setObject:[NSString stringWithFormat:@"%d",[run getRunId]] forKey:@"RunId"];
    [processDictionary setObject:[run getProductNumber] forKey:@"Id"];
    [processDictionary setObject:[process getProcessName] forKey:@"Name"];
    [dictionary setObject:processDictionary forKey:[process getProcessName]];

    [data setObject:dictionary forKey:[NSString stringWithFormat:@"%d",[run getRunId]]];
    [data writeToFile: path atomically:YES];
}

- (void)saveDailyDataInParse:(NSDictionary*)processData {
    Process *process = [[run getRunProcesses] objectAtIndex:selectedProcessIndex];

    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat1 dateFromString:[__User getDateString]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //here add elements to data file and write data to file
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseRun = [objects objectAtIndex:i];
            if ([parseRun[@"ProcessName"] isEqualToString:[process getProcessName]]&&[parseRun[@"Date"] isEqualToString:dateString]) {
                parseRun[@"Quantity"] = [NSString stringWithFormat:@"%d", [parseRun[@"Quantity"] intValue]+[[processData objectForKey:@"Okay"] intValue]];
                parseRun[@"Rejects"] = [NSString stringWithFormat:@"%d", [parseRun[@"Rejects"] intValue]+[[processData objectForKey:@"Reject"] intValue]];
                parseRun[@"Reworks"] = [NSString stringWithFormat:@"%d",([parseRun[@"Reworks"] intValue]+[[processData objectForKey:@"Rework"] intValue])];
                parseRun[@"ProductName"] = [run getProductName];
                parseRun[@"Operator"] = [processData objectForKey:@"Operator"];
                parseRun[@"Date"] = dateString;
                [parseRun saveInBackground];
                break;
            }
        }
        if (i == [objects count]) {
            PFObject *parseRun = [PFObject objectWithClassName:@"DailyRun"];
            parseRun[@"RunId"] = [NSString stringWithFormat:@"%d",[run getRunId]];
            parseRun[@"ProductName"] = [run getProductName];
            parseRun[@"ProductNumber"] = [run getProductNumber];
            parseRun[@"ProcessName"] = [process getProcessName];
            parseRun[@"Operator"] = [processData objectForKey:@"Operator"];
            parseRun[@"Quantity"] = [processData objectForKey:@"Okay"];
            parseRun[@"Reworks"] = [processData objectForKey:@"Rework"];
            parseRun[@"Rejects"] = [processData objectForKey:@"Reject"];
            parseRun[@"Date"] = dateString;
            [parseRun saveInBackground];
        }
        [self updateRunDataWithCount:[objects count] andData:processData];
    }];
}

- (void)updateRunDataWithCount:(int)count andData:(NSDictionary*)processData {
    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseRun = [objects objectAtIndex:i];
            parseRun[@"ClosedProcesses"] = [NSString stringWithFormat:@"%d", count];
            parseRun[@"Rejects"] = [NSString stringWithFormat:@"%d", [parseRun[@"Rejects"] intValue]+[[processData objectForKey:@"Reject"] intValue]];
            parseRun[@"Reworks"] = [NSString stringWithFormat:@"%d",([parseRun[@"Reworks"] intValue]+[[processData objectForKey:@"Rework"] intValue])];

        }
    }];
}


@end
