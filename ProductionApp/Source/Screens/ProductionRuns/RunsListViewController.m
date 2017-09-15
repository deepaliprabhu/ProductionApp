//
//  RunsListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/07/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "RunsListViewController.h"
#import "RunDetailsViewController.h"
#import "ProcessListViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "Utilities.h"
#import "UIView+RNActivityView.h"
#import "DailyEntryViewController.h"
#import "TaskListViewController.h"
#import "RunPlanViewController.h"


@interface RunsListViewController ()

@end

@implementation RunsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    operatorArray = [NSMutableArray arrayWithObjects:@"Arvind Ramane", @"Mantu Gupta",@"Archana Shende", @"Chote",nil];
    statusArray = [NSMutableArray arrayWithObjects:@"On Hold:Parts Short", @"On Hold:Low Priority",@"NEW: Parts Shortage", @"NEW: BOM Inspection", @"NEW: Ready To Submit", @"In Progress", @"Ready For Dispatch",@"Shipped", @"Closed",nil];
    processArray = [NSMutableArray arrayWithObjects:@"PNP", @"Through Hole Assembly",@"Inspection", @"Cleaning", @"Ready To Dispatch", @"Dispatched",@"Baner Inward Testing", @"Soldering",@"Mechanical Assembly", @"Moulding", @"Final Assembly & Testing",@"Cleaning & Packaging", @"Shipped",nil];
    
    dispatchArray = [@[@"--", @"Next Week", @"Shipped", @"Pick a date"] mutableCopy];


    [self.navigationController setNavigationBarHidden:false];
    self.navigationController.navigationItem.hidesBackButton = true;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRuns) name:kNotificationRunsReceived object:nil];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPressed)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    self.title = @"Open Runs";
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initView {
    //self.navigationController.navigationBarHidden = false;
    self.title = @"Production Runs";
    parseRuns = [[NSMutableArray alloc] init];
    if ([__DataManager getRuns].count > 0) {
        parseRuns = [__DataManager getRuns];
    }
    else {
        [self.navigationController.view showActivityViewWithLabel:@"fetching runs"];
        [self.navigationController.view hideActivityViewWithAfterDelay:60];
        [__ServerManager getRunsList];
    }
    [self getRunProcessData];
}

