//
//  ShipmentViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "ShipmentViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "Utilities.h"

@interface ShipmentViewController ()

@end

@implementation ShipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shipment";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSArray *items = @[@"Transfer List",@"Order List"];
    
    control = [[DZNSegmentedControl alloc] initWithItems:items];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.frame = CGRectMake(0, 60, self.view.bounds.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    
    [self initData];
    [self getPartsTransferList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    selectedSegment = control.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0: {
            _transferIdTitleLabel.text = @"Transfer Id:";
            _locationTitleLabel.text = @"Location:";
            [_transferIdButton setTitle:@"Pick Transfer Id" forState:UIControlStateNormal];
            [self getPartsTransferList];
        }
            break;
        case 1: {
            _transferIdTitleLabel.text = @"Order Id:";
            _locationTitleLabel.text = @"Subject:";
            [_transferIdButton setTitle:@"Pick Order Id" forState:UIControlStateNormal];

             [self getOrderList];
        }
            break;
        default:
            break;
    }
}

- (void)initData {
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"Products" ofType:@"plist"];
    
    // Build the array from the plist
    productArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
}

- (void) initView {
    
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

- (IBAction)getDetailsButtonPressed:(UIButton*)sender {
    if (selectedSegment == 0) {
        [self getDetailsForTransferId:[_transferIdButton.titleLabel.text intValue]];
    }
    else {
        [self getDetailsForOrderId:[_transferIdButton.titleLabel.text intValue]];
    }
}

- (IBAction)partsTransferButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 195;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :transferIdArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)productButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 195;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :productArray :nil :@"up"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)locationButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 195;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :locationArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    selectedListIndex = index;
    if (![_transferIdButton.titleLabel.text isEqualToString:@"Pick Transfer Id"]) {
        [_locationButton setTitle:[locationArray objectAtIndex:index] forState:UIControlStateNormal];
    }
    [_locationButton setTitle:[locationArray objectAtIndex:index] forState:UIControlStateNormal];
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (IBAction)submitPressed:(id)sender {
    [self saveShipmentDataInParse];
}

- (IBAction)addPressed:(id)sender {
    if (![_quantityTF.text intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter valid quantity" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if ([_productButton.titleLabel.text isEqualToString:@"Pick Product"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Pick a Product to add" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if ([_quantityTF.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter in quantity" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10+((_productsScrollView.subviews.count-2)*25), _productsScrollView.frame.size.width, 35)];
    [_productsScrollView addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250, 30)];
    label.text = _productButton.titleLabel.text;
    label.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:label];
    
    UILabel *quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 30)];
    quantityLabel.text = _quantityTF.text;
    quantityLabel.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:quantityLabel];
}

- (void)saveShipmentDataInParse {
    [self.navigationController.view showActivityViewWithLabel:@"saving data"];

    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat1 dateFromString:_dateButton.titleLabel.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];
    //here add elements to data file and write data to file
    
    PFQuery *query = [PFQuery queryWithClassName:@"Shipment"];
    [query whereKey:@"TransferId" equalTo:_transferIdButton.titleLabel.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if (objects.count == 0) {
            PFObject *run = [PFObject objectWithClassName:@"Shipment"];

           // NSMutableDictionary *partsTransferData = partsTransferArray[selectedListIndex];
            run[@"Location"] = _locationButton.titleLabel.text;
            //run[@"Status"] = partsTransferData[@"Status"];
            run[@"Date"] = dateString;
            run[@"TrackingId"] = _trackingIdTF.text;
            run[@"TransferId"] = _transferIdButton.titleLabel.text;
            NSLog(@"saving parse object");
            
            [__ParseDataManager setDelegate:self];
            [__ParseDataManager saveParseData:run];
            [self saveShipmentProductsForId:run.objectId];
        }
        else {
            [self.navigationController.view hideActivityView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Shipment Data already exists!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
    }];

}

