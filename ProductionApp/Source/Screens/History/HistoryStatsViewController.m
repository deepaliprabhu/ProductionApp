//
//  HistoryStatsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "HistoryStatsViewController.h"
#import "UIView+RNActivityView.h"
#import "ConnectionManager.h"
#import "HistoryStatsViewCell.h"


@interface HistoryStatsViewController ()

@end

@implementation HistoryStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    productsArray = @[@"Argus", @"iCelsius", @"GrillVille", @"Receptor"];
    monthArray = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    control = [[DZNSegmentedControl alloc] initWithItems:productsArray];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.selectedSegmentIndex = 1;
    control.frame = CGRectMake(0, 70, screenRect.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    self.scrollView.values = @[ @"2015", @"2016", @"2017", @"2018", @"2019", @"2020"];
    self.scrollView.delegate = self;
    self.scrollView.updateIndexWhileScrolling = NO;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int month = [[dateFormat stringFromDate:[NSDate date]] intValue];
    //[self.scrollView setSelectedIndex:month-1];
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

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    switch (control.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1: {

        }
            break;
        case 2: {

        }
            break;
        default:
            break;
    }
        [self getStatsForProduct:productsArray[control.selectedSegmentIndex] year:[[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex] intValue]];
}

- (void)scrollView:(MVSelectorScrollView *)scrollView pageSelected:(NSInteger)pageSelected {
    
    //NSLog(@"%s scroll view %d, selected page: %d", __func__, scrollView.tag, pageSelected);
    [self getStatsForProduct:productsArray[control.selectedSegmentIndex] year:[[self.scrollView.values objectAtIndex:self.scrollView.selectedIndex] intValue]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"HistoryStatsViewCell";
    HistoryStatsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    // cell.delegate = self;
    [cell setCellData:[statsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getStatsForProduct:(NSString*)type year:(int)year {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/produced_vs_shipped.php?type=%@&year=%d",type,year];
    [connectionManager makeRequest:reqString withTag:6];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    statsArray = [[NSMutableArray alloc] init];
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        [_tableView reloadData];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            producedDict = json[0];
            shippedDict = json[1];
            for (int i=0; i < monthArray.count; ++i) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:monthArray[i] forKey:@"Month"];
                [dict setObject:[producedDict objectForKey:monthArray[i]] forKey:@"Produced"];
                [dict setObject:[shippedDict objectForKey:monthArray[i]] forKey:@"Shipped"];
                [statsArray addObject:dict];
            }
            [_tableView reloadData];
            [self initialiseCounts];
        }
        else {
            statsArray = [[NSMutableArray alloc] init];
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)initialiseCounts {
    int shippedCount = 0;
    int producedCount = 0;
    for (int i=0; i < statsArray.count; ++i) {
        NSMutableDictionary *dict = statsArray[i];
        producedCount = producedCount+[dict[@"Produced"] intValue];
        shippedCount = shippedCount+[dict[@"Shipped"] intValue];
    }
    [control setCount:[NSNumber numberWithInt:shippedCount] forSegmentAtIndex:control.selectedSegmentIndex];
    _producedLabel.text = [NSString stringWithFormat:@"%d",producedCount];
    _shippedLabel.text = [NSString stringWithFormat:@"%d",shippedCount];
}



@end