- (void) initRuns {
    [self.navigationController.view hideActivityView];
    parseRuns = [__DataManager getRuns];
    [_tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    destIndex = destinationIndexPath.row;
    srcIndex = sourceIndexPath.row;
    Run *o = [parseRuns objectAtIndex:sourceIndexPath.row];
    [parseRuns replaceObjectAtIndex:sourceIndexPath.row withObject:[parseRuns objectAtIndex:destinationIndexPath.row]];
    [parseRuns replaceObjectAtIndex:destinationIndexPath.row withObject:o];
    [_tableView reloadData];
    [self updateRuns];
    NSLog(@"updates parse runs:%@",parseRuns);
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleInsert == editingStyle)
    {
        // inserts are always done at the end
        
        [tableView beginUpdates];
        [parseRuns addObject:[NSMutableArray array]];
        [tableView insertSections:[NSIndexSet indexSetWithIndex:[parseRuns count]-1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
    }
    else if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        // check if we are going to delete a row or a section
        [tableView beginUpdates];
        if([[parseRuns objectAtIndex:indexPath.section] count] == 0)
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [parseRuns removeObjectAtIndex:indexPath.section];
        }
        else
        {
            // Delete the row from the table view.
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            // Delete the row from the data source.
            [[parseRuns objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        }
        [tableView endUpdates];
    }
}

#pragma mark -


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [parseRuns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RunsListCell";
    RunsListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    Run *run = [parseRuns objectAtIndex:indexPath.row];
    [cell setRunData:run];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRun = [parseRuns objectAtIndex:indexPath.row];
    //if ([run isActivated]) {
        [__DataManager setCurrentRunId:[selectedRun getRunId]];
        NSString *productNumber = [selectedRun getProductNumber];
            NSMutableDictionary *parseObj = [selectedRun getRunData];
            if ([parseObj[@"Category"] isEqualToString:@"PCB"]) {
                    processArray = [NSMutableArray arrayWithObjects:@"PNP", @"Through Hole Assembly",@"Inspection", @"Cleaning", @"Ready To Dispatch", @"Dispatched",nil];
                _shippedTitleLabel.text = @"Dispatched";
            }
            else {
                processArray = [NSMutableArray arrayWithObjects:@"Baner_Testing", @"Soldering", @"Moulding",@"Mechanical_Assembly", @"Final_Assembly",@"Packaging",nil];
                _shippedTitleLabel.text = @"Shipped";
            }

           // NSLog(@"process type = %d",[parseObj[@"ProcessType"] intValue]);
            _runRejectTF.text = @"";
            _runReworkTF.text = @"";
            _runInProcessTF.text = @"";
            _runOkayTF.text = @"";
            _runShippedTF.text = @"";
            _runStatusView.hidden = false;
            _tintView.hidden = false;
            _runIDTitle.text = [NSString stringWithFormat:@"%@:%@(%@)",parseObj[@"Run"],parseObj[@"Product"],parseObj[@"Qty"]];
            NSLog(@"parse object = %@",parseObj);
            if (parseObj) {
                _runRejectTF.text = parseObj[@"Reject"];
                _runReworkTF.text = parseObj[@"Rework"];
                _runInProcessTF.text = parseObj[@"Inprocess"];
                _runOkayTF.text = parseObj[@"Ready"];
                _runShippedTF.text = parseObj[@"Shipped"];
                //[_processButton setTitle:parseObj[@"ProcessName"] forState:UIControlStateNormal];
               // selectedProcess = parseObj[@"ProcessName"];
                selectedStatus = parseObj[@"Status"];
                _countTF.text = @"";
                [_dispatchButton setTitle:@"--" forState:UIControlStateNormal];
                
                if (!([parseObj[@"Shipping"] isEqualToString:@""]||[parseObj[@"Shipping"] isEqualToString:@" "]||[parseObj[@"Shipping"] isEqualToString:@"--"])) {
                    NSRange range = [parseObj[@"Shipping"] rangeOfString:@"("];
                    NSString *shippingString = [parseObj[@"Shipping"] substringToIndex:range.location];
                    if (![shippingString isEqualToString:@""]) {
                        [_dispatchButton setTitle:shippingString forState:UIControlStateNormal];
                    }
                    selectedShipping = shippingString;
                    NSString *shippingCount= [parseObj[@"Shipping"] substringFromIndex:range.location];
                    shippingCount = [shippingCount stringByReplacingOccurrencesOfString:@")" withString:@""];
                    shippingCount = [shippingCount stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    _countTF.text = shippingCount;
                }
                else {
                    if ([parseObj[@"Shipping"] isEqualToString:@"--"]) {
                        [_dispatchButton setTitle:@"--" forState:UIControlStateNormal];
                        selectedShipping = @"--";
                    }
                }

                [_statusButton setTitle:parseObj[@"Status"] forState:UIControlStateNormal];
            }
        _tintView.hidden = false;
        //[self showPopUpWithTitle:@"Select Option" withOption:statusArray xy:CGPointMake(16, 80) size:CGSizeMake(287, 280) isMultiple:NO];
}

- (void)updateRuns {
    [__DataManager setDelegate:self];
    if (srcIndex<destIndex) {
        for (int i=srcIndex; i <= destIndex; ++i) {
            multipleUpdates = true;
            Run *run = parseRuns[i];
            [run setSequenceNum:i];
            [__DataManager syncRun:[run getRunId]];
        }
    }
    else {
        for (int i=destIndex; i <= srcIndex; ++i) {
            multipleUpdates = true;
            Run *run = parseRuns[i];
            [run setSequenceNum:i];
            [__DataManager syncRun:[run getRunId]];
        }
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_okayTF resignFirstResponder];
        [_reworkTF resignFirstResponder];
        [_rejectTF resignFirstResponder];
        [_processTF resignFirstResponder];
        [_runShippedTF resignFirstResponder];
        [_runOkayTF resignFirstResponder];
        [_runReworkTF resignFirstResponder];
        [_runInProcessTF resignFirstResponder];
        [_runRejectTF resignFirstResponder];
        return NO;
    }
    return YES;
}

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

- (IBAction)pickStatusPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :statusArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickDispatchPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dispatchArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickProcessPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :processArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 2;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickOriginatorPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :processArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 2;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickApproverPressed:(id)sender {
}

- (void) selectedListIndex:(int)index {
    //selectedOperator = operatorArray[index];
    if (dropDown.tag == 1) {
        selectedStatus = statusArray[index];
    }
    else if (dropDown.tag == 2) {
        selectedProcess = processArray[index];
    }
    else {
        selectedShipping = dispatchArray[index];
    }
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (IBAction)cancelButtonPressed:(id)sender {
    _batchView.hidden = true;
    _runStatusView.hidden = true;
    _tintView.hidden = true;
}

- (IBAction)refreshPressed {
    [self.navigationController.view showActivityViewWithLabel:@"fetching runs"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    [__ServerManager getRunsList];
    [self getRunProcessData];
}

- (IBAction)okButtonPressed:(id)sender {
    int count = 0;
    _batchView.hidden = true;
    _tintView.hidden = true;
    //[self writeProcessData];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_okayTF.text,@"Okay", _reworkTF.text, @"Rework", _rejectTF.text, @"Reject", selectedOperator, @"Operator", nil];

    [self saveDailyDataInParse:dictionary];
}

- (IBAction)submitStatusPressed:(id)sender {
    [__DataManager setDelegate:self];
    multipleUpdates = false;
    _runStatusView.hidden = true;
    _tintView.hidden = true;
    NSString *shipping;
    if ([selectedShipping isEqualToString:@"--"]) {
        shipping = selectedShipping;
    }
    else {
        shipping = [NSString stringWithFormat:@"%@(%@)",selectedShipping, _countTF.text];
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_runOkayTF.text,@"Quantity", _runReworkTF.text, @"Rework", _runInProcessTF.text, @"InProcess", _runRejectTF.text, @"Reject", _runShippedTF.text, @"Shipped", selectedStatus, @"Status",shipping, @"Shipping", selectedProcess, @"Process", nil];
    [selectedRun updateRunData:dictionary];
    //[self updateRunData:dictionary];
    [__DataManager syncRun:[selectedRun getRunId]];
    if (![_runInProcessTF.text isEqualToString:@""]) {
        [__DataManager syncRunProcesses:[selectedRun getRunId]];
    }
}


- (void)saveRunDataInParse {
    NSMutableArray *runs = parseRuns;
    NSMutableArray *runIds = [[NSMutableArray alloc] init];
    NSMutableArray *parseObjects = [[NSMutableArray alloc] init];
    for (int i=0; i < runs.count; ++i) {
        Run *run = [runs objectAtIndex:i];
        [runIds addObject:[NSString stringWithFormat:@"%d",[run getRunId]]];
        PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
       // NSArray *objects = [query findObjects];
        [query whereKey:@"Status" notEqualTo:@"Closed"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            int j=0;
            NSLog(@"objects count = %lu",(unsigned long)[objects count]);
            for (j=0; j < [objects count]; ++j) {
                PFObject *parseObject = [objects objectAtIndex:j];
                if ([parseObject[@"RunId"] isEqualToString:[NSString stringWithFormat:@"%d",[run getRunId]]]) {
                    parseObject[@"Quantity"] = [NSString stringWithFormat:@"%d", [run getQuantity]];
                   // parseObject[@"Status"] = @"Open";
                    parseObject[@"ProductName"] = [run getProductName];
                    parseObject[@"ProductNumber"] = [run getProductNumber];
                    parseObject[@"ProcessType"] = [NSString stringWithFormat:@"%d", [run getCategory]];
                   // parseObject[@"Description"] = [run getDescription];
                   // parseObject[@"RunDate"] = [run getRunDate];
                   // parseObject[@"RequestDate"] = [run getRequestDate];
                    parseObject[@"Priority"] = [NSString stringWithFormat:@"%d",[run getPriority]];
                    [parseObject saveInBackground];
                    NSLog(@"updating Run:%@",parseObject[@"RunId"]);
                    break;
                }
            }
            if (j == [objects count]) {
                PFObject *parseObject = [PFObject objectWithClassName:@"Runs"];
                NSLog(@"Adding new run:%d", [run getRunId]);
                parseObject[@"RunId"] = [NSString stringWithFormat:@"%d",[run getRunId]];
                parseObject[@"ProductName"] = [run getProductName];
                parseObject[@"ProductNumber"] = [run getProductNumber];
                parseObject[@"ProcessType"] = @"2";
                parseObject[@"ProcessName"] = @"NEW";
                parseObject[@"OpenProcesses"] = @"0";
                parseObject[@"ClosedProcesses"] = @"0";
                parseObject[@"Defects"] = @"0";
                parseObject[@"Quantity"] = [NSString stringWithFormat:@"%d", [run getQuantity]];
                parseObject[@"Okay"] = @"0";
                parseObject[@"Reworks"] = @"0";
                parseObject[@"Rework"] = @"0";
                parseObject[@"Rejects"] = @"0";
                parseObject[@"Shipped"] = @"0";
                parseObject[@"Status"] = @"Open";
                parseObject[@"Description"] = @"--";
                parseObject[@"RunDate"] = [run getRunDate];
                parseObject[@"RequestDate"] = @"--";
                parseObject[@"Priority"] = [NSString stringWithFormat:@"%d",[run getPriority]];
                parseObject[@"ProcessType"] = [NSString stringWithFormat:@"%d", [run getCategory]];
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

        }];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    // NSArray *objects = [query findObjects];
    [query whereKey:@"Status" notEqualTo:@"Closed"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        for (int j=0; j < [objects count]; ++j) {
            PFObject *parseObject = [objects objectAtIndex:j];
            if (![runIds containsObject:parseObject[@"RunId"]]) {
                NSLog(@"closing run:%@",parseObject[@"RunId"]);
                parseObject[@"Status"] = @"Closed";
                [parseObject saveInBackground];
            }
        }
    }];
}


- (void)saveDailyDataInParse:(NSDictionary*)processData {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat1 dateFromString:[__User getDateString]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    //here add elements to data file and write data to file
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[selectedRun getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (objects.count > 0) {
            [PFObject pinAllInBackground:objects];
        }
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseObject = [objects objectAtIndex:i];
            if ([parseObject[@"ProcessName"] isEqualToString:[processData objectForKey:@"Process"]]&&[parseObject[@"Date"] isEqualToString:dateString]) {
                parseObject[@"Quantity"] = [processData objectForKey:@"Quantity"];
                parseObject[@"Rejects"] = [processData objectForKey:@"Reject"];
                parseObject[@"Reworks"] = [processData objectForKey:@"InProcess"];
                parseObject[@"Rework"] = [processData objectForKey:@"Rework"];
                parseObject[@"Shipped"] = [processData objectForKey:@"Shipped"];
                parseObject[@"ProductName"] = [selectedRun getProductName];
                parseObject[@"Operator"] = [processData objectForKey:@"Operator"];
                parseObject[@"Date"] = dateString;
                [__ParseDataManager setDelegate:self];
                //[__ParseDataManager saveParseData:parseObject];
                [parseObject saveInBackground];
                break;
            }
        }
        if (i == [objects count]) {
            NSLog(@"saving selectted run = %d",[selectedRun getRunId]);

            PFObject *parseObject = [PFObject objectWithClassName:@"DailyRun"];
            parseObject[@"RunId"] = [NSString stringWithFormat:@"%d",[selectedRun getRunId]];
            parseObject[@"ProductName"] = [selectedRun getProductName];
            parseObject[@"ProductNumber"] = @"--";
           // parseObject[@"ProcessName"] = [processData objectForKey:@"Process"];
            parseObject[@"Operator"] = [processData objectForKey:@"Operator"];
            parseObject[@"Quantity"] = [processData objectForKey:@"Okay"];
            parseObject[@"Reworks"] = [processData objectForKey:@"InProcess"];
            parseObject[@"Rework"] = [processData objectForKey:@"Rework"];
            parseObject[@"Rejects"] = [processData objectForKey:@"Reject"];
            parseObject[@"Shipped"] = [processData objectForKey:@"Shipped"];
            parseObject[@"Date"] = dateString;
            NSLog(@"saving parse object = %@",parseObject);
            [__ParseDataManager setDelegate:self];
            //[__ParseDataManager saveParseData:parseObject];
            [parseObject saveInBackground];
        }
        //[self updateRunDataWithCount:[objects count] andData:processData];
    }];
}



- (void)updateRunDataWithCount:(NSUInteger)count andData:(NSDictionary*)processData {
    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[selectedRun getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)count);
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseObject = [objects objectAtIndex:i];
            parseObject[@"ClosedProcesses"] = [NSString stringWithFormat:@"%lu", (unsigned long)count];
            parseObject[@"Rejects"] = [NSString stringWithFormat:@"%d", [parseObject[@"Rejects"] intValue]+[[processData objectForKey:@"Reject"] intValue]];
            parseObject[@"Reworks"] = [NSString stringWithFormat:@"%d",([parseObject[@"Reworks"] intValue]+[[processData objectForKey:@"Rework"] intValue])];
            [parseObject saveInBackground];
        }
    }];
}

