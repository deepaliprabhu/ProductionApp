//
//  StatsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "OpenRunsStatsViewController.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "RunDetailsViewController.h"
#import "TaskListViewController.h"

@interface OpenRunsStatsViewController ()

@end

@implementation OpenRunsStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Open Runs";
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRuns) name:kNotificationRunsReceived object:nil];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    _cellDetailView.layer.borderColor = [UIColor orangeColor].CGColor;
    _cellDetailView.layer.borderWidth = 1.0f;
    _cellDetailView.layer.cornerRadius = 10.0f;
    
    runTypeFilters = @[@"ALL", @"PROD PCB", @"PROD ASSM", @"DEV"];
    
    periodControl = [[DZNSegmentedControl alloc] initWithItems:runTypeFilters];
    periodControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    periodControl.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 50);
    
    [periodControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:periodControl];
   // [self fetchParseRuns];
    //serverRuns = [__DataManager getRuns];
    filteredRuns = parseRuns;
    [self filterRunsForIndex:1];
    [periodControl setCount:[NSNumber numberWithInt:filteredRuns.count] forSegmentAtIndex:1];
    [self filterRunsForIndex:2];
    [periodControl setCount:[NSNumber numberWithInt:filteredRuns.count] forSegmentAtIndex:2];
    [self filterRunsForIndex:3];
    [periodControl setCount:[NSNumber numberWithInt:filteredRuns.count] forSegmentAtIndex:3];
    [self filterRunsForIndex:0];
    [periodControl setCount:[NSNumber numberWithInt:filteredRuns.count] forSegmentAtIndex:0];
    [_tableView reloadData];
}

- (void) initRuns {
    parseRuns = [__DataManager getRuns];
    filteredRuns = parseRuns;
    [self.navigationController.view hideActivityView];
}

- (void)refreshButtonPressed {
    [self.navigationController.view showActivityViewWithLabel:@"fetching runs"];
    [__ServerManager getRunsList];
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    
    [self filterRunsForIndex:control.selectedSegmentIndex];
    [periodControl setCount:[NSNumber numberWithInteger:filteredRuns.count] forSegmentAtIndex:periodControl.selectedSegmentIndex];
    [_tableView reloadData];
}

- (void)filterRunsForIndex:(int)index {
    switch (index) {
        case 0:
            filteredRuns = parseRuns;
            break;
        case 1: {
            filteredRuns = [[NSMutableArray alloc] init];
            for (int i=0; i < parseRuns.count; ++i) {
                Run *run = parseRuns[i];
                if ([[run getRunType] isEqualToString:@"Production"]) {
                    if ([run getCategory] == 0) {
                        [filteredRuns addObject:run];
                    }
                }
            }
        }
            break;
        case 2: {
            filteredRuns = [[NSMutableArray alloc] init];
            for (int i=0; i < parseRuns.count; ++i) {
                Run *run = parseRuns[i];
                if ([[run getRunType] isEqualToString:@"Development"]) {
                    if ([run getCategory] == 1) {
                        [filteredRuns addObject:run];
                    }
                }
            }
        }
            break;
        case 3: {
            filteredRuns = [[NSMutableArray alloc] init];
            for (int i=0; i < parseRuns.count; ++i) {
                Run *run = parseRuns[i];
                if ([[run getRunType] isEqualToString:@"Development"]) {
                        [filteredRuns addObject:run];
                }
            }
        }
            break;
        default:
            break;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)setParseData:(NSMutableArray*)parseRuns_ {
    NSLog(@"parseruns = %@",parseRuns_);
    parseRuns = parseRuns_;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (periodControl.selectedSegmentIndex == 0) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    destIndex = destinationIndexPath.row;
    srcIndex = sourceIndexPath.row;
    Run *o = [filteredRuns objectAtIndex:sourceIndexPath.row];
    [filteredRuns replaceObjectAtIndex:sourceIndexPath.row withObject:[filteredRuns objectAtIndex:destinationIndexPath.row]];
    [filteredRuns replaceObjectAtIndex:destinationIndexPath.row withObject:o];
    [_tableView reloadData];
    [self updateRuns];
    NSLog(@"updates parse runs:%@",filteredRuns);
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleInsert == editingStyle)
    {
        // inserts are always done at the end
        
        [tableView beginUpdates];
        [filteredRuns addObject:[NSMutableArray array]];
        [tableView insertSections:[NSIndexSet indexSetWithIndex:[filteredRuns count]-1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
    }
    else if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        // check if we are going to delete a row or a section
        [tableView beginUpdates];
        if([[filteredRuns objectAtIndex:indexPath.section] count] == 0)
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [filteredRuns removeObjectAtIndex:indexPath.section];
        }
        else
        {
            // Delete the row from the table view.
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            // Delete the row from the data source.
            [[filteredRuns objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        }
        [tableView endUpdates];
    }
}

#pragma mark -


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredRuns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RunStatsCell";
    RunStatsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
   
    Run *run = [filteredRuns objectAtIndex:indexPath.row];
    BOOL show = false;

    [cell setCellData:[run getRunData] notes:show];
    //cell.textLabel.text = run[@"RunId"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Run *run = [filteredRuns objectAtIndex:indexPath.row];
   // NSLog(@"selected run = %d",[run[@"RunId"] intValue]);
    /*PFObject *cellData = [parseRuns objectAtIndex:indexPath.row];
    _cellDetailView.hidden = false;
    _tintedView.hidden = false;
    _titleLabel.text = [NSString stringWithFormat:@"%@:%@",[cellData objectForKey:@"RunId"], [cellData objectForKey:@"ProductName"]];
    _closedProcLabel.text = cellData[@"ClosedProcesses"];
    _openProcLabel.text = cellData[@"OpenProcesses"];
    _rejectLabel.text = cellData[@"Rejects"];
    _reworkLabel.text = cellData[@"Reworks"];
    _defectLabel.text = cellData[@"Defects"];*/
    RunDetailsViewController *runDetailsVC = [[RunDetailsViewController alloc] initWithNibName:@"RunDetailsViewController" bundle:nil];
    [runDetailsVC setRun:run];
   // [runDetailsVC setRunData:[run getRunData]];
    [self.navigationController pushViewController:runDetailsVC animated:true];
}

- (IBAction)closeDetailView:(id)sender {
    _cellDetailView.hidden = true;
    _tintedView.hidden = true;
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
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(CGFloat)tableView:tableView heightForEmptySection:(int)section
{
    return 10;
}

- (void)updateRuns {
    multipleUpdates = true;
    [self.navigationController.view showActivityViewWithLabel:@"updating runs"];
    if (srcIndex<destIndex) {
        for (int i=srcIndex; i <= destIndex; ++i) {
            Run *run = filteredRuns[i];
            [run setSequenceNum:i];
            [__DataManager syncRun:[run getRunId]];
        }
    }
    else {
        for (int i=destIndex; i <= srcIndex; ++i) {
            Run *run = filteredRuns[i];
            [run setSequenceNum:i];
            [__DataManager syncRun:[run getRunId]];
        }
    }
    [self.navigationController.view hideActivityView];
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
