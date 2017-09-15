//
//  PartsTransferViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "PartsTransferViewController.h"
#import "UIView+RNActivityView.h"
#import "PartsTransferViewCell.h"
#import "PartsTransferDetailViewCell.h"


@interface PartsTransferViewController ()

@end

@implementation PartsTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  [self getPartsTransferList];
    self.title = @"Parts Transfer List";
    //filteredArray = [[NSMutableArray alloc] init];
    NSArray *items = @[@"Last 30 days", @"Custom Range"];
    
    periodControl = [[DZNSegmentedControl alloc] initWithItems:items];
    periodControl.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    periodControl.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 50);
    
    [periodControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:periodControl];
    [self getLast30Days];
    locationArray = @[@"PUNE",@"MASON",@"LAUSANNE",@"ALL"];
    statusArray = @[@"Open",@"Closed",@"All"];
    [_pickLocationButton setTitle:@"ALL" forState:UIControlStateNormal];
    [_pickStatusButton setTitle:@"Open" forState:UIControlStateNormal];
    selectedLocationIndex = 3;
    selectedStatusIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    [_pickLocationButton setTitle:@"ALL" forState:UIControlStateNormal];
    [_pickStatusButton setTitle:@"Open" forState:UIControlStateNormal];
    selectedLocationIndex = 3;
    selectedStatusIndex = 0;
    selectedPeriodIndex = control.selectedSegmentIndex;
    switch (control.selectedSegmentIndex) {
        case 0: {
            [self getLast30Days];
            _customRangeView.hidden = true;
            _tableContainerView.transform = CGAffineTransformMakeTranslation(0, 0);

        }
            break;
        case 1: {
            _customRangeView.hidden = false;
            _tableContainerView.transform = CGAffineTransformMakeTranslation(0, 80);
            [self getPartsTransferListWithStartDate:_startDateButton.titleLabel.text endDate:_endDateButton.titleLabel.text];
        }
            break;
    }
    [_tableView reloadData];
    //[self resetCounts];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pickDatePressed:(UIButton*)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2014-09-22"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    calendar.tag = sender.tag;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    [self.view addSubview:self.dateLabel];
}

-(IBAction)reloadPressed:(UIButton*)sender {
    [self getPartsTransferListWithStartDate:_startDateButton.titleLabel.text endDate:_endDateButton.titleLabel.text];
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
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    if (calendar.tag == 1) {
        [_startDateButton setTitle:dateString forState:UIControlStateNormal];
    }
    else {
        [_endDateButton setTitle:dateString forState:UIControlStateNormal];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_detailsTableView]) {
        return [partDetailsArray count];
    }
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_detailsTableView]) {
        static NSString *simpleTableIdentifier = @"PartsTransferDetailViewCell";
        PartsTransferDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        // cell.delegate = self;
        [cell setCellData:[partDetailsArray objectAtIndex:indexPath.row]];
        return cell;
    }
    static NSString *simpleTableIdentifier = @"PartsTransferViewCell";
    PartsTransferViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    // cell.delegate = self;
    [cell setCellData:[filteredArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        selectedListIndex = indexPath.row;
        NSMutableDictionary *partsData = filteredArray[indexPath.row];
        [self getDetailsForTransferId:[partsData[@"Transfer_id"] intValue]];
    }
}


- (void)getPartsTransferListWithStartDate:(NSString*)startDate endDate:(NSString*)endDate {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/transfer_parts.php/?location=1&date1=%@&date2=%@",startDate,endDate];
    [connectionManager makeRequest:reqString withTag:6];
}

- (void)getDetailsForTransferId:(int)transferId {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/transfer_parts_details.php\?tid=%d",transferId];
    [connectionManager makeRequest:reqString withTag:7];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
   // partsTransferArray = [[NSMutableArray alloc] init];
    
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        partsTransferArray = [[NSMutableArray alloc] init];
        filteredArray = partsTransferArray;
        [_tableView reloadData];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            if (tag == 6) {
                partsTransferArray = json;
                selectedLocationIndex = 3;
                selectedStatusIndex = 0;
                [self filterList];
                [_tableView reloadData];
            }
            else {
                 partDetailsArray = json;
                NSMutableDictionary *partDetailData = partsTransferArray[selectedListIndex];
                _rmaIdLabel.text = [NSString stringWithFormat:@"#%@",partDetailData[@"Transfer_id"]];
                _partDetailsView.hidden = false;
                _tintView.hidden = false;
                [_detailsTableView reloadData];
            }
        }
        else {
            partsTransferArray = [[NSMutableArray alloc] init];
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)getLast7Days {
    int numberOfDays=7;
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
    [_startDateButton setTitle:[dates lastObject] forState:UIControlStateNormal];
    [_endDateButton setTitle:dates[0] forState:UIControlStateNormal];
    [self getPartsTransferListWithStartDate:[dates lastObject] endDate:dates[0]];
}

