//
//  ShipmentDetailsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ShipmentDetailsViewController.h"
#import "UIView+RNActivityView.h"

@interface ShipmentDetailsViewController ()

@end

@implementation ShipmentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shipment Details";
    _dateLabel.text = shipmentData[@"Date"];
    _locationLabel.text = shipmentData[@"Location"];
    _transferIdLabel.text = shipmentData[@"TransferId"];
    [_trackingIdButton setTitle:shipmentData[@"TrackingId"] forState:UIControlStateNormal];
    _statusLabel.text = shipmentData[@"Status"];
    [self fetchParseRunsForShipmentId:shipmentData.objectId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShipmentData:(PFObject*)shipmentData_ {
    shipmentData = shipmentData_;
}

- (IBAction)trackingIdPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.fedex.com/apps/fedextrack/?action=track&trackingnumber=%@&cntry_code=ca",_trackingIdButton.titleLabel.text]]];
}

- (void)fetchParseRunsForShipmentId:(NSString*)shipmentId {
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    parseShipmentArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    PFQuery *query = [PFQuery queryWithClassName:@"ShipmentProducts"];
    [query whereKey:@"ShipmentId" equalTo:shipmentData.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [parseShipmentArray addObjectsFromArray:objects];
        [self fillParts:parseShipmentArray];
        NSLog(@"parse runs = %@",parseShipmentArray);
        [self.navigationController.view hideActivityView];
        if (parseShipmentArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No data to show." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        
    }];
}


- (void)fillParts:(NSMutableArray *)partsArray {
    
    [[_productsScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_productsScrollView setContentSize:CGSizeMake(_productsScrollView.frame.size.width, parseShipmentArray.count*60)];
    for (int i=0; i < parseShipmentArray.count; ++i) {
        NSMutableDictionary *partsData = parseShipmentArray[i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (i*60)+5, _productsScrollView.frame.size.width, 60)];
        //view.backgroundColor = [UIColor yellowColor];
        [_productsScrollView addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, view.frame.size.width-50, 25)];
         titleLabel.text = partsData[@"ProductName"];
         titleLabel.textColor = [UIColor blackColor];
         titleLabel.font = [UIFont systemFontOfSize:12.0f];
         [view addSubview:titleLabel];
        
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 250, 45)];
        detailsLabel.text = partsData[@"ProductDetails"];
        detailsLabel.numberOfLines = 2;
        detailsLabel.textColor = [UIColor darkGrayColor];
        detailsLabel.font = [UIFont systemFontOfSize:10.0f];
        [view addSubview:detailsLabel];
        
        UILabel *qtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-35, 5, 25, 25)];
        qtyLabel.text = partsData[@"Quantity"];
        qtyLabel.textColor = [UIColor blackColor];
        qtyLabel.font = [UIFont systemFontOfSize:13.0f];
        [view addSubview:qtyLabel];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, _productsScrollView.frame.size.width, 1)];
        separatorView.backgroundColor = [UIColor orangeColor];
        [view addSubview:separatorView];
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

@end