- (void)updateRunData:(NSDictionary*)runData {
    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[selectedRun getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseObject = [objects objectAtIndex:i];
            NSLog(@"Parse object = %@",runData);
            parseObject[@"Status"] = [runData objectForKey:@"Status"];
            //parseObject[@"ProcessName"] = [runData objectForKey:@"Process"];
            parseObject[@"Okay"] = [runData objectForKey:@"Quantity"];
            parseObject[@"Rejects"] = [runData objectForKey:@"Reject"];
            parseObject[@"Reworks"] = [runData objectForKey:@"InProcess"];
            parseObject[@"Rework"] = [runData objectForKey:@"Rework"];
            parseObject[@"Shipped"] = [runData objectForKey:@"Shipped"];
            parseObject[@"Shipping"] = [NSString stringWithFormat:@"%@(%@)",_dispatchButton.titleLabel.text,_countTF.text];
            BOOL succeeded = [parseObject save];
                if (succeeded) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [alertView show];
                   /* NSDictionary *dailyDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_runShippedTF.text, @"Shipped",_runOkayTF.text,@"Okay", _runReworkTF.text, @"Rework",_runInProcessTF.text, @"InProcess", _runRejectTF.text, @"Reject", _runShippedTF.text, @"Shipped", @"--", @"Operator",selectedProcess, @"Process", nil];
                    
                    [self saveDailyDataInParse:dailyDictionary];*/
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving Data! Please Try Again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [alertView show];
                }
           // }];
            [_tableView reloadData];
        }
    }];
}


