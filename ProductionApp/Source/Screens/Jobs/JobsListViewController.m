//
//  JobsListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "JobsListViewController.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Job.h"
#import "JCDemo1.h"
#import "JobDetailsViewController.h"
#import "ProcessListViewController.h"
#import "AddDefectViewController.h"

@interface JobsListViewController ()

@end

@implementation JobsListViewController
@synthesize gmDemo = _gmDemo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Run Jobs";

    jobIdArray = [NSArray arrayWithObjects:@"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", @"JN1", nil];
    filteredJobArray = [[NSMutableArray alloc] init];
    UINib *cellNib = [UINib nibWithNibName:@"JobListCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"JobListCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(60, 60)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    jobActions = [@[@"Set status", @"Set Start Time", @"Set Process status", @"Add Defect", @"Move To", @"Set Stop Time"] mutableCopy];
    statusActions = [@[@"Open", @"In Progress", @"Completed"] mutableCopy];
    //jobTypeActions = [@[@"Open",@"Ongoing",@"Closed", @"Rework", @"Reject"] mutableCopy];
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [_collectionView reloadData];
}

- (void)setJobTypeArray:(NSMutableArray*)jobTypeArray_ {
    jobTypeActions = jobTypeArray_;
}

- (void)initView {
    modeCheckbox = [[M13Checkbox alloc] init];
    modeCheckbox.checkColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    modeCheckbox.strokeColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    modeCheckbox.frame = CGRectMake(6, 1, 40, 40);
    [modeCheckbox addTarget:self action:@selector(checkChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_menuView addSubview:modeCheckbox];
    
    JCDemo1 *_demo1 = [[JCDemo1 alloc] init];
    _demo1.delegate = self;
    [_menuView addSubview:_demo1.view];
    
    //[_collectionView reloadData];
}

- (void)checkChangedValue:(id)sender {
    if (modeCheckbox.checkState == M13CheckboxStateChecked) {
        multiMode = true;
        _actionButton.hidden = false;
    }
    else {
        multiMode = false;
        _actionButton.hidden = true;
        [self deselectAll];
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

- (void)setRun:(Run*)run_ {
    run = run_;
}

- (void)setJobType:(int)jobType {
    selectedJobType = jobType;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (filtered) {
        return [filteredJobArray count];
    }
    else {
        return [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"JobListCell";

    JobListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil][0];
    }
    if (filtered) {
        Job *job = [filteredJobArray objectAtIndex:indexPath.row];
        [cell setJobData:job];
    }
    else {
        Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:indexPath.row];
        [cell setJobData:job];
    }
    [cell setDelegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (multiMode) {
        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isCellSelected]) {
            [cell deselectCell];
        }
        else
            [cell selectCell];
    }
    else {
        JobDetailsViewController *jobDetailsVC = [[JobDetailsViewController alloc] initWithNibName:@"JobDetailsViewController" bundle:nil];
        Job *job;
        if (filtered) {
            job = [filteredJobArray objectAtIndex:indexPath.row];
        }
        else {
            job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:indexPath.row];
        }
        [jobDetailsVC setJob:job];
        [self.navigationController pushViewController:jobDetailsVC animated:true];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (multiMode) {
        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        //[cell deselectCell];
    }
}


- (IBAction)actionButtonPressed:(id)sender {
    /*CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Select Action" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:252.0f/255 green:122.0f/255 blue:64.0f/255 alpha:1];
    [picker show];*/
    ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
    [actionPickerView initViewWithArray:jobActions andTag:0];
    actionPickerView.delegate = self;
    actionPickerView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:actionPickerView];
}

- (IBAction)selectButtonPressed:(id)sender {
    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (selectedAll) {
            [cell deselectCell];
        }
        else
            [cell selectCell];
    }
    if (selectedAll) {
        selectedAll = false;
        multiMode = false;
        _actionButton.hidden = true;
        [modeCheckbox setCheckState:M13CheckboxStateUnchecked];
        [_selectButton setTitle:@"Select all" forState:UIControlStateNormal];
    }
    else {
        selectedAll = true;
        multiMode = true;
        _actionButton.hidden = false;
        [modeCheckbox setCheckState:M13CheckboxStateChecked];
        [_selectButton setTitle:@"Deselect all" forState:UIControlStateNormal];
    }

    //[_collectionView reloadData];
}

- (void)deselectAll {
    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell deselectCell];
    }
}

- (IBAction)jobTypeButtonPressed:(UIButton*)sender {
    selectedJobType = sender.tag;
    [_collectionView reloadData];
    switch (selectedJobType) {
        case 0:
            _selectedJobBarView.backgroundColor = [UIColor colorWithRed:63.0f/255 green:195.0f/255 blue:128.0f/255 alpha:1];
            break;
        case 1:
            _selectedJobBarView.backgroundColor = [UIColor colorWithRed:129.0f/255 green:207.0f/255 blue:224.0f/255 alpha:1];
            break;
        case 2:
            _selectedJobBarView.backgroundColor = [UIColor colorWithRed:231.0f/255 green:76.0f/255 blue:60.0f/255 alpha:1];
            break;
           
        default:
            break;
    }
}

