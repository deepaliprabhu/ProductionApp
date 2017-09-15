//
//  RMAListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 15/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RMAListViewController.h"
#import "RMAListViewCell.h"
#import "UIView+RNActivityView.h"


@interface RMAListViewController ()

@end

@implementation RMAListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    filteredPeriodArray = [[NSMutableArray alloc] init];
    filteredArray = [[NSMutableArray alloc] init];
    self.title = @"RMA";
    NSArray *items = @[@"Last 30 days", @"Last 6 months", @"All"];
    
    periodControl = [[DZNSegmentedControl alloc] initWithItems:items];
    periodControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    periodControl.frame = CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, 50);
    
    [periodControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:periodControl];
    
    selectedPeriodIndex = 0;
    filteredPeriodArray = rmaArray;
    if (listType == 4) {
        [self getLast30Days];
        [self filterClosedList];
        [self resetCounts];

    }
    else if (listType == 5) {
        [self getLast30Days];
        filteredArray = filteredPeriodArray;
        [self resetCounts];
        //[periodControl removeFromSuperview];
    }
    else {
        [self setListControl];
        
        listTypeControl = [[DZNSegmentedControl alloc] initWithItems:listTypeArray];
        listTypeControl.tintColor = [UIColor orangeColor];
        // control.delegate = self;
        listTypeControl.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 50);
        
        [listTypeControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:listTypeControl];
        //[self resetCounts];
        [self getLast30Days];
        [listTypeControl setSelectedSegmentIndex:selectedListTypeIndex];
        [self selectedSegment:listTypeControl];
        selectedPeriodIndex = 0;
        [self resetCounts];
    }
    [_tableView reloadData];

}

- (void)setListType:(RMAListType)listType_ withIndex:(int)listIndex{
    listType =listType_;
    selectedListTypeIndex = --listIndex;
}

- (void)setRMAList:(NSMutableArray*)rmalist {
    rmaArray = rmalist;
}


- (void)setListControl {
    switch (listType) {
        case RMALISTTYPESTATUS:
            listTypeArray= @[@"Authorized", @"RMA Autopsy", @"RMA Evaluation"];
            break;
        case RMALISTTYPELOCATION:
            listTypeArray= @[@"Mason", @"Lausanne", @"Pune"];
            break;
        case RMALISTTYPEPRODUCT:
            listTypeArray= @[@"Sentinel", @"icelsius", @"iCBlue"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    if ([control isEqual:periodControl]) {
        selectedPeriodIndex = control.selectedSegmentIndex;
        switch (control.selectedSegmentIndex) {
            case 0:
                [self getLast30Days];
                break;
            case 1:
                [self getLast6Months];
                break;
            default:
                filteredPeriodArray = rmaArray;
                break;
        }
        if (listType !=5) {
            [self selectedSegment:listTypeControl];
            [self resetCounts];
        }
        else {
            filteredArray = filteredPeriodArray;
        }
    }
    else {
        selectedListTypeIndex = control.selectedSegmentIndex;
        switch (listType) {
            case RMALISTTYPESTATUS:
                [self filterStatusList];
                break;
            case RMALISTTYPELOCATION:
                [self filterLocationList];
                break;
            case RMALISTTYPEPRODUCT:
                [self filterProductList];
                break;
            case RMALISTTYPECLOSED:
                [self filterClosedList];
                break;
            default:
                break;
        }
        [self resetCounts];
    }
    [_tableView reloadData];
}

- (void)filterStatusList {
    filteredArray = [[NSMutableArray alloc] init];
    switch (listTypeControl.selectedSegmentIndex) {
        case 0: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Status"] isEqualToString:@"Authorized"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
        case 1: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Status"] isEqualToString:@"RMA Autopsy"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
            
        case 2: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Status"] isEqualToString:@"RMA Evaluation"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
            
        default: {
            filteredArray = filteredPeriodArray;
        }
            break;
    }
}

- (void)filterClosedList {
    filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < filteredPeriodArray.count; ++i) {
        NSMutableDictionary *rmaData = filteredPeriodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"RMA Closed"]) {
            [filteredArray addObject:rmaData];
        }
    }
}

- (void)filterLocationList {
    filteredArray = [[NSMutableArray alloc] init];

    switch (listTypeControl.selectedSegmentIndex) {
        case 0: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Location"] isEqualToString:@"MASON"]||[rmaData[@"Location"] isEqualToString:@"Mason"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
        case 1: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Location"] isEqualToString:@"Lausanne"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
        case 2: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Location"] isEqualToString:@"Pune"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
            
        default:
            filteredArray = filteredPeriodArray;
            break;
    }
}