- (IBAction)processEntryPressed {
    [self getRunProcessData];
    processEntryView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 270, 300)];
    processEntryView.backgroundColor = [UIColor whiteColor];
    processEntryView.layer.cornerRadius = 8.0f;
    processEntryView.layer.borderColor = [UIColor orangeColor].CGColor;
    processEntryView.layer.borderWidth = 2.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(processEntryView.frame.size.width/2-25, 5, 50, 30)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor orangeColor];
    label.text = [NSString stringWithFormat:@"%d",[selectedRun getRunId]];
    [processEntryView addSubview:label];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, processEntryView.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [processEntryView addSubview:separatorView];
    textfieldArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *parseObject = [self getParseRunProcessForRunId:[selectedRun getRunId]];
    for (int i=0; i < processArray.count; ++i) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 45+(i*30), 200, 30)];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = processArray[i];
        [processEntryView addSubview:label];
        label.tag = i+1;
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(200, 45+(i*30), 40, 30)];
        textfield.layer.borderColor = [UIColor darkGrayColor].CGColor;
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.layer.borderWidth = 1.0f;
        textfield.font = [UIFont systemFontOfSize:13.0f];
        textfield.text = @"0";
        textfield.tag = i+50;
        textfield.delegate = self;
        if (parseObject) {
            NSString *checkString = [label.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            checkString = [checkString stringByReplacingOccurrencesOfString:@"&" withString:@""];
            textfield.text = parseObject[checkString];
        }
        [textfieldArray addObject:textfield];
        [processEntryView addSubview:textfield];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    }
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 270, 80, 30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];

    [processEntryView addSubview:cancelButton];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 270, 80, 30)];
    [submitButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitPressed) forControlEvents:UIControlEventTouchUpInside];
    [processEntryView addSubview:submitButton];
    [self.view addSubview:processEntryView];
}

