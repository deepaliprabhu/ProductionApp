//
//  RunHistoryViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "RunHistoryViewController.h"
#import <Parse/Parse.h>
#import "RunHistoryCell.h"
#import "UIView+RNActivityView.h"

@interface RunHistoryViewController ()

@end

@implementation RunHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Run Activity";
    self.navigationController.navigationBar.hidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRunId:(int)runId_ {
    NSLog(@"setting run Id=%d",runId_);
    runId = runId_;
    [self fetchParseRuns];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [parseRuns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RunHistoryCell";
    RunHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    [cell setCellData:(NSMutableDictionary*)[parseRuns objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)fetchParseRuns {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
   /* NSDate *date = [dateFormat1 dateFromString:_dateButton.titleLabel.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];*/
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];
    parseRuns = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
   /* if (![Utilities isNetworkReachable]) {
        [query fromLocalDatastore];
    }
    else{
        [PFObject unpinAllObjects];
    }*/
    
   // NSLog(@"Date selected :%@", [dateFormat stringFromDate:date]);
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",runId]];
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        //[PFObject pinAllInBackground:objects];
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [parseRuns addObjectsFromArray:objects];
        NSLog(@"parse run history = %@",parseRuns);
        [self.navigationController.view hideActivityView];
        
        [_tableView reloadData];
        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
    }];
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
