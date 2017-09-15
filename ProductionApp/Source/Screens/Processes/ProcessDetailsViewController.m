//
//  ProcessDetailsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 10/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "ProcessDetailsViewController.h"

@interface ProcessDetailsViewController ()

@end

@implementation ProcessDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Process Detail";
    dataArray = [[NSMutableArray alloc] initWithObjects:@"Work Instructions", @"Checklist", @"Defects", nil];
    _timerLabel.timerType = MZTimerLabelTypeStopWatch;
    _timerLabel.timeLabel.textAlignment = NSTextAlignmentRight;
    _processNameLabel.text = [process getProcessName];
    _timedLoggedLabel.text = [self formatTimeFromSeconds:[process getTimeLogged]];
    statusButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = statusButton;
    switch ([process getProcessStatus]) {
        case 0: {
            _statusLabel.text = @"Open";
            _timerButton.enabled = false;
            [statusButton setTitle:@"Start"];
        }
            break;
        case 1: {
            _statusLabel.text = @"In Progress";
            _timerButton.enabled = true;
            [statusButton setTitle:@"Close"];
        }
            break;
        case 2: {
            _statusLabel.text = @"Closed";
            _timerButton.enabled = false;
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [process setTimeLogged:[process getTimeLogged]+[_timerLabel getTimeCounted]];
    NSLog(@"time counted = %f",[_timerLabel getTimeCounted]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)formatTimeFromSeconds:(int)numberOfSeconds
{
    
    int seconds = numberOfSeconds % 60;
    int minutes = (numberOfSeconds / 60) % 60;
    int hours = numberOfSeconds / 3600;
    
    //we have >=1 hour => example : 3h:25m
    if (hours) {
        return [NSString stringWithFormat:@"%dh:%02dm", hours, minutes];
    }
    //we have 0 hours and >=1 minutes => example : 3m:25s
    if (minutes) {
        return [NSString stringWithFormat:@"%dm:%02ds", minutes, seconds];
    }
    //we have only seconds example : 25s
    return [NSString stringWithFormat:@"%ds", seconds];
}

- (void)setProcess:(Process*)process_ {
    process = process_;
}

- (void)setJob:(Job *)job_ {
    job = job_;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.tintColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([process getProcessStatus] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"You need to start the process to access this list" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    switch (indexPath.row) {
        case 0:{
            WorkInstructionsViewController *workInstructionsVC = [[WorkInstructionsViewController alloc] initWithNibName:@"WorkInstructionsViewController" bundle:nil];
            [workInstructionsVC setDelegate:self];
            [self.navigationController pushViewController:workInstructionsVC animated:true];
        }
            break;
        case 1:{
            ChecklistViewController *checklistVC = [[ChecklistViewController alloc] initWithNibName:@"ChecklistViewController" bundle:nil];
            [checklistVC setDelegate:self];
            [self.navigationController pushViewController:checklistVC animated:true];
        }
            break;
        case 2:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Coming Soon!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (IBAction)timerButtonPressed: (id)sender{
    NSLog(@"Timer button pressed");
    if (!timerRunning) {
        timerRunning = true;
        [_timerLabel start];
        [_timerButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else {
        timerRunning = false;
        [_timerLabel pause];
        [_timerButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
       // [process setTimeLogged:[process getTimeLogged]+[_timerLabel getTimeCounted]];
        _timedLoggedLabel.text = [self formatTimeFromSeconds:[process getTimeLogged]+[_timerLabel getTimeCounted]];
    }
}

- (void)doneButtonPressed:(id)sender {
    switch ([process getProcessStatus]) {
        case 0: {
            NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
            NSString *dateString = [dateFormat stringFromDate:today];
            NSLog(@"Date: %@", dateString);
            _startDateLabel.text = dateString;
            [process setStartDate:dateString];
            _timerButton.enabled = true;
            [statusButton setTitle:@"Close"];
            [process setProcessStatus:1];
        }
            break;
        case 1: {
            [process setProcessStatus:2];
            NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
            NSString *dateString = [dateFormat stringFromDate:today];
            NSLog(@"Date: %@", dateString);
            _stopDateLabel.text = dateString;
            _timerButton.enabled = false;
            [process setStopDate:dateString];
            [process setStartDate:dateString];
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        default:
            break;
    }
}


//WorkInstructionDelegate methods
- (void)workInstructionsDone {
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

//ChecklistDelegate methods
- (void)checklistDone {
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