- (void)filterProductList {
    filteredArray = [[NSMutableArray alloc] init];

    switch (listTypeControl.selectedSegmentIndex) {
        case 0: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Product"] containsString:@"Sentinel"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
        case 1: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Product"] containsString:@"iCelsius Wireless"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
        case 2: {
            for (int i=0; i < filteredPeriodArray.count; ++i) {
                NSMutableDictionary *rmaData = filteredPeriodArray[i];
                if ([rmaData[@"Product"] containsString:@"iCelsius Bluetooth"]) {
                    [filteredArray addObject:rmaData];
                }
            }
        }
            break;
        default:
            filteredArray = filteredPeriodArray;
            break;
    }
}

- (NSMutableArray*)getLast30Days {
    filteredPeriodArray = [[NSMutableArray alloc] init];
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
            [filteredPeriodArray addObject:rmaData];
        }
    }
    NSLog(@"filteredPeriodArray:%@",filteredPeriodArray);

    return filteredPeriodArray;
}

- (NSMutableArray*)getLast6Months {
    filteredPeriodArray = [[NSMutableArray alloc] init];
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
        if ([dates containsObject:rmaData[@"Date"]]) {
            [filteredPeriodArray addObject:rmaData];
        }
    }
    return filteredPeriodArray;
}

- (void)resetCounts {
    switch (listType) {
        case RMALISTTYPESTATUS:
            [self initialiseStatusCounts];
            break;
        case RMALISTTYPELOCATION:
            [self initialiseLocationCounts];
            break;
        case RMALISTTYPECLOSED:
            [self initialiseClosedCounts];
            break;
        case RMALISTTYPEALL:
            [self initialiseAllCounts];
            break;
        default:
            [self initialiseProductCounts];
            break;
    }
}

- (void)initialiseLocationCounts {
    int masonCount=0,lausanneCount=0,allCount=0,puneCount=0;
    int last30=0,last6=0,all=0;
    [self getLast30Days];
    NSLog(@"selectedListTypeIndex=%d",selectedListTypeIndex);
    NSLog(@"selectedPeriodIndex=%d",selectedPeriodIndex);

    NSMutableArray *periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Location"] isEqualToString:@"MASON"] || [rmaData[@"Location"] isEqualToString:@"Mason"]) {
            if (selectedPeriodIndex == 0) {
                masonCount++;
            }
            if (selectedListTypeIndex==0) {
                last30++;
            }
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Lausanne"]) {
            if (selectedPeriodIndex == 0) {
                lausanneCount++;
            }
            if (selectedListTypeIndex==1) {
                last30++;
            }
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Pune"]) {
            if (selectedPeriodIndex == 0) {
                puneCount++;
            }
            if (selectedListTypeIndex==2) {
                last30++;
            }
        }
        if (selectedPeriodIndex == 0) {
            allCount++;
        }
        /*if (selectedListTypeIndex==2) {
            last30++;
        }*/
    }
    [periodControl setCount:[NSNumber numberWithInt:last30] forSegmentAtIndex:0];
    NSLog(@"last30=%d",last30);
    [self getLast6Months];
    periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Location"] isEqualToString:@"MASON"] || [rmaData[@"Location"] isEqualToString:@"Mason"]) {
            if (selectedPeriodIndex == 1) {
                masonCount++;
            }
            if (selectedListTypeIndex==0) {
                last6++;
            }
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Lausanne"]) {
            if (selectedPeriodIndex == 1) {
                lausanneCount++;
            }
            if (selectedListTypeIndex==1) {
                last6++;
            }
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Pune"]) {
            if (selectedPeriodIndex == 1) {
                puneCount++;
            }
            if (selectedListTypeIndex==2) {
                last6++;
            }
        }
        if (selectedPeriodIndex == 1) {
            allCount++;
        }
       /* if (selectedListTypeIndex==2) {
            last6++;
        }*/
    }
    [periodControl setCount:[NSNumber numberWithInt:last6] forSegmentAtIndex:1];
    periodArray = rmaArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Location"] isEqualToString:@"MASON"] || [rmaData[@"Location"] isEqualToString:@"Mason"]) {
            if (selectedPeriodIndex == 2) {
                masonCount++;
            }
            if (selectedListTypeIndex==0) {
                all++;
            }
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Lausanne"]) {
            if (selectedPeriodIndex == 2) {
                lausanneCount++;
            }
            if (selectedListTypeIndex==1) {
                all++;
            }
        }
        else if ([rmaData[@"Location"] isEqualToString:@"Pune"]) {
            if (selectedPeriodIndex == 2) {
                lausanneCount++;
            }
            if (selectedListTypeIndex==2) {
                all++;
            }
        }
        if (selectedPeriodIndex == 2) {
            allCount++;
        }
        if (selectedListTypeIndex==2) {
            all++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:all] forSegmentAtIndex:2];
    [listTypeControl setCount:[NSNumber numberWithInt:masonCount] forSegmentAtIndex:0];
    [listTypeControl setCount:[NSNumber numberWithInt:lausanneCount] forSegmentAtIndex:1];
    [listTypeControl setCount:[NSNumber numberWithInt:puneCount] forSegmentAtIndex:2];
    switch (periodControl.selectedSegmentIndex) {
        case 0:
            [self getLast30Days];
            break;
        case 1:
            [self getLast6Months];
            break;
        default:
            filteredPeriodArray = rmaArray;
            break;
    }
}