- (void)saveShipmentProductsForId:(NSString*)shipmentId {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat1 dateFromString:_dateButton.titleLabel.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];
    for (int i=0; i < partDetailsArray.count; ++i) {
        NSDictionary *partsData = partDetailsArray[i];
        PFObject *run = [PFObject objectWithClassName:@"ShipmentProducts"];
        if (selectedSegment == 0) {
            run[@"ShipmentId"] = shipmentId;
            run[@"ProductName"] = partsData[@"Part Number"];
            run[@"ProductNumber"] = partsData[@"Part Number"];
            run[@"ProductDetails"] = partsData[@"Details"];
            run[@"Quantity"] = partsData[@"Qty"];
            run[@"Location"] = _locationButton.titleLabel.text;
            run[@"ShippingDate"] = dateString;
        }
        else {
            run[@"ShipmentId"] = shipmentId;
            run[@"ProductName"] = partsData[@"ProductName"];
            run[@"ProductNumber"] = partsData[@"ProductNumber"];
            run[@"ProductDetails"] = partsData[@"ProductNumber"];
            run[@"Quantity"] = partsData[@"Qty"];
            run[@"Location"] = _locationButton.titleLabel.text;
            run[@"ShippingDate"] = dateString;
        }

        [__ParseDataManager setDelegate:self];
        [__ParseDataManager saveParseData:run];
        NSLog(@"saving parse object");
    }
}

- (void) receivedParseData {
    [self.navigationController.view hideActivityView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// UITextfieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
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
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
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

- (void)getPartsTransferList {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://www.aginova.info/aginova/json/transfer_parts.php/?location=1&date1=2016-01-12&date2=2016-12-12";
    [connectionManager makeRequest:reqString withTag:6];
}

- (void)getOrderList {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Orders list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://www.aginova.info/aginova/json/order_list.php/?date1=2016-01-12&date2=2016-12-12";
    [connectionManager makeRequest:reqString withTag:8];
}

- (void)getDetailsForTransferId:(int)transferId {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/transfer_parts_details.php\?tid=%d",transferId];
    [connectionManager makeRequest:reqString withTag:7];
}

- (void)getDetailsForOrderId:(int)orderId {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Order list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/order_details.php\?id=%d",orderId];
    [connectionManager makeRequest:reqString withTag:9];
}

- (void) displayErrorWithMessage:(NSString*)errorMessage {
    
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    partsTransferArray = [[NSMutableArray alloc] init];
    transferIdArray = [[NSMutableArray alloc] init];
    locationArray = [[NSMutableArray alloc] init];

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
            if (tag == 6) {
                for (int i=0; i < json.count; ++i) {
                    NSMutableDictionary *partsTransferData = json[i];
                        [partsTransferArray addObject:partsTransferData];
                        [transferIdArray addObject:partsTransferData[@"Transfer_id"]];
                        [locationArray addObject:partsTransferData[@"Location"]];
                }
            }
            else if (tag == 8) {
                for (int i=0; i < json.count; ++i) {
                    NSMutableDictionary *partsTransferData = json[i];
                    [partsTransferArray addObject:partsTransferData];
                    [transferIdArray addObject:partsTransferData[@"Order_id"]];
                    [locationArray addObject:partsTransferData[@"Subject"]];
                }
            }
            else if (tag == 9) {
                [self fillOrders:json[0]];
            }
            else {
               // partDetailsArray = json;
                [self fillParts:json];
            }

        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}

- (void)fillOrders:(NSDictionary*)orderData {
    [[_productsScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    partDetailsArray = [[NSMutableArray alloc] init];

    if (orderData[@"Product1"]) {
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:orderData[@"Product1"],@"ProductName",orderData[@"Product Id1"],@"ProductNumber",orderData[@"Qty1"],@"Quantity", nil];
        [partDetailsArray addObject:productDict];
    }
    if (orderData[@"Product2"]) {
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:orderData[@"Product2"],@"ProductName",orderData[@"Product Id2"],@"ProductNumber",orderData[@"Qty2"],@"Quantity", nil];
        [partDetailsArray addObject:productDict];
    }
    if (orderData[@"Product3"]) {
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:orderData[@"Product3"],@"ProductName",orderData[@"Product Id3"],@"ProductNumber",orderData[@"Qty3"],@"Quantity", nil];
        [partDetailsArray addObject:productDict];
    }
    if (orderData[@"Product4"]) {
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:orderData[@"Product4"],@"ProductName",orderData[@"Product Id4"],@"ProductNumber",orderData[@"Qty4"],@"Quantity", nil];
        [partDetailsArray addObject:productDict];
    }
    if (orderData[@"Product5"]) {
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:orderData[@"Product5"],@"ProductName",orderData[@"Product Id5"],@"ProductNumber",orderData[@"Qty5"],@"Quantity", nil];
        [partDetailsArray addObject:productDict];
    }
    
    [_productsScrollView setContentSize:CGSizeMake(_productsScrollView.frame.size.width, partDetailsArray.count*75)];
    for (int i=0; i < partDetailsArray.count; ++i) {
        NSMutableDictionary *partsData = partDetailsArray[i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (i*70)+5, _productsScrollView.frame.size.width, 70)];
        //view.backgroundColor = [UIColor yellowColor];
        [_productsScrollView addSubview:view];
        
        UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, view.frame.size.width-50, 25)];
        titleTF.text = partsData[@"ProductName"];
        titleTF.textColor = [UIColor blackColor];
        titleTF.font = [UIFont systemFontOfSize:12.0f];
        titleTF.delegate = self;
        titleTF.tag = i+1;
        [titleTF setBorderStyle:UITextBorderStyleRoundedRect];
        [view addSubview:titleTF];
        
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 45)];
        detailsLabel.text = partsData[@"ProductNumber"];
        detailsLabel.numberOfLines = 2;
        detailsLabel.textColor = [UIColor darkGrayColor];
        detailsLabel.font = [UIFont systemFontOfSize:10.0f];
        [view addSubview:detailsLabel];
        
        UILabel *qtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-35, 5, 25, 25)];
        qtyLabel.text = partsData[@"Quantity"];
        qtyLabel.textColor = [UIColor blackColor];
        qtyLabel.font = [UIFont systemFontOfSize:13.0f];
        [view addSubview:qtyLabel];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-35, 40, 30, 30)];
        [deleteButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(deleteProduct:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteButton];
        
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-70, 40, 25, 25)];
        [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        editButton.tag = i;
        [editButton addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
        //[view addSubview:editButton];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, _productsScrollView.frame.size.width, 1)];
        separatorView.backgroundColor = [UIColor orangeColor];
        [view addSubview:separatorView];
    }


}

