//
//  ScheduleRunsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ScheduleRunsViewController.h"
#import "DataManager.h"
#import "ServerManager.h"
#import "ScheduleRunsViewCell.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"


@interface ScheduleRunsViewController ()

@end

@implementation ScheduleRunsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    scheduleArray = @[@"This Week", @"Next Week"];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRuns) name:kNotificationRunsReceived object:nil];
    
    control = [[DZNSegmentedControl alloc] initWithItems:scheduleArray];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.selectedSegmentIndex = 0;
    control.frame = CGRectMake(0, 70, screenRect.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    thisWeekRunsArray = [[NSMutableArray alloc] init];
    nextWeekRunsArray = [[NSMutableArray alloc] init];
    thisWeekRunsArray = [__DataManager getThisWeekRuns];
    nextWeekRunsArray = [__DataManager getNextWeekRuns];
    runsArray = [__DataManager getRuns];

    [self filterRunList];
    if (runsArray.count == 0) {
        [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
        [self.navigationController.view hideActivityViewWithAfterDelay:50];
        [__ServerManager getRunsList];
    }
    else {
        [self filterRunsArray];
        [self setUpRunIds];
    }
    [control setCount:[NSNumber numberWithInt:thisWeekRunsArray.count] forSegmentAtIndex:0];
    [control setCount:[NSNumber numberWithInt:nextWeekRunsArray.count] forSegmentAtIndex:1];
}



- (void) initRuns {
    [self.navigationController.view hideActivityView];
    runsArray = [__DataManager getRuns];
    [self filterRunsArray];
    [self setUpRunIds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpRunIds {
    runIdsArray = [[NSMutableArray alloc] init];
    for (int i=0; i < runsArray.count; ++i) {
        Run *run = runsArray[i];
        
        [runIdsArray addObject:[NSString stringWithFormat:@"%d: %@",[run getRunId], [run getProductName]]];
    }
}

- (void)filterRunsArray {
    NSMutableArray *filteredRuns = [[NSMutableArray alloc] init];
    for (int i=0; i < runsArray.count; ++i) {
        Run *run = runsArray[i];
        if ([[run getStatus] isEqualToString:@"In Progress"]) {
            [filteredRuns addObject:run];
        }
    }
    runsArray = filteredRuns;
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
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    [self filterRunList];
}

- (IBAction)addRunPressed:(id)sender {
    [self showPopUpWithTitle:@"Select Option" withOption:runIdsArray xy:CGPointMake(16, 80) size:CGSizeMake(287, 280) isMultiple:YES];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
   // [_pickLocationButton setTitle:runIdsArray[anIndex] forState:UIControlStateNormal];d
    switch (control.selectedSegmentIndex) {
        case 0:{
            [thisWeekRunsArray addObject:[runsArray[anIndex] getRunData]];
            [runsArray removeObjectAtIndex:anIndex];
        }
            break;
        case 1:{
            [nextWeekRunsArray addObject:[runsArray[anIndex] getRunData]];
            [runsArray removeObjectAtIndex:anIndex];
        }
            break;
        default:
            break;
    }
    [self filterRunList];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    NSLog(@"selected Array = %@",ArryData);
    [self addRunsWithIds:ArryData];
}

- (void)DropDownListViewDidCancel{
    
}

- (void)addRunsWithIds:(NSMutableArray*)arrayData {
    for (int i=0; i < arrayData.count; ++i) {
        int runId = [[arrayData[i] substringToIndex:3] intValue] ;
        Run *run = [self getRunWithId:runId];
        if([self runExists:run]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Run already added!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            continue;
        }
        NSMutableDictionary *runData = [[NSMutableDictionary alloc] init];
        [runData setObject:[NSString stringWithFormat:@"%d",[run getRunId]] forKey:@"RunId"];
        [runData setObject:[run getProductName] forKey:@"ProductName"];
        [runData setObject:[run getProductNumber] forKey:@"ProductNumber"];
        [runData setObject:[NSString stringWithFormat:@"%@",[[run getRunData] objectForKey:@"Inprocess"]] forKey:@"Quantity"];
        [runData setObject:scheduleArray[control.selectedSegmentIndex] forKey:@"Schedule"];

        //[self removeRunWithId:runId];
        [self saveRunPlanForRun:run];
    }
    [self filterRunList];
}

- (BOOL)runExists:(Run*)run{
    switch (control.selectedSegmentIndex) {
        case 0: {
            if ([thisWeekRunsArray containsObject:run])
                return true;
        }
            break;
        case 1: {
            if([nextWeekRunsArray containsObject:run])
                return true;
        }
            break;
        default:
            break;
    }
    return false;
}

- (Run*)getRunWithId:(int)runId {
    for (int i=0; i < runsArray.count; ++i) {
        if ([runsArray[i] getRunId] == runId) {
            return runsArray[i];
        }
    }
    return nil;
}

- (void)removeRunWithId:(int)runId {
    for (int i=0; i < runsArray.count; ++i) {
        if ([runsArray[i] getRunId] == runId) {
            [runsArray removeObjectAtIndex:i];
        }
    }
}

- (void)filterRunList {
    switch (control.selectedSegmentIndex) {
        case 0: {
            filteredRunsArray = thisWeekRunsArray;
            [__DataManager setThisWeekRuns:thisWeekRunsArray];
        }
            break;
        case 1: {
            filteredRunsArray = nextWeekRunsArray;
            [__DataManager setNextWeekRuns:nextWeekRunsArray];
        }
            break;
        default:
            break;
    }
    [_tableView reloadData];
    [control setCount:[NSNumber numberWithInt:filteredRunsArray.count] forSegmentAtIndex:control.selectedSegmentIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredRunsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ScheduleRunsViewCell";
    ScheduleRunsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:[filteredRunsArray objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)saveRunPlanForRun:(Run*)run {
    PFObject *parseObject = [PFObject objectWithClassName:@"RunPlan"];
    parseObject[@"RunId"] = [NSString stringWithFormat:@"%d",[run getRunId]];
    parseObject[@"ProductName"] = [run getProductName];
    parseObject[@"ProductNumber"] = [run getProductNumber];
    parseObject[@"Schedule"] = scheduleArray[control.selectedSegmentIndex];
    parseObject[@"Quantity"] = [NSString stringWithFormat:@"%@",[[run getRunData] objectForKey:@"Inprocess"]];
    NSLog(@"saving parse object = %@",parseObject);
    BOOL succeeded = [parseObject save];
    if (succeeded) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data Saved Successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        switch (control.selectedSegmentIndex) {
            case 0:{
                [thisWeekRunsArray addObject:parseObject];
            }
                break;
            case 1:{
                [nextWeekRunsArray addObject:parseObject];
            }
                break;
            default:
                break;
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error in saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void) deleteRunAtIndex:(int)index {
    PFObject *parseObject = filteredRunsArray[index];
    [parseObject delete];
    [filteredRunsArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

@end
