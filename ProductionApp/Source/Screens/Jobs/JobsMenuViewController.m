//
//  JobsMenuViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 26/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "JobsMenuViewController.h"
#import "JobsListViewController.h"
#import "DataManager.h"
#import "BatchesViewController.h"

@interface JobsMenuViewController ()

@end

@implementation JobsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"%d",[__DataManager getCurrentRunId]];
    self.navigationController.navigationItem.leftBarButtonItem.title = @"Back";
    _newJobTypeView.layer.cornerRadius = 8.0f;
    UINib *cellNib = [UINib nibWithNibName:@"JobMenuCell" bundle:nil];

    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"JobMenuCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(90, 90)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    jobTypeArray = [[NSMutableArray alloc] initWithObjects:@"Open",@"Ongoing", @"Closed", @"Rework", @"Reject" , nil];
    _backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:_backgroundDimmingView];
    _backgroundDimmingView.hidden = true;
    [self.view bringSubviewToFront:_newJobTypeView];

    Run *run = [__DataManager getRunWithId:[__DataManager getCurrentRunId]];
    if ([[run getRunJobs] count] == 0) {
        if ([run getRunId] != 246) {
            [run generateJobs];
        }
        else {
                [__ServerManager setDelegate:self];
                [__ServerManager getJobsListForRunId:[run getRunId]];
        }
    }
}

- (void)initView {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [_collectionView reloadData];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [jobTypeArray count]+1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"JobMenuCell";
    
    JobMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil][0];
    }

    if (indexPath.row == 0) {
        [cell initCellWithTitle:@"" count:0 index:0];
    }
    else {
        [cell initCellWithTitle:jobTypeArray[indexPath.row-1] count:[[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:indexPath.row-1] count] index:indexPath.row];
    }
    //Job *job = [[[__DataManager getRunWithId:221] getRunJobsForType:selectedJobType] objectAtIndex:indexPath.row];
   // [cell setJobData:job];
    [cell setDelegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _titleTextView.text = @"Enter Title here...";
        _newJobTypeView.hidden = false;
        _backgroundDimmingView.hidden = false;
    }
    else {
        if (multiMode&&(indexPath.row > 5)) {
            JobMenuCell *cell = (JobMenuCell*)[_collectionView cellForItemAtIndexPath:indexPath];
            if ([cell isCellSelected]) {
                [cell deselectCell];
            }
            else
                [cell selectCell];
        }
        else {
            int count = [[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunJobsForType:indexPath.row-1] count];
            if (count == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[jobTypeArray objectAtIndex:indexPath.row-1] message:@"\nNo Jobs to show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                if (indexPath.row == 1) {
                   /* BatchesViewController *batchesVC = [[BatchesViewController alloc] initWithNibName:@"BatchesViewController" bundle:nil];
                    [self.navigationController pushViewController:batchesVC animated:true];*/
                    JobsListViewController *jobsListVC = [[JobsListViewController alloc] initWithNibName:@"JobsListViewController" bundle:nil];
                    [jobsListVC setJobType:indexPath.row-1];
                    [jobsListVC setJobTypeArray:jobTypeArray];
                    [self.navigationController pushViewController:jobsListVC animated:true];
                }
                else {
                    JobsListViewController *jobsListVC = [[JobsListViewController alloc] initWithNibName:@"JobsListViewController" bundle:nil];
                    [jobsListVC setJobType:indexPath.row-1];
                    [jobsListVC setJobTypeArray:jobTypeArray];
                    [self.navigationController pushViewController:jobsListVC animated:true];
                }
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)buildBackgroundDimmingView{
    
    UIView *bgView;
    //blur effect for iOS8
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CGFloat frameHeight = screenRect.size.height;
    CGFloat frameWidth = screenRect.size.width;
    CGFloat sideLength = frameHeight > frameWidth ? frameHeight : frameWidth;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = CGRectMake(0, 0, sideLength, sideLength);
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.view.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.9;
    /*if(self.tapBackgroundToDismiss){
        [bgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelButtonPressed:)]];
    }*/
    return bgView;
}

- (IBAction)cancelButtonPressed: (id)sender{
    _newJobTypeView.hidden = true;
    _backgroundDimmingView.hidden = true;
}

- (IBAction)confirmButtonPressed: (id)sender{
    _newJobTypeView.hidden = true;
    _backgroundDimmingView.hidden = true;
    [jobTypeArray addObject:_titleTextView.text];
    [_collectionView reloadData];
}

- (IBAction)deleteButtonPressed: (id)sender{
    for (int i = 5; i < [jobTypeArray count]; ++i) {
        JobMenuCell *cell = (JobMenuCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
        if ([cell isCellSelected]) {
            [jobTypeArray removeObjectAtIndex:i];
        }
    }
    [_collectionView reloadData];
    [self deselectAll];
}

- (IBAction)cancelTrashButtonPressed: (id)sender{
    [self deselectAll];
    multiMode = false;
    _trashView.hidden = true;
}

- (void)deselectAll {
    for (int i = 0; i < [jobTypeArray count]+1; ++i) {
        JobMenuCell *cell = (JobMenuCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell deselectCell];
    }
}

//JobMenuCellDelegate methods

- (void) setMultiMode:(BOOL)value {
    multiMode = value;
    _trashView.hidden = false;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _titleTextView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([_titleTextView.text isEqualToString:@"Enter Title here..."]) {
        _titleTextView.text = @"";
    }
    if ([text isEqualToString:@"\n"]) {
        [_titleTextView resignFirstResponder];
    }
    return true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)receivedServerResponse {
    [_collectionView reloadData];
}

@end
