//
//  OperatorDashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperatorDashboardViewController.h"
#import "OperatorDashboardViewCell.h"
#import "DataManager.h"
#import "OperatorScheduleViewController.h"

@interface OperatorDashboardViewController ()

@end

@implementation OperatorDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Ram",@"Pranali", @"Raman", @"Lalu", @"Arvind", @"Sadashiv", @"Sonali",nil];
    self.title = @"Operator Dashboard";
   // operationsArray = [__DataManager getThisWeekOperations];
    //[self initialiseDashboardData];
    [self getOperations];
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

- (void)initialiseDashboardData {
    operatorDataArray = [[NSMutableArray alloc] init];
    for (int i=0; i < operatorArray.count; ++i) {
        int count =0;
        int time =0;
        for (int j=0; j < operationsArray.count; ++j) {
            NSMutableDictionary *operationData = operationsArray[j];
            if ([operatorArray[i] isEqualToString:operationData[@"OperatorName"]]) {
                count=count+1;
                time = time+[operationData[@"Time"] intValue];
            }
        }
        NSMutableDictionary *operatorData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:operatorArray[i],@"Operator", [NSString stringWithFormat:@"%d",count],@"Quantity", [NSString stringWithFormat:@"%d",time],@"Time", nil];
        [operatorDataArray addObject:operatorData];
    }
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [operatorArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"OperatorDashboardViewCell";
    [collectionView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    OperatorDashboardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     [cell setCellData:operatorDataArray[indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OperatorScheduleViewController *operatorScheduleVC = [OperatorScheduleViewController new];
    [operatorScheduleVC setOperatorIndex:indexPath.row];
    [self.navigationController pushViewController:operatorScheduleVC animated:NO];
}

- (NSMutableArray*)thisWeekArray {
    NSMutableArray *weekArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    int startDate, endDate;
    
    [cal rangeOfUnit:NSWeekCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
    
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    startDateString = [dateFormat stringFromDate:startOfTheWeek];
    endDateString = [dateFormat stringFromDate:endOfWeek];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    NSComparisonResult startCompare = [startOfTheWeek compare: endOfWeek];
    int i=0;
    NSDate *weekDate;
    while((startCompare == NSOrderedAscending)&&(startCompare != NSOrderedSame)) {
        weekDate = [startOfTheWeek dateByAddingTimeInterval:24*60*60*i];
        [weekArray addObject:[dateFormat stringFromDate:weekDate]];
        startCompare = [weekDate compare: endOfWeek];
        NSLog(@"week array = %@",weekArray);
        i++;
    }
    
    NSLog(@"start date = %@, end date= %@",startDateString,endDateString);
    return weekArray;
}

- (void)getOperations {
    //filteredRunsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    //[query whereKey:@"DateAssigned" equalTo:dateString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        operationsArray = [objects mutableCopy];
       // [_tableView reloadData];
        [self getOperationsForToday];
    }];
}

- (void)getOperationsForToday {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];

    NSMutableArray *todayOperations = [[NSMutableArray alloc] init];
    for (int i=0; i < operationsArray.count; ++i) {
        NSMutableDictionary *operationData = operationsArray[i];
        if ([operationData[@"DateAssigned"] isEqualToString:[dateFormat stringFromDate:[NSDate date]]]) {
            [todayOperations addObject:operationData];
        }
    }
    NSLog(@"todayoperations = %@",todayOperations);
    operationsArray = todayOperations;
    [self initialiseDashboardData];
}


@end
