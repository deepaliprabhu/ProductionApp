//
//  ShipmentListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ShipmentListViewController.h"
#import "ShipmentListCell.h"
#import "UIView+RNActivityView.h"
#import <Parse/Parse.h>
#import "ShipmentDetailsViewController.h"


@interface ShipmentListViewController ()

@end

@implementation ShipmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *items = @[@"All",@"Mason", @"Lausanne", @"Others"];
    
    DZNSegmentedControl *shipmentLocationControl = [[DZNSegmentedControl alloc] initWithItems:items];
    shipmentLocationControl.tintColor = [UIColor orangeColor];
    //shipmentLocationControl.delegate = self;
    shipmentLocationControl.frame = CGRectMake(0, 55, self.view.bounds.size.width, 50);
    [shipmentLocationControl addTarget:self action:@selector(selectedShipmentLocation:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:shipmentLocationControl];
    [self fetchParseRuns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedShipmentLocation:(DZNSegmentedControl *)control {
    //[self filterDataforIndex:control.selectedSegmentIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (filtered) {
        return [filteredArray count];
    }
    return [parseShipmentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ShipmentListCell";
    ShipmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
   // cell.delegate = self;
    if (filtered) {
        [cell setCellData:[filteredArray objectAtIndex:indexPath.row]];
    }
    else
        [cell setCellData:[parseShipmentArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *data = [parseShipmentArray objectAtIndex:indexPath.row];
    ShipmentDetailsViewController *shipmentVC = [ShipmentDetailsViewController new];
    [shipmentVC setShipmentData:data];
    [self.navigationController pushViewController:shipmentVC animated:true];
}


- (void)fetchParseRuns {
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    parseShipmentArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    PFQuery *query = [PFQuery queryWithClassName:@"Shipment"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [parseShipmentArray addObjectsFromArray:objects];
        NSLog(@"parse runs = %@",parseShipmentArray);
        [self.navigationController.view hideActivityView];
        if (parseShipmentArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        [_tableView reloadData];

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
