//
//  ProductionPlanViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 20/02/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProductionPlanViewController.h"
#import "ScheduleRunsViewController.h"
#import "ScheduleOperationsViewController.h"
#import "DataManager.h"
#import "ServerManager.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "OperatorDashboardViewController.h"

@interface ProductionPlanViewController ()

@end

@implementation ProductionPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchThisWeekPlan];
    [self fetchNextWeekPlan];
    [self fetchThisWeekOperations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)scheduleRunsPressed:(id)sender {
    ScheduleRunsViewController *scheduleRunsVC = [[ScheduleRunsViewController alloc] init];
    [self.navigationController pushViewController:scheduleRunsVC animated:NO];
}

- (IBAction)scheduleOperationsPressed:(id)sender {
    ScheduleOperationsViewController *scheduleOperationsVC = [[ScheduleOperationsViewController alloc] init];
    [self.navigationController pushViewController:scheduleOperationsVC animated:NO];
}

- (IBAction)operatorDashboardPressed:(id)sender {
    OperatorDashboardViewController *operatorDashboardVC = [OperatorDashboardViewController new];
    [self.navigationController pushViewController:operatorDashboardVC animated:NO];
}

- (void)fetchThisWeekPlan {
    PFQuery *query = [PFQuery queryWithClassName:@"RunPlan"];
    [query whereKey:@"Schedule" equalTo:@"This Week"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        [__DataManager setThisWeekRuns:objects];
    }];
}
- (void)fetchNextWeekPlan {
    PFQuery *query = [PFQuery queryWithClassName:@"RunPlan"];
    [query whereKey:@"Schedule" equalTo:@"Next Week"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        [__DataManager setNextWeekRuns:objects];
    }];
}

- (void)fetchThisWeekOperations {
    PFQuery *query = [PFQuery queryWithClassName:@"ProcessPlan"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        [__DataManager setThisWeekOperations:objects];
        [self.navigationController.view hideActivityView];
    }];
}

@end
