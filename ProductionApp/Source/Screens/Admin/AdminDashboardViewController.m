//
//  DashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "AdminDashboardViewController.h"
#import "ReportsViewController.h"
#import "StatsViewController.h"

@interface AdminDashboardViewController ()

@end

@implementation AdminDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Dashboard";
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

- (IBAction)reportsButtonPressed:(id)sender {
    ReportsViewController *reportsVC = [ReportsViewController new];
    [self.navigationController pushViewController:reportsVC animated:true];
}

- (IBAction)statsButtonPressed:(id)sender {
    StatsViewController *statsVC = [StatsViewController new];
    [self.navigationController pushViewController:statsVC animated:true];
}

- (IBAction)searchButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Coming Soon!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)configButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Coming Soon!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertView show];
}

@end
