//
//  OrdersDashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 26/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OrdersDashboardViewController.h"
#import "OrderListViewController.h"
#import "UIView+RNActivityView.h"
#import "DataManager.h"
#import "RMAListViewController.h"


@interface OrdersDashboardViewController ()

@end

@implementation OrdersDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    rmaArray = [__DataManager getRMAList];
    NSArray *items = @[@"Last 30 days", @"Last 6 months", @"Last 12 months"];
    
    periodControl = [[DZNSegmentedControl alloc] initWithItems:items];
    periodControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    periodControl.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 50);
    
    [periodControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:periodControl];

    [self getLast30Days];
    [self getLast30DaysRmas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    selectedPeriodIndex = control.selectedSegmentIndex;
    switch (control.selectedSegmentIndex) {
        case 0:
            [self getLast30Days];
            [self getLast30DaysRmas];
            break;
        case 1:
            [self getLast6Months];
            [self getLast6MonthsRmas];
            break;
        case 2:
            [self getLast12Months];
            [self getLast12MonthsRmas];
            break;
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

- (void)getOrdersListWithStartDate:(NSString*)startDate endDate:(NSString*)endDate {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Order list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/order_list.php/?date1=%@&date2=%@",startDate,endDate];
    [connectionManager makeRequest:reqString withTag:6];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    ordersArray = [[NSMutableArray alloc] init];
    
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            ordersArray = json;
            [self initialiseCounts];
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)getLast30Days {
    int numberOfDays=60;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    //[_startDateButton setTitle:[dates lastObject] forState:UIControlStateNormal];
    //[_endDateButton setTitle:dates[0] forState:UIControlStateNormal];
    [self getOrdersListWithStartDate:[dates lastObject] endDate:dates[0]];
}

- (void)getLast6Months {
    int numberOfDays=180;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    
    [self getOrdersListWithStartDate:[dates lastObject] endDate:dates[0]];
}

- (void)getLast12Months {
    int numberOfDays=360;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    
    [self getOrdersListWithStartDate:[dates lastObject] endDate:dates[0]];
}

- (IBAction)statusPressed:(UIButton*)sender {
    OrderListViewController *orderlistVC = [OrderListViewController new];
    [orderlistVC setOrdersArray:ordersArray];
    [orderlistVC setListType:LISTTYPESTATUS];
    [orderlistVC setSelectedIndex:sender.tag];
    [self.navigationController pushViewController:orderlistVC animated:NO];
}

- (IBAction)productPressed:(UIButton*)sender {
    OrderListViewController *orderlistVC = [OrderListViewController new];
    [orderlistVC setOrdersArray:ordersArray];
    [orderlistVC setListType:LISTTYPEPRODUCT];
    [orderlistVC setSelectedIndex:sender.tag];
    [self.navigationController pushViewController:orderlistVC animated:NO];
}

- (IBAction)rmaPressed:(UIButton*)sender {
    RMAListViewController *rmaListVC = [RMAListViewController new];
    [rmaListVC setListType:3 withIndex:sender.tag-6];
    [rmaListVC setRMAList:rmaArray];
    [self.navigationController pushViewController:rmaListVC animated:false];
}

- (IBAction)allRmaPressed:(UIButton*)sender {
    RMAListViewController *rmaListVC = [RMAListViewController new];
    [rmaListVC setListType:5 withIndex:0];
    [rmaListVC setRMAList:rmaArray];
    [self.navigationController pushViewController:rmaListVC animated:false];
}

- (IBAction)allPressed:(id)sender {
    OrderListViewController *orderListVC = [OrderListViewController new];
    [orderListVC setListType:LISTTYPESTATUS];
    [orderListVC setSelectedIndex:6];
    [orderListVC setOrdersArray:ordersArray];
    [self.navigationController pushViewController:orderListVC animated:NO];
}

- (void)initialiseCounts {
    int createdCount=0,inEvalCount=0, acknowledgedCount=0,puneCount=0,lausanneCount=0,masonCount=0,sentinelCount=0,iCelsiusCount=0,receptorCount=0, cosmeticCount=0,hardwareCount=0,logicalCount=0;
    for (int i=0; i < ordersArray.count; ++i) {
        NSMutableDictionary *orderData = ordersArray[i];
        if ([orderData[@"Status"] isEqualToString:@"Created"]) {
            createdCount++;
        }
        else if ([orderData[@"Status"] isEqualToString:@"Approved"]) {
            inEvalCount++;
        }
        else if ([orderData[@"Status"] isEqualToString:@"Awaiting Payment"]) {
            acknowledgedCount++;
        }
        
        if ([orderData[@"Subject"] containsString:@"Sentinel"]) {
            sentinelCount++;
        }
        if ([orderData[@"Subject"] containsString:@"iCelsius Wireless"]) {
            iCelsiusCount++;
        }
        if ([orderData[@"Subject"] containsString:@"Receptor"]) {
            receptorCount++;
        }
    }
    _createdLabel.text = [NSString stringWithFormat:@"%d",createdCount];
    _approvedLabel.text = [NSString stringWithFormat:@"%d",inEvalCount];
    _shippedLabel.text = [NSString stringWithFormat:@"%d",acknowledgedCount];
    _sentinelLabel.text = [NSString stringWithFormat:@"%d",sentinelCount];
    _iCelsiusLabel.text = [NSString stringWithFormat:@"%d",iCelsiusCount];
    _receptorLabel.text = [NSString stringWithFormat:@"%d",receptorCount];
    [_allButton setTitle:[NSString stringWithFormat:@"All(%lu)",(unsigned long)ordersArray.count] forState:UIControlStateNormal];
    [periodControl setCount:[NSNumber numberWithInt:ordersArray.count] forSegmentAtIndex:selectedPeriodIndex];
}


- (void)getLast30DaysRmas {
    filteredRMAArray = [[NSMutableArray alloc] init];
    int numberOfDays=30;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    
    for (int i=0; i < rmaArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if ([dates containsObject:rmaData[@"Date"]]) {
            [filteredRMAArray addObject:rmaData];
        }
    }
    [_allRMAButton setTitle:[NSString stringWithFormat:@"All(%lu)",(unsigned long)filteredRMAArray.count] forState:UIControlStateNormal];
    [self intialiseProductRMACounts];
}

- (void)getLast6MonthsRmas {
    filteredRMAArray = [[NSMutableArray alloc] init];
    int numberOfDays=180;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    
    for (int i=0; i < rmaArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if ([dates containsObject:rmaData[@"Date"]]) {
            [filteredRMAArray addObject:rmaData];
        }
    }
    [_allRMAButton setTitle:[NSString stringWithFormat:@"All(%lu)",(unsigned long)filteredRMAArray.count] forState:UIControlStateNormal];
    [self intialiseProductRMACounts];
}

- (void)getLast12MonthsRmas {
    filteredRMAArray = [[NSMutableArray alloc] init];
    int numberOfDays=360;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    
    for (int i=0; i < rmaArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if ([dates containsObject:rmaData[@"Date"]]) {
            [filteredRMAArray addObject:rmaData];
        }
    }
    [_allRMAButton setTitle:[NSString stringWithFormat:@"All(%lu)",(unsigned long)filteredRMAArray.count] forState:UIControlStateNormal];
    [self intialiseProductRMACounts];
}

- (void)intialiseProductRMACounts {
    int iCelsiusCount=0,sentinelCount=0,receptorCount=0;
    for (int i=0; i < filteredRMAArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if ([rmaData[@"Product"] containsString:@"Sentinel"]) {
            sentinelCount++;
        }
        if ([rmaData[@"Product"] containsString:@"iCelsius Wireless"]) {
            iCelsiusCount++;
        }
        if ([rmaData[@"Product"] containsString:@"iCelsius Bluetooth"]) {
            receptorCount++;
        }
    }
    _iCelsiusRMALabel.text = [NSString stringWithFormat:@"%d",iCelsiusCount];
    _sentinelRMALabel.text = [NSString stringWithFormat:@"%d",sentinelCount];
    _receptorLabel.text = [NSString stringWithFormat:@"%d",receptorCount];
}


@end
