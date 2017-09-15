//
//  OrderListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OrderListViewController.h"
#import "UIView+RNActivityView.h"
#import "OrderListViewCell.h"
#import "OrderListDetailViewCell.h"


@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  [self getPartsTransferList];
    self.title = @"Orders List";
    filteredArray = ordersArray;
    statusArray = @[@"Created",@"Approved",@"Awaiting Payment",@"Shipped", @"Partially Shipped", @"Cancelled", @"Closed",@"All"];
    productArray = @[@"iCelsius Wireless",@"Sentinel Next", @"Receptor", @"All"];

   // [self getLast30Days];
    switch (listType) {
        case LISTTYPESTATUS:
            dropdownArray = statusArray;
            break;
        case LISTTYPEPRODUCT:
            dropdownArray = productArray;
            break;
        default:
            break;
    }
    [_pickButton setTitle:dropdownArray[selectedIndex] forState:UIControlStateNormal];
    [self filterListForIndex:selectedIndex];
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
    [self getOrdersListWithStartDate:_startDateButton.titleLabel.text endDate:_endDateButton.titleLabel.text];
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
        static NSString *simpleTableIdentifier = @"OrderListDetailViewCell";
        OrderListDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        // cell.delegate = self;
        [cell setCellData:[partDetailsArray objectAtIndex:indexPath.row]];
        return cell;
    }
    static NSString *simpleTableIdentifier = @"OrderListViewCell";
    OrderListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    // cell.delegate = self;
    [cell setCellData:[filteredArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        selectedIndex = indexPath.row;
        NSMutableDictionary *partsData = filteredArray[indexPath.row];
        [self getDetailsForOrderId:[partsData[@"Order_id"] intValue]];
    }
}


- (void)getOrdersListWithStartDate:(NSString*)startDate endDate:(NSString*)endDate {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/order_list.php/?date1=%@&date2=%@",startDate,endDate];
    [connectionManager makeRequest:reqString withTag:6];
}

- (void)getDetailsForOrderId:(int)orderId {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Order list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/order_details.php\?id=%d",orderId];
    [connectionManager makeRequest:reqString withTag:9];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    ordersArray = [[NSMutableArray alloc] init];
    partDetailsArray = [[NSMutableArray alloc] init];

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
        [self setUpOrderDetails:json[0]];
        _partDetailsView.hidden = false;
        _tintView.hidden = false;
        [_detailsTableView reloadData];
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}


- (void)setUpOrderDetails:(NSMutableDictionary*)jsonDict {
    _accountIdLabel.text = jsonDict[@"Account Id"];
    _orderIdLabel.text = jsonDict[@"Order Id"];
    _customerLabel.text = jsonDict[@"Customer"];
    if (jsonDict[@"Product Id1"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonDict[@"Product Id1"],@"Product Id",jsonDict[@"Product1"], @"Product", jsonDict[@"Qty1"], @"Qty", nil];
        [partDetailsArray addObject:dict];
    }
    if (jsonDict[@"Product Id2"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonDict[@"Product Id2"],@"Product Id",jsonDict[@"Product2"], @"Product", jsonDict[@"Qty2"], @"Qty", nil];
        [partDetailsArray addObject:dict];
    }
    if (jsonDict[@"Product Id3"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonDict[@"Product Id3"],@"Product Id",jsonDict[@"Product3"], @"Product", jsonDict[@"Qty3"], @"Qty", nil];
        [partDetailsArray addObject:dict];
    }
    if (jsonDict[@"Product Id4"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonDict[@"Product Id4"],@"Product Id",jsonDict[@"Product4"], @"Product", jsonDict[@"Qty4"], @"Qty", nil];
        [partDetailsArray addObject:dict];
    }
    if (jsonDict[@"Product Id5"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonDict[@"Product Id5"],@"Product Id",jsonDict[@"Product5"], @"Product", jsonDict[@"Qty5"], @"Qty", nil];
        [partDetailsArray addObject:dict];
    }
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
    [_startDateButton setTitle:[dates lastObject] forState:UIControlStateNormal];
    [_endDateButton setTitle:dates[0] forState:UIControlStateNormal];
    [self getOrdersListWithStartDate:[dates lastObject] endDate:dates[0]];
}

- (void)setListType:(ListType)listType_ {
    listType = listType_;
}

- (void)setSelectedIndex:(int)index {
    selectedIndex = index;
}

- (void)filterListForIndex:(int)index {
    filteredArray = [[NSMutableArray alloc] init];
    filtered = true;
    if (index == 6) {
        filteredArray = ordersArray;
    }
    else if (index == dropdownArray.count-1) {
        filteredArray = ordersArray;
    }
    else {
        for (int i = 0; i < ordersArray.count; ++i) {
            NSMutableDictionary *orderData = ordersArray[i];
            switch (listType) {
                case LISTTYPESTATUS:
                    if ([orderData[@"Status"] isEqualToString:statusArray[index]]) {
                        [filteredArray addObject:orderData];
                    }
                    break;
                case LISTTYPEPRODUCT:
                    if ([orderData[@"Subject"] containsString:productArray[index]]) {
                        [filteredArray addObject:orderData];
                    }
                    break;
                default:
                    break;
            }
        }
    }
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)filteredArray.count];
    [_tableView reloadData];
}

- (void)setOrdersArray:(NSMutableArray*)ordersArray_ {
    ordersArray = ordersArray_;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _partDetailsView.hidden = true;
        _tintView.hidden = true;
        [_tableView reloadData];
    }
}

- (IBAction)pickButtonPressed:(id)sender {
    [self showPopUpWithTitle:@"Select Option" withOption:dropdownArray xy:CGPointMake(16, 50) size:CGSizeMake(287, 280) isMultiple:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    [_pickButton setTitle:dropdownArray[anIndex] forState:UIControlStateNormal];
    
    [self filterListForIndex:anIndex];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
}

- (void)DropDownListViewDidCancel{
    
}


@end
