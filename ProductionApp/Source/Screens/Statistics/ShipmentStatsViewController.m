//
//  ShipmentStatsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ShipmentStatsViewController.h"
#import "UIView+RNActivityView.h"

@interface ShipmentStatsViewController ()

@end

@implementation ShipmentStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shipment List";
    NSArray *items = @[@"All",@"Mason", @"Lausanne", @"Others"];
    NSArray *items1 = @[@"To Be Shipped", @"Shipped"];
    NSArray *items2 = @[@"Today", @"This Week", @"Next Week", @"Later"];
    
    shipmentLocationControl = [[DZNSegmentedControl alloc] initWithItems:items];
    shipmentLocationControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    shipmentLocationControl.frame = CGRectMake(0, 125, self.view.bounds.size.width, 50);
    shipmentLocationControl.hidden = true;
    [shipmentLocationControl addTarget:self action:@selector(selectedShipmentLocation:) forControlEvents:UIControlEventValueChanged];
   // [self.view addSubview:shipmentLocationControl];
    
    shipmentTimeControl = [[DZNSegmentedControl alloc] initWithItems:items2];
    shipmentTimeControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    shipmentTimeControl.frame = CGRectMake(0, 125, self.view.bounds.size.width, 50);
    shipmentTimeControl.hidden = false;
    [shipmentTimeControl addTarget:self action:@selector(selectedShipmentTime:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:shipmentTimeControl];
    
    shipmentStatusControl = [[DZNSegmentedControl alloc] initWithItems:items1];
    shipmentStatusControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    shipmentStatusControl.frame = CGRectMake(0, 65, self.view.bounds.size.width, 50);
    
    [shipmentStatusControl addTarget:self action:@selector(selectedShipmentStatus:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:shipmentStatusControl];
    [self fetchParseRuns];
    [self fetchDemands];
    [shipmentTimeControl setSelectedSegmentIndex:0 animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDemands {
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    parseDemands = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    PFQuery *query = [PFQuery queryWithClassName:@"Demands"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [parseDemands addObjectsFromArray:objects];
        NSLog(@"parse demands = %@",parseDemands);
        [self.navigationController.view hideActivityView];
        if (parseDemands.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        [_tableView reloadData];
        [shipmentTimeControl setSelectedSegmentIndex:1 animated:false];
        [self selectedShipmentTime:shipmentTimeControl];
        [shipmentTimeControl setSelectedSegmentIndex:2 animated:false];
        [self selectedShipmentTime:shipmentTimeControl];
        [shipmentTimeControl setSelectedSegmentIndex:3 animated:false];
        [self selectedShipmentTime:shipmentTimeControl];
        [shipmentTimeControl setSelectedSegmentIndex:0 animated:false];
        [self selectedShipmentTime:shipmentTimeControl];
        [shipmentStatusControl setCount:[NSNumber numberWithInteger:[parseDemands count]] forSegmentAtIndex:0];

    }];
}

- (void)fetchParseRuns {
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    parseRuns = [[NSMutableArray alloc] init];
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
        [parseRuns addObjectsFromArray:objects];
        NSLog(@"parse runs = %@",parseRuns);
        [self.navigationController.view hideActivityView];
        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        [_tableView reloadData];
        [shipmentStatusControl setCount:[NSNumber numberWithInteger:[parseRuns count]] forSegmentAtIndex:1];
        [shipmentLocationControl setSelectedSegmentIndex:1 animated:false];
        [self selectedShipmentLocation:shipmentLocationControl];
        [shipmentLocationControl setSelectedSegmentIndex:2 animated:false];
        [self selectedShipmentLocation:shipmentLocationControl];
        [shipmentLocationControl setSelectedSegmentIndex:3 animated:false];
        [self selectedShipmentLocation:shipmentLocationControl];
        [shipmentLocationControl setCount:[NSNumber numberWithInteger:[parseRuns count]] forSegmentAtIndex:0];
    }];
}

- (void)selectedShipmentLocation:(DZNSegmentedControl *)control {
    [self filterDataforIndex:control.selectedSegmentIndex];
}

- (void)selectedShipmentStatus:(DZNSegmentedControl *)control {
    switch (control.selectedSegmentIndex) {
        case 1:{
            shipmentLocationControl.hidden = false;
            shipmentTimeControl.hidden = true;
            [self selectedShipmentLocation:shipmentLocationControl];
        }
            break;
        case 0: {
            shipmentLocationControl.hidden = true;
            shipmentTimeControl.hidden = false;
            [self selectedShipmentTime:shipmentTimeControl];
        }
            break;
        default:
            break;
    }
}

- (void)selectedShipmentTime:(DZNSegmentedControl *)control {
    [self filteDemandDataforIndex:control.selectedSegmentIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (filtered) {
        return [filteredArray count];
    }
    return [parseRuns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ShipmentStatsCell";
    ShipmentStatsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    if (filtered) {
        [cell setCellData:[filteredArray objectAtIndex:indexPath.row]];
    }
    else
        [cell setCellData:[parseRuns objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedParseObject = [parseRuns objectAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Delete Entry?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    //[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            NSLog(@"selected parse obj:%@",selectedParseObject);
            [selectedParseObject deleteInBackground];
            [self fetchParseRuns];
        }
            break;
            
        default:
            break;
    }
}

- (void)filteDemandDataforIndex:(int)index {
    filteredArray = [[NSMutableArray alloc] init];
    switch (index) {
        case 0: {
            filtered = YES;
            for (int i=0; i < [parseDemands count]; ++i) {
                PFObject *parseObj = parseDemands[i];
                if ([parseObj[@"Shipping"] hasPrefix:@"Today"]) {
                    [filteredArray addObject:parseObj];
                }
            }
        }
            break;
        case 1: {
            filtered = YES;
            for (int i=0; i < [parseDemands count]; ++i) {
                PFObject *parseObj = parseDemands[i];
                if ([parseObj[@"Shipping"] hasPrefix:@"This Week"]) {
                    [filteredArray addObject:parseObj];
                }
            }
        }
            break;
        case 2: {
            filtered = YES;
            for (int i=0; i < [parseDemands count]; ++i) {
                PFObject *parseObj = parseDemands[i];
                if ([parseObj[@"Shipping"] hasPrefix:@"Next Week"]) {
                    [filteredArray addObject:parseObj];
                }
            }
        }
            break;
        case 3: {
            filtered = YES;
            for (int i=0; i < [parseDemands count]; ++i) {
                PFObject *parseObj = parseDemands[i];
                if ([parseObj[@"Shipping"] isEqualToString:@""]) {
                    [filteredArray addObject:parseObj];
                }
            }
        }
            break;
        default:
            break;
    }
    [shipmentTimeControl setCount:[NSNumber numberWithInteger:[filteredArray count]] forSegmentAtIndex:index];
    [_tableView reloadData];

}

- (void)filterDataforIndex:(int)index {
    filteredArray = [[NSMutableArray alloc] init];
    filtered = YES;
    for (int i=0; i < [parseDemands count]; ++i) {
        PFObject *parseObj = parseDemands[i];
        if ([parseObj[@"Shipping"] hasPrefix:@"Shipped"]) {
            [filteredArray addObject:parseObj];
        }
    }
/*    switch (index) {
        case 0: {
            filtered = NO;
        }
            break;
        case 1: {
            filtered = YES;
            for (int i=0; i < [parse count]; ++i) {
                PFObject *parseObj = parseRuns[i];
                if ([parseObj[@"Location"] isEqualToString:@"Mason"]) {
                    [filteredArray addObject:parseObj];
                }
            }
            [shipmentLocationControl setCount:[NSNumber numberWithInteger:[filteredArray count]] forSegmentAtIndex:index];
        }
            break;
        case 2: {
            filtered = YES;
            for (int i=0; i < [parseRuns count]; ++i) {
                PFObject *parseObj = parseRuns[i];
                if ([parseObj[@"Location"] isEqualToString:@"Lausanne"]) {
                    [filteredArray addObject:parseObj];
                }
            }
            [shipmentLocationControl setCount:[NSNumber numberWithInteger:[filteredArray count]] forSegmentAtIndex:index];
        }
            break;
        case 3: {
            filtered = YES;
            for (int i=0; i < [parseRuns count]; ++i) {
                PFObject *parseObj = parseRuns[i];
                if ((![parseObj[@"Location"] isEqualToString:@"Lausanne"])&&(![parseObj[@"Location"] isEqualToString:@"Mason"])) {
                    [filteredArray addObject:parseObj];
                }
            }
            [shipmentLocationControl setCount:[NSNumber numberWithInteger:[filteredArray count]] forSegmentAtIndex:index];
        }
            break;
        default:
            break;
    }*/

    [_tableView reloadData];
    
    
}

- (void) reloadData {
    [self fetchParseRuns];
}


@end