- (void)fillParts:(NSMutableArray *)partsArray {

    [[_productsScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    partDetailsArray = [[NSMutableArray alloc] init];
    for (int i=0; i < partsArray.count; ++i) {
        NSMutableDictionary *partsData = partsArray[i];
        if ([partsData[@"Qty"] intValue] >0) {
            [partDetailsArray addObject:partsData];
        }
    }
    [_productsScrollView setContentSize:CGSizeMake(_productsScrollView.frame.size.width, partDetailsArray.count*75)];
    for (int i=0; i < partDetailsArray.count; ++i) {
        NSMutableDictionary *partsData = partDetailsArray[i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (i*70)+5, _productsScrollView.frame.size.width, 70)];
        //view.backgroundColor = [UIColor yellowColor];
        [_productsScrollView addSubview:view];
        
        UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, view.frame.size.width-50, 25)];
        titleTF.text = partsData[@"Part Number"];
        titleTF.textColor = [UIColor blackColor];
        titleTF.font = [UIFont systemFontOfSize:12.0f];
        titleTF.delegate = self;
        titleTF.tag = i+1;
        [titleTF setBorderStyle:UITextBorderStyleRoundedRect];
        [view addSubview:titleTF];
        
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 45)];
        detailsLabel.text = partsData[@"Details"];
        detailsLabel.numberOfLines = 2;
        detailsLabel.textColor = [UIColor darkGrayColor];
        detailsLabel.font = [UIFont systemFontOfSize:10.0f];
        [view addSubview:detailsLabel];
        
        UILabel *qtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-35, 5, 25, 25)];
        qtyLabel.text = partsData[@"Qty"];
        qtyLabel.textColor = [UIColor blackColor];
        qtyLabel.font = [UIFont systemFontOfSize:13.0f];
        [view addSubview:qtyLabel];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-35, 40, 30, 30)];
        [deleteButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(deleteProduct:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteButton];
        
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-70, 40, 25, 25)];
        [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        editButton.tag = i;
        [editButton addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
        //[view addSubview:editButton];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, _productsScrollView.frame.size.width, 1)];
        separatorView.backgroundColor = [UIColor orangeColor];
        [view addSubview:separatorView];
    }
}

- (void)deleteProduct:(UIButton*)sender {
    [partDetailsArray removeObjectAtIndex:sender.tag];
    [self fillParts:partDetailsArray];
}

- (void)editProduct:(UIButton*)sender {
    
}

- (void)keyboardDidShow: (NSNotification *) notif{
    self.view.transform = CGAffineTransformMakeTranslation(0, selectedTag*(-55));
}

- (void)keyboardDidHide: (NSNotification *) notif{
    if (self.view.frame.origin.y < 0) {
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    selectedTag = textField.tag;
    return true;
}


@end
