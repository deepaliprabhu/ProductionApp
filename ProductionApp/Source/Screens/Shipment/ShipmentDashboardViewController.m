//
//  ShipmentDashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ShipmentDashboardViewController.h"
#import "ShipmentListViewController.h"
#import "ShipmentStatsViewController.h"
#import "PartsTransferViewController.h"
#import "OrdersDashboardViewController.h"

@interface ShipmentDashboardViewController ()

@end

@implementation ShipmentDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shipment";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)partsTransferPressed:(id)sender {
    PartsTransferViewController *partsTransferVC = [PartsTransferViewController new];
    [self.navigationController pushViewController:partsTransferVC animated:true];
}

- (IBAction)orderListPressed:(id)sender {
    OrdersDashboardViewController *orderListVC = [OrdersDashboardViewController new];
    [self.navigationController pushViewController:orderListVC animated:true];
}

- (IBAction)upcomingShipmentPressed:(id)sender {
    ShipmentStatsViewController *shipmentVC = [ShipmentStatsViewController new];
    [self.navigationController pushViewController:shipmentVC animated:true];
}

- (IBAction)shipmentListPressed:(id)sender {
    ShipmentListViewController *shipmentVC = [ShipmentListViewController new];
    [self.navigationController pushViewController:shipmentVC animated:true];
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