//JobListCellDelegate methods

- (void) setMultiMode:(BOOL)value {
    multiMode = value;
}


//ActionPickerDelegate methods
- (void) selectedActionIndex:(int)index withTag:(int)tag {
    switch (tag) {
        case 0: {
            switch (index) {
                case 0:
                    [self showStatusActionList];
                    break;
                case 1:
                    [self showDatePickerWithTag:0];
                    break;
                case 2: {
                    ProcessListViewController *processListVC = [[ProcessListViewController alloc] initWithNibName:@"ProcessListViewController" bundle:nil];
                    [processListVC setMultiMode:true];
                    [self.navigationController pushViewController:processListVC animated:true];
                    [self deselectAll];
                }
                    break;
                case 3: {
                    [self addDefects];
                    [self deselectAll];
                }
                    break;
                case 4:
                    [self showJobTypeActionList];
                    break;
                case 5:
                    [self showDatePickerWithTag:1];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (index) {
                case 0:{
                    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
                        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        if ([cell isCellSelected]) {
                            Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:i];
                            [job setJobType:index];
                        }
                    }
                    [self deselectAll];
                    [_collectionView reloadData];
                }
                    break;
                case 1:{
                    NSMutableArray *runjobs = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType];
                    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
                        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        if ([cell isCellSelected]) {
                            Job *job = [runjobs objectAtIndex:i];
                            [job setJobType:index];
                        }
                    }
                    [self deselectAll];
                    [_collectionView reloadData];
                }
                    break;
                case 2: {
                    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
                        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        if ([cell isCellSelected]) {
                            Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:i];
                            [job setJobType:index];
                        }
                    }
                    [self deselectAll];
                    [_collectionView reloadData];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2: {
            for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
                JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if ([cell isCellSelected]) {
                    Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:i];
                    [job setJobType:index];
                }
            }
            [self deselectAll];
            [_collectionView reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)addDefects {
    NSMutableArray *selectedJobs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell isCellSelected]) {
            Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:i];
            [selectedJobs addObject:job];
        }
    }
    AddDefectViewController *addDefectVC = [[AddDefectViewController alloc] initWithNibName:@"AddDefectViewController" bundle:nil];
    [addDefectVC setJobs:selectedJobs];
    [self.navigationController pushViewController:addDefectVC animated:true];
}

- (void)showStatusActionList {
    ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
    [actionPickerView initViewWithArray:statusActions andTag:1];
    actionPickerView.delegate = self;
    actionPickerView.backgroundColor = [UIColor clearColor];
}

- (void)showJobTypeActionList {
    ActionPickerView *actionPickerView = [[ActionPickerView alloc] init];
    [actionPickerView initViewWithArray:jobTypeActions andTag:2];
    actionPickerView.delegate = self;
    actionPickerView.backgroundColor = [UIColor clearColor];
}

- (void)showDatePickerWithTag:(int)tag_ {
    NSLog(@"showing date picker");
    
    //Init the datePicker view and set self as delegate
    SBFlatDatePicker *datePicker = [[SBFlatDatePicker alloc] initWithFrame:self.view.bounds];
    [datePicker setDelegate:self];
    datePicker.tag = tag_;
    
    //OPTIONAL: Choose the background color
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    
    //OPTIONAL - Choose Date Range (0 starts At Today. Non continous sets acceptable (use some enumartion for [indexSet addIndex:yourIndex];
    datePicker.dayRange = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 365)];
    
    
    //OPTIONAL - Choose Minute  Non continous sets acceptable (use some enumartion for [indexSet addIndex:yourIndex];
    datePicker.minuterange = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 59)];
    
    //Customize date format
    datePicker.dayFormat = @"EEE MMM dd";
    
    
    //Set the data picker as view of the new view controller
    [self.view addSubview:datePicker];
    
    //Present the view controller
    //[self presentViewController:pickerViewController animated:YES completion:nil];
}

//Delegate
-(void)flatDatePicker:(SBFlatDatePicker *)datePicker saveDate:(NSDate *)date{
    NSLog(@"%@",[date description]);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSString *dateString = [dateFormat stringFromDate:date];

    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
        JobListCell *cell = (JobListCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell isCellSelected]) {
            Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:i];
            if (datePicker.tag == 0) {
                [job setStartDate:dateString];
            }
            else
                [job setStopDate:dateString];
            
        }
    }
    [self deselectAll];
    [_collectionView reloadData];
}


//SearchProtocol delegate methods
- (void)searchWithText:(NSString*)text {
    filtered = true;
    filteredJobArray = [[NSMutableArray alloc] init];
    NSLog(@"searching text = %@",text);
    for (int i = 0; i < [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] count]; ++i) {
            Job *job = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:selectedJobType] objectAtIndex:i];
        if ([[[job getJobId] lowercaseString] containsString:[text lowercaseString]]) {
            [filteredJobArray addObject:job];
        }
    }
    [_collectionView reloadData];
}

- (void)closeSearch {
    filtered = false;
    [_collectionView reloadData];
}

@end
