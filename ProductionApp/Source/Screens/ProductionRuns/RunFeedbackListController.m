//
//  RunFeedbackListController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RunFeedbackListController.h"
#import "RunFeedbackListCell.h"

@interface RunFeedbackListController ()

@end

@implementation RunFeedbackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = false;
    self.title = feedbackArray[0][@"Product Name"];
    filteredArray = feedbackArray;
    dropDownArray = [NSMutableArray arrayWithObjects:@"Open", @"Closed", @"All",nil];
    [self filterListForIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFeedbackArray:(NSMutableArray*)feedbackArray_ {
    feedbackArray = feedbackArray_;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"productsArray count = %lu",(unsigned long)[[feedbackArray mutableCopy] count]);
    return [[filteredArray mutableCopy] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RunFeedbackListCell";
    RunFeedbackListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    [cell setCellData:filteredArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)pickButtonPressed:(id)sender {
    [self showPopUpWithTitle:@"Select Option" withOption:dropDownArray xy:CGPointMake(16, 50) size:CGSizeMake(287, 280) isMultiple:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    [_pickButton setTitle:dropDownArray[anIndex] forState:UIControlStateNormal];
    
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

- (void) filterListForIndex:(int)index {
    if (index == 2) {
        filteredArray = feedbackArray;
    }
    else if (index == 1) {
        filteredArray = [[NSMutableArray alloc] init];
        for (int i=0; i<feedbackArray.count; ++i) {
            NSMutableDictionary *feedbackData = feedbackArray[i];
            if ([feedbackData[@"Status"] isEqualToString:@"Closed"]) {
                [filteredArray addObject:feedbackData];
            }
        }
    }
    else {
        filteredArray = [[NSMutableArray alloc] init];
        for (int i=0; i<feedbackArray.count; ++i) {
            NSMutableDictionary *feedbackData = feedbackArray[i];
            if (![feedbackData[@"Status"] isEqualToString:@"Closed"]) {
                [filteredArray addObject:feedbackData];
            }
        }
    }
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)filteredArray.count];
    [_tableView reloadData];
}


@end