- (void)initialiseStatusCounts {
    int authorizedCount=0,rmaEvalCount=0,allCount=0;
    int last30=0,last6=0,all=0;
    [self getLast30Days];
    NSMutableArray *periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"Authorized"]) {
            if (selectedPeriodIndex == 0) {
                authorizedCount++;
            }
            if (selectedListTypeIndex==0) {
                last30++;
            }
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Autopsy"]) {
            if (selectedPeriodIndex == 0) {
                rmaEvalCount++;
            }
            if (selectedListTypeIndex==1) {
                last30++;
            }
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Evaluation"]) {
            if (selectedPeriodIndex == 0) {
                allCount++;
            }
            if (selectedListTypeIndex==1) {
                last30++;
            }
        }
        if (selectedListTypeIndex==2) {
            last30++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:last30] forSegmentAtIndex:0];
    [self getLast6Months];
    periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"Authorized"]) {
            if (selectedPeriodIndex == 1) {
                authorizedCount++;
            }
            if (selectedListTypeIndex==0) {
                last6++;
            }
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Autopsy"]) {
            if (selectedPeriodIndex == 1) {
                rmaEvalCount++;
            }
            if (selectedListTypeIndex==1) {
                last6++;
            }
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Evaluation"]) {
            if (selectedPeriodIndex == 1) {
                allCount++;
            }
            if (selectedListTypeIndex==1) {
                last6++;
            }
        }
        if (selectedListTypeIndex==2) {
            last6++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:last6] forSegmentAtIndex:1];
    periodArray = rmaArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"Authorized"]) {
            if (selectedPeriodIndex == 2) {
                authorizedCount++;
            }
            if (selectedListTypeIndex==0) {
                all++;
            }
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Autopsy"]) {
            if (selectedPeriodIndex == 2) {
                rmaEvalCount++;
            }
            if (selectedListTypeIndex==1) {
                all++;
            }
        }
        else if ([rmaData[@"Status"] isEqualToString:@"RMA Evaluation"]) {
            if (selectedPeriodIndex == 2) {
                allCount++;
            }
            if (selectedListTypeIndex==1) {
                all++;
            }
        }
        if (selectedListTypeIndex==2) {
            all++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:all] forSegmentAtIndex:2];
    [listTypeControl setCount:[NSNumber numberWithInt:authorizedCount] forSegmentAtIndex:0];
    [listTypeControl setCount:[NSNumber numberWithInt:rmaEvalCount] forSegmentAtIndex:1];
    [listTypeControl setCount:[NSNumber numberWithInt:allCount] forSegmentAtIndex:2];
    switch (periodControl.selectedSegmentIndex) {
        case 0:
            [self getLast30Days];
            break;
        case 1:
            [self getLast6Months];
            break;
        default:
            filteredPeriodArray = rmaArray;
            break;
    }
}