- (NSMutableDictionary*)getParseRunProcessForRunId:(int)runId {
    for (int i=0; i < parseRunProcesses.count; ++i) {
        NSMutableDictionary *parseObj = parseRunProcesses[i];
        if ([parseObj[@"RunId"] isEqualToString:[NSString stringWithFormat:@"%d",runId]]) {
            return parseObj;
        }
    }
    return nil;
}

- (IBAction)cancelPressed {
    NSLog(@"cacel Pressed");
    [processEntryView removeFromSuperview];
}

- (IBAction)submitPressed {
    processEntryView.hidden = true;
    int count = 0;
    for (int i=0; i < textfieldArray.count; ++i) {
        UITextField *textfield = textfieldArray[i];
        count = count+[textfield.text intValue];
    }
    NSLog(@"count = %d",count);
    _runInProcessTF.text = [NSString stringWithFormat:@"%d",count];
    
    NSMutableArray *runProcessesArray = [[NSMutableArray alloc] init];
    for (int i=0; i < processArray.count; ++i) {
        UITextField *processValueTextField = (UITextField*)[processEntryView viewWithTag:i+50];
        UILabel *processNameLabel = (UILabel*)[processEntryView viewWithTag:i+1];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processNameLabel.text,@"ProcessName",processValueTextField.text,@"Count", nil];
        [runProcessesArray addObject:dict];
    }
    [selectedRun setRunProcesses:runProcessesArray];
    //[self updateRunProcessData];
}

