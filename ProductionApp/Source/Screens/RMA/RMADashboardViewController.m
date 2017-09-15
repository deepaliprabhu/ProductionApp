//
//  RMADashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RMADashboardViewController.h"
#import "UIView+RNActivityView.h"
#import "RMAListViewController.h"
#import "DataManager.h"
#import "ServerManager.h"
#import "Constants.h"


@interface RMADashboardViewController ()

@end

@implementation RMADashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self getRMAs];
    self.title = @"RMA Dashboard";
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRMAs) name:kNotificationRmasReceived object:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    rmaArray = [__DataManager getRMAList];
    [_allButton setTitle:[NSString stringWithFormat:@"All(%lu)",(unsigned long)rmaArray.count] forState:UIControlStateNormal];
    [self initialiseCounts];
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

- (void)refreshButtonPressed {
    [self.navigationController.view showActivityViewWithLabel:@"fetching RMAs"];
    [__ServerManager getRMAs];
}

- (void) initRMAs {
    NSLog(@"RMAs received");
    rmaArray = [__DataManager getRMAList];
    [self.navigationController.view hideActivityView];
}

- (void)getRMAs {
    [self.navigationController.view showActivityViewWithLabel:@"fetching RMA List"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://aginova.info/aginova/json/rma_list.php";
    [connectionManager makeRequest:reqString withTag:6];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    rmaArray = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        rmaArray = json;
        [self initialiseCounts];
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
}

- (IBAction)allSelected:(id)sender {
    RMAListViewController *rmaListVC = [RMAListViewController new];
    [rmaListVC setListType:5 withIndex:0];
    [rmaListVC setRMAList:rmaArray];
    [self.navigationController pushViewController:rmaListVC animated:false];
}

- (IBAction)listselected:(UIButton*)sender {
    RMAListViewController *rmaListVC = [RMAListViewController new];
    if (sender.tag <= 3) {
        [rmaListVC setListType:1 withIndex:sender.tag];
    }
    else if (sender.tag <= 6) {
        [rmaListVC setListType:2 withIndex:sender.tag-3];
    }
    else if (sender.tag <= 9) {
        [rmaListVC setListType:3 withIndex:sender.tag-6];
    }
    [rmaListVC setRMAList:rmaArray];
    [self.navigationController pushViewController:rmaListVC animated:false];
}

- (void)initialiseCounts {
    int authorizedCount=0,autopsyCount=0, allStatusCount=0,masonCount=0,lausanneCount=0,allLocationCount=0,sentinelCount=0,iCelsiusCount=0,allProductCount=0,closedAllCount=0;
    for (int i=0; i < rmaArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"Authorized"]) {
            authorizedCount++;
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Autopsy"]) {
            autopsyCount++;
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Evaluation"]) {
            allStatusCount++;
        }
        
        if ([rmaData[@"Location"] isEqualToString:@"Mason"]||[rmaData[@"Location"] isEqualToString:@"MASON"]) {
            masonCount++;
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Lausanne"]) {
            lausanneCount++;
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Pune"]) {
            allLocationCount++;
        }
        //else {
        //}
        
        if ([rmaData[@"Product"] containsString:@"Sentinel"]) {
            sentinelCount++;
        }
        if ([rmaData[@"Product"] containsString:@"iCelsius Wireless"]) {
            iCelsiusCount++;
        }
        if ([rmaData[@"Product"] containsString:@"iCelsius Bluetooth"]) {
            allProductCount++;
        }
       if ([rmaData[@"Status"] isEqualToString:@"RMA Closed"]) {
            closedAllCount++;
        }
    }
    _authorizedLabel.text = [NSString stringWithFormat:@"%d",authorizedCount];
    _autopsyLabel.text = [NSString stringWithFormat:@"%d",autopsyCount];
    _allStatusLabel.text = [NSString stringWithFormat:@"%d",allStatusCount];
    _lausanneLabel.text = [NSString stringWithFormat:@"%d",lausanneCount];
    _masonLabel.text = [NSString stringWithFormat:@"%d",masonCount];
    _allLocationLabel.text = [NSString stringWithFormat:@"%d",allLocationCount];
    _sentinelLabel.text = [NSString stringWithFormat:@"%d",sentinelCount];
    _iCelsiusLabel.text = [NSString stringWithFormat:@"%d",iCelsiusCount];
    _allProductLabel.text = [NSString stringWithFormat:@"%d",allProductCount];
    [self getLast30DaysCount];
    [self getLast6MonthsCount];
    [self getAllClosedCount];
}

- (void)getLast30DaysCount {
    NSMutableArray *filteredPeriodArray = [[NSMutableArray alloc] init];
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
        if (([dates containsObject:rmaData[@"Date"]])&&([rmaData[@"Status"] isEqualToString:@"RMA Closed"])) {
            [filteredPeriodArray addObject:rmaData];
        }
    }
    NSLog(@"filteredPeriodArray:%@",filteredPeriodArray);
    _closed3Label.text = [NSString stringWithFormat:@"%lu",(unsigned long)filteredPeriodArray.count];
}

- (void)getLast6MonthsCount {
    NSMutableArray *filteredPeriodArray = [[NSMutableArray alloc] init];
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
    
    NSLog(@"%@",dates);
    for (int i=0; i < rmaArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if (([dates containsObject:rmaData[@"Date"]])&&([rmaData[@"Status"] isEqualToString:@"RMA Closed"])) {
            [filteredPeriodArray addObject:rmaData];
        }
    }
    _closed6Label.text = [NSString stringWithFormat:@"%lu",(unsigned long)filteredPeriodArray.count];
}

- (void)getAllClosedCount {
    NSMutableArray *filteredPeriodArray = [[NSMutableArray alloc] init];
    for (int i=0; i < rmaArray.count; ++i) {
        NSMutableDictionary *rmaData = rmaArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"RMA Closed"]) {
            [filteredPeriodArray addObject:rmaData];
        }
    }
    _closedAllLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)filteredPeriodArray.count];

}

- (IBAction)closedPressed:(UIButton*)sender {
    RMAListViewController *rmaListVC = [RMAListViewController new];
    [rmaListVC setListType:4 withIndex:sender.tag];
    [rmaListVC setRMAList:rmaArray];
    [self.navigationController pushViewController:rmaListVC animated:false];
}


@end
