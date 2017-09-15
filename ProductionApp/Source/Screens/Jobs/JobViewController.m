//
//  JobViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "JobViewController.h"
#import "DataManager.h"
#import "Checklist.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "ScannerViewController.h"
#import "AddDefectViewController.h"
#import "DefectsListViewController.h"

@interface JobViewController ()

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProcess:(Process*)process_ {
    process = process_;
    [self writeProcessData];
}

- (void)initView {
    jobs = [[NSMutableArray alloc] init];
    int processIndex = [[[process getProcessId] substringFromIndex:2] intValue]-1;
    run = [__DataManager getRunWithId:[__DataManager getCurrentRunId]];
    NSMutableArray *processJobs = [process getProcessJobs];
    for (int i=0; i < [processJobs count]; ++i) {
        Job *job = processJobs[i];
        if ([job getJobType]<2) {
            [jobs addObject:job];
        }
    }
    NSLog(@"jobs count =%d",[jobs count]);
    _timerLabel.timerType = MZTimerLabelTypeStopWatch;
    if ([jobs count] == 0) {
        _jobView.hidden = true;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Jobs to show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        //[alertView show];
        NSLog(@"no Jobs to show");
    }
    else {
        [self reloadJob];
    }
}

- (void)reloadJob {
    if (currentJobIndex == 0) {
        _prevButton.alpha = 0.5;
    }
    if (currentJobIndex == [jobs count]-1) {
        _nextButton.alpha = 0.5;
    }
    if (currentJobIndex == [jobs count]) {
        _nextButton.alpha = 0.5;
    }
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    _startButton.backgroundColor = [UIColor colorWithRed:0.145 green:0.737 blue:0.490 alpha:1.000];
    [_timerLabel reset];
    _startButton.enabled = true;
   // _nextButton.alpha = 0.5;
   // _prevButton.alpha = 0.5;
    Job *job = [jobs objectAtIndex:currentJobIndex];
    currentJob = job;
    _jobIdLabel.text = [job getJobId];
    _jobCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[process getJobsDone] count]];
    _jobsRemaining.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[process getProcessJobs] count]];
    int processIndex = [[[process getProcessId] substringFromIndex:2] intValue]-1;
    if ([job getJobType]>2) {
        [_startButton setTitle:@"Done" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor lightGrayColor];
        _startButton.enabled = false;
    }
}

- (void)reloadJob:(Job*)job {
    currentJob = job;
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    _startButton.backgroundColor = [UIColor colorWithRed:0.145 green:0.737 blue:0.490 alpha:1.000];
    [_timerLabel reset];
    _startButton.enabled = true;
    // _nextButton.alpha = 0.5;
    // _prevButton.alpha = 0.5;
    _jobIdLabel.text = [job getJobId];
    _jobCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[process getJobsDone] count]];
    _jobsRemaining.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[process getProcessJobs] count]];
    if ([job getJobType] > 2) {
        [_startButton setTitle:@"Done" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor lightGrayColor];
        _startButton.enabled = false;
    }
}

- (void)showChecklistView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _checklistView.frame = CGRectMake(screenRect.size.width, _checklistView.frame.origin.y, _checklistView.frame.size.width, _checklistView.frame.size.height);
    if (!checklistArray) {
        checklistArray = [process getChecklist];
        NSLog(@"Checklist array = %@",checklistArray);
    }
    if (currentChecklistIndex == [checklistArray count]) {
        _checklistView.hidden = true;
        _backView.hidden = true;
        [_startButton setTitle:@"Done" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor lightGrayColor];
        _startButton.enabled = false;
        _nextButton.alpha = 1.0;
        [process finishedJob:[[jobs objectAtIndex:currentJobIndex] getJobId]];
        currentJobIndex++;
        if (currentJobIndex == [jobs count]) {
            currentJobIndex--;
            _nextButton.alpha = 0.5;
        }
        [self reloadJob];
        [currentJob setJobType:2];
        [self writeJobDataForType:0];
    }
    else {
        Checklist *checklist = checklistArray[currentChecklistIndex];
        _checklistTextView.text = [checklist getChecklistText];
        _checklistView.hidden = false;
        _backView.hidden = false;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        _checklistView.frame = CGRectMake(0, _checklistView.frame.origin.y, _checklistView.frame.size.width, _checklistView.frame.size.height);
        [UIView commitAnimations];
    }
}

- (IBAction)startPressed:(id)sender {
    if (jobStarted) {
        jobStarted = false;
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor colorWithRed:0.145 green:0.737 blue:0.490 alpha:1.000];
        [_timerLabel pause];
        NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        NSString *dateString = [dateFormat stringFromDate:today];
        [currentJob setStopDate:dateString];
        [self showChecklistView];
    }
    else {
        NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        NSString *dateString = [dateFormat stringFromDate:today];
        [currentJob setStartDate:dateString];
        [currentJob setJobType:1];
        jobStarted = true;
        currentChecklistIndex = 0;
        [_startButton setTitle:@"Stop" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor redColor];
        [_timerLabel start];
    }
}

