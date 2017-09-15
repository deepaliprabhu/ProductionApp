//
//  FeedbackListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "FeedbackListViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "ServerManager.h"
#import "FeedbackListViewCell.h"

@interface FeedbackListViewController ()

@end

@implementation FeedbackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[__ServerManager getFeedbacks];
    feedbackArray = [__DataManager getFeedbackList];
    filteredArray = feedbackArray;
    statusArray = @[@"Created",@"In Evaluation", @"Acknowledged", @"Additional Information", @"Modification required (Redesign)", @"Development & testing", @"Closed", @"All"];
    ownerArray = @[@"Pune",@"Lausanne", @"Mason", @"All"];
    categoryArray = @[@"Cosmetic",@"Hardware Failure", @"Logical Failure", @"Procedural Failure",@"Design Issue", @"Software/Firmware", @"All"];
    productArray = @[@"iCelsius Wireless",@"Sentinel Next", @"Receptor", @"All"];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initFeedbacks) name:kNotificationFeedbacksReceived object:nil];
    switch (listType) {
        case LISTTYPESTATUS:
            dropdownArray = statusArray;
            break;
        case LISTTYPEOWNER:
            dropdownArray = ownerArray;
            break;
        case LISTTYPECATEGORY:
            dropdownArray = categoryArray;
            break;
        case LISTTYPEPRODUCT:
            dropdownArray = productArray;
            break;
        default:
            break;
    }
    [_pickButton setTitle:dropdownArray[selectedIndex] forState:UIControlStateNormal];
    [self filterListForIndex:selectedIndex];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initFeedbacks {
    feedbackArray = [__DataManager getFeedbackList];
    filteredArray = feedbackArray;
    NSLog(@"feedbackArray=%@",feedbackArray);
    [_tableView reloadData];
}

- (void)setListType:(ListType)listType_ {
    listType = listType_;
}

- (void)setSelectedIndex:(int)index {
    selectedIndex = index;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"FeedbackListViewCell";
    
    FeedbackListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    [cell setCellData:filteredArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showFeedbackDetailForIndex:indexPath.row];
}

- (void)showFeedbackDetailForIndex:(int)index {
    NSDictionary *feedbackDetailData = filteredArray[index];
    _rmaIdLabel.text = feedbackDetailData[@"RMA Id"];
    _feedbackIdLabel.text = feedbackDetailData[@"Feedback Id"];
    _transferIdLabel.text = feedbackDetailData[@"Transfer Id"];
    _totalQtyLabel.text = feedbackDetailData[@"Total Qty"];
    _defectQtyLabel.text = feedbackDetailData[@"Defect Qty"];
    _ownerLabel.text = feedbackDetailData[@"Owner"];
    _locationLabel.text = feedbackDetailData[@"Location"];
    _statusLabel.text = feedbackDetailData[@"Status"];
    _productLabel.text = feedbackDetailData[@"Product Name"];
    _issuesTextView.text = feedbackDetailData[@"Issues"];
    _categoryLabel.text = feedbackDetailData[@"Category"];
    _createdByLabel.text = feedbackDetailData[@"By"];
    _runIdLabel.text = feedbackDetailData[@"Run Id"];
    _receivedLabel.text = feedbackDetailData[@"Received"];
    _feedbackDetailView.hidden = false;
    _tintView.hidden = false;
    NSString *urlString = feedbackDetailData[@"Image Refer"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(-50, -80, -50, -80);
    [_webView loadRequest:urlRequest];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _feedbackDetailView.hidden = true;
        _tintView.hidden = true;
        [dropDownList fadeOut];
    }
}

- (void)filterListForIndex:(int)index {
    filteredArray = [[NSMutableArray alloc] init];
    filtered = true;
    if (index == dropdownArray.count-1) {
        filteredArray = feedbackArray;
    }
    else {
        for (int i = 0; i < feedbackArray.count; ++i) {
            NSMutableDictionary *feedbackData = feedbackArray[i];
            switch (listType) {
                case LISTTYPESTATUS:
                    if ([feedbackData[@"Status"] isEqualToString:statusArray[index]]) {
                        [filteredArray addObject:feedbackData];
                    }
                    break;
                case LISTTYPEOWNER:
                    if ([feedbackData[@"Owner"] isEqualToString:ownerArray[index]]) {
                        [filteredArray addObject:feedbackData];
                    }
                    break;
                case LISTTYPECATEGORY:
                    if ([feedbackData[@"Category"] isEqualToString:categoryArray[index]]) {
                        [filteredArray addObject:feedbackData];
                    }
                    break;
                case LISTTYPEPRODUCT:
                    if ([feedbackData[@"Product Name"] containsString:productArray[index]]) {
                        [filteredArray addObject:feedbackData];
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
    
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    /*sensorIdList = @"";
    for (int i=0; i<ArryData.count; ++i) {
        Sensor *sensor = [__DataManager getSensorWithName:ArryData[i]];
        if (i==0) {
            sensorIdList = [[sensorIdList stringByAppendingString:[NSString stringWithFormat:@"%d",[sensor getSensorId]]] mutableCopy];
        }
        else {
            sensorIdList = [[sensorIdList stringByAppendingString:[NSString stringWithFormat:@",%d",[sensor getSensorId]]] mutableCopy];
        }
    }
    [_pickSensorButton setTitle:sensorIdList forState:UIControlStateNormal];*/
}

- (void)DropDownListViewDidCancel{
    
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 
 if ([touch.view isKindOfClass:[UIView class]]) {
 [dropDownList fadeOut];
 }
 }*/

@end
