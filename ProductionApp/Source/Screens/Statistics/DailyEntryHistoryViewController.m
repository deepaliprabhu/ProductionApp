//
//  DailyEntryHistoryViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/01/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "DailyEntryHistoryViewController.h"
#import "UIView+RNActivityView.h"
#import <Parse/Parse.h>
#import "HistoryStatsListViewCell.h"

@interface DailyEntryHistoryViewController ()

@end

@implementation DailyEntryHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Daily History";
    historyGraphView = [HistoryGraphView createView];
    historyGraphView.frame = CGRectMake(20, 70, 350, 300);
    [self getParseDailyStats];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setParseData:(NSMutableArray*)parseArray {
    operationsArray = parseArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyStatsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"HistoryStatsListViewCell";
    HistoryStatsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    
    [cell setCellData:historyStatsArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)viewGraphPressed:(id)sender {
    if ([_viewGraphButton.titleLabel.text isEqualToString:@"View Graph >"]) {
        _tableView.hidden = true;
        [historyGraphView setStatsDataArray:historyStatsArray];
        [historyGraphView initLayout];
        [_scrollView addSubview:historyGraphView];
        [_viewGraphButton setTitle:@"View List >" forState:UIControlStateNormal];
    }
    else {
        [_viewGraphButton setTitle:@"View Graph >" forState:UIControlStateNormal];
        _tableView.hidden = false;
    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getParseDailyStats {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyStats"];
    /*if (![Utilities isNetworkReachable]) {
     [query fromLocalDatastore];
     }
     else{
     [PFObject unpinAllObjects];
     }*/
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        //[PFObject pinAllInBackground:objects];
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        historyStatsArray = [objects mutableCopy];
        [self.navigationController.view hideActivityView];
        historyStatsArray=[[[historyStatsArray reverseObjectEnumerator] allObjects] mutableCopy];
        [_tableView reloadData];
    }];
}


@end