- (void)initialiseProductCounts {
    int sentinelCount=0,iCelsiusCount=0,iCBlueCount=0,allCount=0;
    int last30=0,last6=0,all=0;
    [self getLast30Days];
    NSMutableArray *periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Product"] containsString:@"Sentinel"]) {
            if (selectedPeriodIndex == 0) {
                sentinelCount++;
            }
            if (selectedListTypeIndex==0) {
                last30++;
            }
        }
        else if ([rmaData[@"Product"] containsString:@"iCelsius Wireless"]) {
            if (selectedPeriodIndex == 0) {
                iCelsiusCount++;
            }
            if (selectedListTypeIndex==1) {
                last30++;
            }
        }
        else if ([rmaData[@"Product"] containsString:@"iCelsius Bluetooth"]) {
            if (selectedPeriodIndex == 0) {
                iCBlueCount++;
            }
            if (selectedListTypeIndex==1) {
                last30++;
            }
        }
       /* if (selectedPeriodIndex == 0) {
            allCount++;
        }*/
        if (selectedListTypeIndex==2) {
            last30++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:last30] forSegmentAtIndex:0];
    [self getLast6Months];
    periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Product"] containsString:@"Sentinel"]) {
            if (selectedPeriodIndex == 1) {
                sentinelCount++;
            }
            if (selectedListTypeIndex==0) {
                last6++;
            }
        }
        else if ([rmaData[@"Product"] containsString:@"iCelsius Wireless"]) {
            if (selectedPeriodIndex == 1) {
                iCelsiusCount++;
            }
            if (selectedListTypeIndex==1) {
                last6++;
            }
        }
        else if ([rmaData[@"Product"] containsString:@"iCelsius Bluetooth"]) {
            if (selectedPeriodIndex == 1) {
                iCBlueCount++;
            }
            if (selectedListTypeIndex==1) {
                last6++;
            }
        }

        if (selectedPeriodIndex == 1) {
            allCount++;
        }
        if (selectedListTypeIndex==2) {
            last6++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:last6] forSegmentAtIndex:1];
    periodArray = rmaArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Product"] containsString:@"Sentinel"]) {
            if (selectedPeriodIndex == 2) {
                sentinelCount++;
            }
            if (selectedListTypeIndex==0) {
                all++;
            }
        }
        else if ([rmaData[@"Product"] containsString:@"iCelsius Wireless"]) {
            if (selectedPeriodIndex == 2) {
                iCelsiusCount++;
            }
            if (selectedListTypeIndex==1) {
                all++;
            }
        }
        else if ([rmaData[@"Product"] containsString:@"iCelsius Bluetooth"]) {
            if (selectedPeriodIndex == 2) {
                iCBlueCount++;
            }
            if (selectedListTypeIndex==1) {
                all++;
            }
        }
        if (selectedPeriodIndex == 2) {
            allCount++;
        }
        if (selectedListTypeIndex==2) {
            all++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:all] forSegmentAtIndex:2];
    [listTypeControl setCount:[NSNumber numberWithInt:sentinelCount] forSegmentAtIndex:0];
    [listTypeControl setCount:[NSNumber numberWithInt:iCelsiusCount] forSegmentAtIndex:1];
    [listTypeControl setCount:[NSNumber numberWithInt:iCBlueCount] forSegmentAtIndex:2];
    switch (periodControl.selectedSegmentIndex) {
        case 0:
            [self getLast30Days];
            break;
        case 1:
            [self getLast6Months];
            break;
        default:
            filteredPeriodArray = rmaArray;
            break;
    }
}

- (void)initialiseClosedCounts {
    int last30=0,last6=0,all=0;
    [self getLast30Days];
    NSMutableArray *periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"RMA Closed"]) {
                last30++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:last30] forSegmentAtIndex:0];
    [self getLast6Months];
    periodArray = filteredPeriodArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"RMA Closed"]) {
            last6++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:last6] forSegmentAtIndex:1];
    periodArray = rmaArray;
    for (int i=0; i < periodArray.count; ++i) {
        NSMutableDictionary *rmaData = periodArray[i];
        if ([rmaData[@"Status"] isEqualToString:@"RMA Closed"]) {
            all++;
        }
    }
    [periodControl setCount:[NSNumber numberWithInt:all] forSegmentAtIndex:2];
    switch (periodControl.selectedSegmentIndex) {
        case 0:
            [self getLast30Days];
            break;
        case 1:
            [self getLast6Months];
            break;
        default:
            filteredPeriodArray = rmaArray;
            break;
    }
}

- (void)initialiseAllCounts {
    int last30=0,last6=0,all=0;
    [self getLast30Days];
    NSMutableArray *periodArray = filteredPeriodArray;
    [periodControl setCount:[NSNumber numberWithInt:periodArray.count] forSegmentAtIndex:0];
    [self getLast6Months];
    periodArray = filteredPeriodArray;
    [periodControl setCount:[NSNumber numberWithInt:periodArray.count] forSegmentAtIndex:1];
    periodArray = rmaArray;
    [periodControl setCount:[NSNumber numberWithInt:periodArray.count] forSegmentAtIndex:2];
    switch (periodControl.selectedSegmentIndex) {
        case 0:
            [self getLast30Days];
            break;
        case 1:
            [self getLast6Months];
            break;
        default:
            filteredPeriodArray = rmaArray;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RMAListViewCell";
    
    RMAListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    [cell setCellData:filteredArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showRMADetailForIndex:indexPath.row];
}

- (void)showRMADetailForIndex:(int)index {
    NSMutableDictionary *cellData = filteredArray[index];
    _rmaIdLabel.text = cellData[@"Rma Id"];
    _statusLabel.text = cellData[@"Status"];
    _productLabel.text = cellData[@"Product"];
    _purposeLabel.text = cellData[@"Purpose"];
    _createdByLabel.text = cellData[@"By"];
    _locationLabel.text = cellData[@"Location"];
    _descriptionTextView.text = cellData[@"Reason"];
    _orderIdLabel.text = cellData[@"Order Id"];
    _sensorsLabel.text = cellData[@"Sensors"];
    _rmaDetailView.hidden = false;
    _tintView.hidden = false;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _rmaDetailView.hidden = true;
        _tintView.hidden = true;
    }
}


@end
