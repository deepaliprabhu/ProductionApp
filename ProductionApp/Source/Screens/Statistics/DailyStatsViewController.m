//
//  DailyStatsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "DailyStatsViewController.h"
#import "DailyStatsViewCell.h"
#import "DailyEntryViewController.h"
#import "UIView+RNActivityView.h"
#import <Parse/Parse.h>
#import "Station.h"
#import "DailyListViewController.h"
#import "DailyEntryHistoryViewController.h"

@interface DailyStatsViewController ()

@end

@implementation DailyStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Process List" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightButton;

    _stationDetailsView.layer.cornerRadius = 8.0f;
    _stationDetailsView.layer.borderColor = [UIColor orangeColor].CGColor;
    _stationDetailsView.layer.borderWidth = 0.5f;
        processArray = [NSMutableArray arrayWithObjects:@"Inward Inspection & Testing", @"Soldering", @"Mechanical Assembly", @"Final Inspection",@"Cleaning & Packaging", @"Moulding", @"Other",nil];
        operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Ram",@"Pranali", @"Raman", @"Lalu", @"Arvind", @"",nil];
    self.title = @"Stations";

    stationsArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    [_dateButton setTitle:selectedDateString forState:UIControlStateNormal];
    //selectedDate = [NSDate date];
    //[self getParseDailyData];
    [self initialiseStations:operationsArray];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self getParseDailyData];
}

- (void)rightButtonPressed {

}

- (void)setParseData:(NSMutableArray*)parseArray {
    operationsArray = parseArray;
}

- (void)setDateString:(NSString*)dateString {
    selectedDateString = dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTag:(int)tag_ {
    tag = tag_;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [stationsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"DailyStatsViewCell";
    [collectionView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    DailyStatsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setCellData:stationsArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (tag == 1) {
        DailyEntryViewController *dailyEntryVC = [DailyEntryViewController new];
        [dailyEntryVC setStation:(indexPath.row+1)];
        [self.navigationController pushViewController:dailyEntryVC animated:FALSE];
    }
    else {
        _stationDetailsView.hidden = false;
        _tintView.hidden = false;
        [self showDetailsForStation:indexPath.row];
    }
}

- (void)showDetailsForStation:(int)stationId {
    Station *station = stationsArray[stationId];
    _stationTitleLabel.text = [NSString stringWithFormat:@"%d - %@",[station getStationId], [station getStationName]];
    [[_stationEntriesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSMutableArray *stationEntries = [station getProcessEntries];
    for (int i=0; i < [stationEntries count]; ++i) {
        NSMutableDictionary *stationEntry = stationEntries[i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (i*60), _stationEntriesView.frame.size.width, 60)];
       // view.backgroundColor = [UIColor yellowColor];
        UILabel *processLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 25)];
        processLabel.text = stationEntry[@"ProcessName"];
        processLabel.textColor = [UIColor orangeColor];
        processLabel.font = [UIFont systemFontOfSize:13.0f];
        [view addSubview:processLabel];
        
        UILabel *operatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-110, view.frame.size.height-25, 100, 25)];
        operatorLabel.text = stationEntry[@"Operator"];
        operatorLabel.textAlignment = NSTextAlignmentRight;
        operatorLabel.font = [UIFont systemFontOfSize:10.0f];
        operatorLabel.textColor = [UIColor grayColor];
        [view addSubview:operatorLabel];
        
        UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 150, 25)];
        productLabel.text = stationEntry[@"ProductName"];
        productLabel.font = [UIFont systemFontOfSize:10.0f];
        productLabel.textColor = [UIColor grayColor];
        [view addSubview:productLabel];
        
        UILabel *qtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-60, 5, 50, 25)];
        qtyLabel.text = stationEntry[@"Quantity"];
        qtyLabel.textAlignment = NSTextAlignmentRight;
        qtyLabel.font = [UIFont systemFontOfSize:12.0f];
        [view addSubview:qtyLabel];
        [_stationEntriesView addSubview:view];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(5, view.frame.size.height-5, _stationEntriesView.frame.size.width-5, 0.5)];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:separatorView];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    _stationDetailsView.hidden = TRUE;
    _tintView.hidden = true;
}

- (void)getParseDailyData {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:50];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
    
    NSLog(@"Date selected :%@", [dateFormat stringFromDate:[NSDate date]]);
    [query whereKey:@"Date" equalTo:[dateFormat stringFromDate:selectedDate]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        //[PFObject pinAllInBackground:objects];
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [self.navigationController.view hideActivityView];
        
        [self initialiseStations:[objects mutableCopy]];
        [_collectionView reloadData];
    }];
}

-(void)initialiseStations:(NSMutableArray *)parseDataArray {
    stationsArray = [[NSMutableArray alloc] init];
    int totalQty = 0;
    int totalTime = 0;
    for (int i=0; i < 7; ++i) {
        Station *station = [Station new];
        [station setStationId:i+1];
        [station setStationName:processArray[i]];
        [station setOperatorName:operatorArray[i]];
        int quantity=0;
        int time = 0;
        for (int j=0; j < [parseDataArray count]; ++j) {
            NSMutableDictionary *parseData = parseDataArray[j];
            if ([parseData[@"Station"] intValue] == i+1) {
                [station addProcessEntry:parseData];
                quantity = quantity+[parseData[@"Quantity"] intValue];
                time = time + [parseData[@"Time"] intValue];
            }
        }
        [station setQuantity:quantity];
        [station setTime:time];
        totalTime = totalTime+time;
        totalQty = totalQty+quantity;
        [stationsArray addObject:station];
    }
    _qtyLabel.text = [NSString stringWithFormat:@"%d",totalQty];
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",(float)totalTime/60];
    NSLog(@"stations data = %@", stationsArray);
    [_collectionView reloadData];
}


- (IBAction)dateButtonPressed:(UIButton*)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    [self.view addSubview:self.dateLabel];
}

- (void)editButtonPressed {
    DailyListViewController *dailyListVC= [DailyListViewController new];
    [self.navigationController pushViewController:dailyListVC animated:NO];
}

- (IBAction)viewHistoryPressed {
    DailyEntryHistoryViewController *historyVC= [DailyEntryHistoryViewController new];
    [self.navigationController pushViewController:historyVC animated:NO];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    // dateItem.backgroundColor = [UIColor redColor];
    // dateItem.textColor = [UIColor whiteColor];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return true;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    selectedDate = date;
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
    //[self getParseDailyData];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        //self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
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
