//
//  ProductionDashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 31/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProductionDashboardViewController.h"
#import "RunsListViewController.h"
#import "ProductionPlanViewController.h"
#import "ProductSelectionViewController.h"
#import "ChecklistGenViewController.h"
#import "ScheduleOperationsViewController.h"
#import "OperatorDashboardViewController.h"
#import "ProductSelectionViewController.h"


@interface ProductionDashboardViewController ()

@end

@implementation ProductionDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Production Dashboard";
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

- (IBAction)runEntryPressed:(id)sender {
    RunsListViewController *runListVC = [[RunsListViewController alloc] initWithNibName:@"RunsListViewController" bundle:nil];
    [self.navigationController pushViewController:runListVC animated:true];
}

- (IBAction)dailyEntryPressed:(id)sender {
    OperatorDashboardViewController *operatorDashboardVC = [OperatorDashboardViewController new];
    [self.navigationController pushViewController:operatorDashboardVC animated:NO];
}

- (IBAction)dailyPlanPressed:(id)sender {
    ScheduleOperationsViewController *scheduleOperationsVC = [[ScheduleOperationsViewController alloc] init];
    [self.navigationController pushViewController:scheduleOperationsVC animated:NO];
}

- (IBAction)processControlPressed:(id)sender {
    ProductSelectionViewController *productSelectionVC = [ProductSelectionViewController new];
    [productSelectionVC setTag:1];
    [self.navigationController pushViewController:productSelectionVC animated:false];
}

- (IBAction)checklistGeneratorPressed:(id)sender {
    ChecklistGenViewController *checklistGenVC = [ChecklistGenViewController new];
    [self.navigationController pushViewController:checklistGenVC animated:true];
}

- (IBAction)labelGeneratorPressed:(id)sender {
    
}

@end