- (void)getLast30Days {
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
    [_startDateButton setTitle:[dates lastObject] forState:UIControlStateNormal];
    [_endDateButton setTitle:dates[0] forState:UIControlStateNormal];
    [self getPartsTransferListWithStartDate:[dates lastObject] endDate:dates[0]];
}

- (void)filterList {
    NSString *location = locationArray[selectedLocationIndex];
    NSString *status = statusArray[selectedStatusIndex];
    filteredArray = [[NSMutableArray alloc] init];
    if (([status isEqualToString:@"All"])&&([location isEqualToString:@"ALL"])) {
        filteredArray = partsTransferArray;
    }
    else {
        for (int i=0; i < partsTransferArray.count; ++i) {
            NSMutableDictionary *partsTransferData = partsTransferArray[i];
            if ([status isEqualToString:@"All"]) {
                if ([partsTransferData[@"Location 1"] isEqualToString:location]) {
                    [filteredArray addObject:partsTransferData];
                }
            }
            else if([location isEqualToString:@"ALL"]) {
                if([status isEqualToString:@"Open"]) {
                    if (([partsTransferData[@"Status"] isEqualToString:@"Created"])||([partsTransferData[@"Status"] isEqualToString:@"Transferred"])) {
                        [filteredArray addObject:partsTransferData];
                    }
                }
                else if([status isEqualToString:@"Closed"]) {
                    if (([partsTransferData[@"Status"] isEqualToString:@"Received"])||([partsTransferData[@"Status"] isEqualToString:@"Closed"])) {
                        [filteredArray addObject:partsTransferData];
                    }
                }
            }
            else if([status isEqualToString:@"Open"]) {
                if ((([partsTransferData[@"Status"] isEqualToString:@"Created"])||([partsTransferData[@"Status"] isEqualToString:@"Transferred"]))&&([partsTransferData[@"Location 1"] isEqualToString:location])) {
                    [filteredArray addObject:partsTransferData];
                }
            }
            else if([status isEqualToString:@"Closed"]) {
                if ((([partsTransferData[@"Status"] isEqualToString:@"Received"])||([partsTransferData[@"Status"] isEqualToString:@"Closed"]))&&([partsTransferData[@"Location 1"] isEqualToString:location])) {
                    [filteredArray addObject:partsTransferData];
                }
            }
            else if (([partsTransferData[@"Location 1"] isEqualToString:location])&&([partsTransferData[@"Status"] isEqualToString:status])) {
                [filteredArray addObject:partsTransferData];
            }
        }
    }
    NSLog(@"filteredArray=%@",filteredArray);
    [periodControl setCount:[NSNumber numberWithInt:filteredArray.count] forSegmentAtIndex:selectedPeriodIndex];
    [_tableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _partDetailsView.hidden = true;
        _tintView.hidden = true;
        [_tableView reloadData];
    }
}

- (IBAction)pickLocationButtonPressed:(id)sender {
    selectedDropDownTag = 1;
    [self showPopUpWithTitle:@"Select Option" withOption:locationArray xy:CGPointMake(16, 50) size:CGSizeMake(287, 280) isMultiple:NO];
}

- (IBAction)pickStatusButtonPressed:(id)sender {
    selectedDropDownTag = 2;
    [self showPopUpWithTitle:@"Select Option" withOption:statusArray xy:CGPointMake(16, 50) size:CGSizeMake(287, 280) isMultiple:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    switch (selectedDropDownTag) {
        case 1:{
             [_pickLocationButton setTitle:locationArray[anIndex] forState:UIControlStateNormal];
            selectedLocationIndex = anIndex;
        }
            break;
        case 2:{
            [_pickStatusButton setTitle:statusArray[anIndex] forState:UIControlStateNormal];
            selectedStatusIndex = anIndex;
        }
            break;
            
        default:
            break;
    }
    [self filterList];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
}

- (void)DropDownListViewDidCancel{
    
}


@end