- (void)updateRunProcessData {
    PFQuery *query = [PFQuery queryWithClassName:@"RunProcesses"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[selectedRun getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        for (i=0; i < [objects count]; ++i) {
            PFObject *parseObject = [objects objectAtIndex:i];
            NSLog(@"Parse object = %@",parseObject);
            for (int i=0; i < processArray.count; ++i) {
                UITextField *processValueTextField = (UITextField*)[processEntryView viewWithTag:i+50];

                UILabel *processNameLabel = (UILabel*)[processEntryView viewWithTag:i+1];
                NSString *checkString = [processNameLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                checkString = [checkString stringByReplacingOccurrencesOfString:@"&" withString:@""];
                parseObject[checkString] = processValueTextField.text;
            }
            BOOL succeeded = [parseObject save];
            [processEntryView removeFromSuperview];

            if (succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving Data! Please Try Again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
            }
            //[_tableView reloadData];
        }
        
        if (i == [objects count]) {
            NSLog(@"saving selectted run  processes= %d",[selectedRun getRunId]);
            
            PFObject *parseObject = [PFObject objectWithClassName:@"RunProcesses"];
            parseObject[@"RunId"] = [NSString stringWithFormat:@"%d",[selectedRun getRunId]];
            for (int i=0; i < processArray.count; ++i) {
                UITextField *processValueTextField = (UITextField*)[processEntryView viewWithTag:i+50];
                
                UILabel *processNameLabel = (UILabel*)[processEntryView viewWithTag:i+1];
                NSString *checkString = [processNameLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                checkString = [checkString stringByReplacingOccurrencesOfString:@"&" withString:@""];
                parseObject[checkString] = processValueTextField.text;
            }
            NSLog(@"saving parse object = %@",parseObject);
            [__ParseDataManager setDelegate:self];
            [processEntryView removeFromSuperview];
            [__ParseDataManager saveParseData:parseObject];
            //[parseObject saveInBackground];
        }
    }];
}

- (void)getRunProcessData {
    PFQuery *query = [PFQuery queryWithClassName:@"RunProcesses"];
    //[query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[selectedRun getRunId]]];
    parseRunProcesses = [[query findObjects] mutableCopy];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (IBAction)backPressed {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark DragAndDropTableViewDelegate

-(void)tableView:(UITableView *)tableView willBeginDraggingCellAtIndexPath:(NSIndexPath *)indexPath placeholderImageView:(UIImageView *)placeHolderImageView
{
    // this is the place to edit the snapshot of the moving cell
    // add a shadow
    placeHolderImageView.layer.shadowOpacity = .3;
    placeHolderImageView.layer.shadowRadius = 1;
    
    
}

-(void)tableView:(DragAndDropTableView *)tableView didEndDraggingCellAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath placeHolderView:(UIImageView *)placeholderImageView
{
    // The cell has been dropped. Remove all empty sections (if you want to)
   /* NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for(int i = 0; i < [parseRuns count]; i++)
    {
        NSArray *ary = [parseRuns objectAtIndex:i];
        if(ary.count == 0)
            [indexSet addIndex:i];
    }
    
    [tableView beginUpdates];
    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [parseRuns removeObjectsAtIndexes:indexSet];
    [tableView endUpdates];*/
   /* Run *o = [parseRuns objectAtIndex:sourceIndexPath.row];

    [parseRuns replaceObjectAtIndex:sourceIndexPath.row withObject:[parseRuns objectAtIndex:toIndexPath.row]];
    [parseRuns replaceObjectAtIndex:toIndexPath.row withObject:o];
    //[_tableView reloadData];*/
    [tableView beginUpdates];
    [tableView endUpdates];

    NSLog(@"updates parse runs:%@",parseRuns);
}

-(CGFloat)tableView:tableView heightForEmptySection:(int)section
{
    return 10;
}

- (void)receivedSuccessResponse {
    NSLog(@"inside receivedSuccessResponse");
    if (!multipleUpdates) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)receivedErrorResponse {
    if (!multipleUpdates) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving data!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}


- (IBAction)tasklistPressed:(id)sender {
    TaskListViewController *taskListVC = [TaskListViewController new];
    [self.navigationController pushViewController:taskListVC animated:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    _tintView.hidden = true;
    selectedStatusIndex = anIndex;
    if ([statusArray[anIndex] isEqualToString:@"In Progress"]) {
        _qtyTitleLabel.text = @"InProcess Quantity";
        [self showQtyEntryView];
    }
    else if ([statusArray[anIndex] containsString:@"Ready For Dispatch"]) {
        _qtyTitleLabel.text = @"Ready Quantity";
        [self showQtyEntryView];
    }
    else {
        [selectedRun updateRunStatus:statusArray[selectedStatusIndex]];
        [__DataManager syncRun:[selectedRun getRunId]];
        __after(2, ^{
            [_tableView reloadData];
        });
    }
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    NSLog(@"selected Array = %@",ArryData);
}

- (void)DropDownListViewDidCancel{
    [dropDownList fadeOut];
}

- (void)getRunPlan {
    operationsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[selectedRun getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (objects.count == 0) {
            [self getProcessesForProductId:[self getProductId]];
            [self saveOperationsInParse];
        }
        else {
            operationsArray = [objects mutableCopy];
            [_tableView reloadData];
        }
    }];
}

- (void)saveOperationsInParse {
    [self.navigationController.view showActivityViewWithLabel:@"Setting Up Run Processes"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
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
    }
    __after(3, ^{
        [self.navigationController.view hideActivityView];
    });
    // [self getRunPlan];
}

- (void)getProcessesForProductId:(NSString*)productId {
    processesArray = [[NSMutableArray alloc] init];
    
    NSString *filename = [NSString stringWithFormat:@"%@_Processes",productId];
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      filename ofType:@"plist"];
    processesArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] mutableCopy];
    NSLog(@"processesArray=%@",processesArray);
    [self setUpOperationArray];
    
}

- (void)setUpOperationArray {
    operationsArray = [[NSMutableArray alloc] init];
    for(int i=0; i < processesArray.count; ++i) {
        NSMutableDictionary *processData = processesArray[i];
        NSMutableDictionary *operationData = [[NSMutableDictionary alloc] init];
        operationData[@"RunId"] = [NSString stringWithFormat:@"%d",[selectedRun getRunId]];
        operationData[@"ProductName"] = [selectedRun getProductName];
        operationData[@"ProductNumber"] = [selectedRun getProductNumber];
        operationData[@"OperationName"] = processData[@"name"];
        operationData[@"StationId"] = processData[@"stationId"];
        operationData[@"OperatorName"] = processData[@"operator"];
        operationData[@"DateAssigned"] = @"--";
        if ([processData[@"time"] intValue] >=3 ) {
            operationData[@"Time"] = processData[@"time"];
        }
        else {
            operationData[@"Time"] = [NSString stringWithFormat:@"%f",[processData[@"time"] floatValue]*[[selectedRun getRunData][@"Inprocess"] intValue]];
        }
        operationData[@"Quantity"] = [selectedRun getRunData][@"Inprocess"];
        operationData[@"Status"] = @"OPEN";
        [operationsArray addObject:operationData];
    }
}

- (NSString*)getProductId {
    NSString *productNumber = [selectedRun getProductNumber];
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

- (void)showQtyEntryView {
    _qtyEntryView.frame = CGRectMake(self.view.frame.size.width/2-_qtyEntryView.frame.size.width/2, self.view.frame.size.height/2-_qtyEntryView.frame.size.height/2, _qtyEntryView.frame.size.width, _qtyEntryView.frame.size.height);
    [self.view addSubview:_qtyEntryView];
}

- (IBAction)cancelEntryPressed:(id)sender {
    [_qtyEntryView removeFromSuperview];
}

- (IBAction)submitEntryPressed:(id)sender {
    [_qtyEntryView removeFromSuperview];
    int tag =0;
    if ([_qtyTitleLabel.text containsString:@"Ready"]) {
        tag = 1;
    }
    if ([_qtyTitleLabel.text containsString:@"Shipped"]) {
        tag = 2;
    }
    [selectedRun updateRunStatus:statusArray[selectedStatusIndex] withQty:[_qtyTF.text intValue] andTag:tag];
    [__DataManager syncRun:[selectedRun getRunId]];
    if ([selectedRun getCategory] == 1) {
        RunPlanViewController *runPlanVC = [[RunPlanViewController alloc] init];
        [runPlanVC setRun:selectedRun];
        [self.navigationController pushViewController:runPlanVC animated:NO];
    }
    else {
        __after(2, ^{
            [_tableView reloadData];
        });
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _tintView.hidden = true;
        [self DropDownListViewDidCancel];
    }
}

@end
