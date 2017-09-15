//
//  JobDetailsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 06/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "JobDetailsViewController.h"
#import "ProcessListViewController.h"
#import "AddDefectViewController.h"
#import "DefectsListViewController.h"
#import "DataManager.h"

@interface JobDetailsViewController ()

@end

@implementation JobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    dataArray = [[NSMutableArray alloc] initWithObjects:@"View Processes", @"View Defects", @"Add Defect", nil];
    Run *run = [__DataManager getRunWithId:[__DataManager getCurrentRunId]];
    if ([__DataManager getCurrentRunId]==246) {
        if (![job getJobDetails]) {
            [__ServerManager getJobsDetailsForJobId:[job getJobId]];
            [__ServerManager setDelegate:self];
        }
    }
    [self initView];
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

- (void)setJob:(Job*)job_ {
    job = job_;
}

- (void)initView {
    statusButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = statusButton;
    self.title = [NSString stringWithFormat:@"%@",[job getJobId]];
   // productIdLabel.text = [NSString stringWithFormat:@"%@",[job getProductId]];
   // productNameLabel.text = [job getProductName];
    startDateLabel.text = [job getStartDate];
    stopDateLabel.text = [job getStopDate];
    defectsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[job getJobDefects] count]];
    switch ([job getJobStatus]) {
        case 0: {
            statusLabel.text = @"Open";
            [statusButton setTitle:@"Start"];
        }
            break;
        case 1: {
            statusLabel.text = @"In Progress";
            [statusButton setTitle:@"Close"];
        }
            break;
        case 2: {
            statusLabel.text = @"Closed";
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        default:
            break;
    }
}

- (void)doneButtonPressed:(id)sender {
    switch ([job getJobStatus]) {
        case 0: {
            NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
            NSString *dateString = [dateFormat stringFromDate:today];
            NSLog(@"Date: %@", dateString);
            startDateLabel.text = dateString;
            [job setStartDate:dateString];
            [statusButton setTitle:@"Close"];
            [job setStatus:1];
            statusLabel.text = @"In Progress";
        }
            break;
        case 1: {
            [job setStatus:2];
            statusLabel.text = @"Closed";
            NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
            NSString *dateString = [dateFormat stringFromDate:today];
            NSLog(@"Date: %@", dateString);
            stopDateLabel.text = dateString;
            [job setStopDate:dateString];
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        default:
            break;
    }
}

- (IBAction)startJobPressed: (id)sender{
     ProcessListViewController *processListVC = [[ProcessListViewController alloc] initWithNibName:@"ProcessListViewController" bundle:nil];
    [self.navigationController pushViewController:processListVC animated:true];
}


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
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([job getJobStatus] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"You need to start the job to access this list" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    switch (indexPath.row) {
        case 0:{
            ProcessListViewController *processListVC = [[ProcessListViewController alloc] initWithNibName:@"ProcessListViewController" bundle:nil];
            [self.navigationController pushViewController:processListVC animated:true];
        }
            break;
        case 1: {
            if ([[job getJobDefects] count] > 0) {
                DefectsListViewController *defectsListVC = [[DefectsListViewController alloc] initWithNibName:@"DefectsListViewController" bundle:nil];
                [defectsListVC setSelectedJob:job];
                [self.navigationController pushViewController:defectsListVC animated:true];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"View Defects" message:@"\nNo Defects found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        }
            break;
        case 2:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Defect" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Add to existing Defect",@"Create new Defect", nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            if ([[job getJobDefects] count] > 0) {
                DefectsListViewController *defectsListVC = [[DefectsListViewController alloc] initWithNibName:@"DefectsListViewController" bundle:nil];
                [defectsListVC setListType:1];
                [defectsListVC setSelectedJob:job];
                [self.navigationController pushViewController:defectsListVC animated:true];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"View Defects" message:@"\nNo Defects found" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alertView show];
            }
        }
            break;
        case 2:{
            AddDefectViewController *addDefectVC = [[AddDefectViewController alloc] initWithNibName:@"AddDefectViewController" bundle:nil];
            NSMutableArray *jobs = [[NSMutableArray alloc] initWithObjects:job, nil];
            [addDefectVC setJobs:jobs];
            [self.navigationController pushViewController:addDefectVC animated:true];
        }
            break;
        default:
            break;
    }
}

- (void)receivedServerResponse {
    [self initView];
}


@end