- (IBAction)prevPressed:(id)sender {
    if (currentJobIndex>0) {
        currentJobIndex--;
        [self reloadJob];
    }
    else {
        _prevButton.alpha = 0.5;
    }
}

- (IBAction)nextPressed:(id)sender {
    if (currentJobIndex < [jobs count]-1) {
        currentJobIndex++;
        [self reloadJob];
    }
    else {
        _nextButton.alpha = 0.5;
    }
}

- (IBAction)workInstrPressed:(id)sender {
    WorkInstructionsViewController *workInstructionsVC = [[WorkInstructionsViewController alloc] initWithNibName:@"WorkInstructionsViewController" bundle:nil];
    [workInstructionsVC setDelegate:self];
    [workInstructionsVC setInstructions:[process getWorkInstructions]];
    [self.navigationController pushViewController:workInstructionsVC animated:true];
}

- (IBAction)addDefectPressed:(id)sender {
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Defect" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Add to existing Defect",@"Create new Defect", nil];
    [alertView show];*/
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Move to" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rework", @"Reject", nil];
    [alertView show];
}

- (IBAction)scanBarcodePressed:(id)sender {
    ScannerViewController *scannerViewController = [ScannerViewController new];
    scannerViewController.delegate = self;
    [self.navigationController pushViewController:scannerViewController animated:NO];
}

- (IBAction)yesPressed:(id)sender {
    currentChecklistIndex++;
    [self showChecklistView];
}

- (IBAction)noPressed:(id)sender {
    //Add Defect
    
    currentChecklistIndex++;
    [self showChecklistView];
}

//ScannerViewDelegate method
- (void) barcodeFound:(NSString*)code {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Barcode Found" message:code delegate:nil cancelButtonTitle:@"View" otherButtonTitles:nil];
    [alertView show];
    for (int i = 0; i < [jobs count]; ++i) {
        Job *job = [jobs objectAtIndex:i];
        if ([[job getJobId] isEqualToString:code]) {
            NSLog(@"job id found");
            currentJobIndex = i;
            [self reloadJob];
            break;
        }
    }
}

//UISearchBarDelegate methods

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"did end editing");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clicked");
    for (int i = 0; i < [jobs count]; ++i) {
        Job *job = [jobs objectAtIndex:i];
        if ([[job getJobId] isEqualToString:searchBar.text]) {
            NSLog(@"job id found");
            currentJobIndex = i;
            [self reloadJob];
            break;
        }
    }
    NSMutableArray *doneJobs = [process getJobsDone];
    for (int i = 0; i < [doneJobs count]; ++i) {
        Job *job = [doneJobs objectAtIndex:i];
        if ([[job getJobId] isEqualToString:searchBar.text]) {
            NSLog(@"job id found");
            [self reloadJob:job];
            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            currentJobIndex++;
            [currentJob setJobType:3];
            [self writeJobDataForType:1];
            [self reloadJob];
        }
            break;
        case 2:{
            currentJobIndex++;
            [currentJob setJobType:4];
            [self writeJobDataForType:2];
            [self reloadJob];
        }
            break;
        default:
            break;
    }
}

- (void)writeProcessData {
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
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    //here add elements to data file and write data to file
    NSMutableDictionary *dictionary = [data objectForKey:dateString];

    NSMutableDictionary *processDictionary = [dictionary objectForKey:[process getProcessName]];
    if (!processDictionary) {
        NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[process getProcessName],@"Name",[process getProcessId],@"Id",@"0",@"Quantity",@"0",@"Rework",@"0",@"Reject", [__User getUsername],@"Operator" , nil];
        [dictionary setObject:processDictionary forKey:[process getProcessName]];
        NSLog(@"data = %@",data);
        [data setObject:dictionary forKey:dateString];
        [data writeToFile: path atomically:YES];
    }
}

- (void)writeJobDataForType:(int)type {
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
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    //here add elements to data file and write data to file
    NSMutableDictionary *dictionary = [data objectForKey:dateString];
    NSMutableDictionary *processDictionary = [dictionary objectForKey:[process getProcessName]];
    
    int quantity = [[processDictionary valueForKey:@"Quantity"] intValue];
    [processDictionary setObject:[[NSNumber numberWithInt:quantity+1] stringValue] forKey:@"Quantity"];
    NSLog(@"data = %@",data);
    if (type == 1) {
        int rework = [[processDictionary valueForKey:@"Rework"] intValue];
        [processDictionary setObject:[[NSNumber numberWithInt:rework+1] stringValue] forKey:@"Rework"];
    }
    if (type == 2) {
        int reject = [[processDictionary valueForKey:@"Reject"] intValue];
        [processDictionary setObject:[[NSNumber numberWithInt:reject+1] stringValue] forKey:@"Reject"];
    }
    [dictionary setObject:processDictionary forKey:[process getProcessName]];
    [data setObject:dictionary forKey:dateString];
    [data writeToFile: path atomically:YES];
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
