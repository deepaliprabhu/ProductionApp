//
//  ProductSelectionViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProductSelectionViewController.h"
#import "ProductSelectionViewCell.h"
#import "DailyEntryViewController.h"
#import "ProcessFlowViewController.h"
#import "UIView+RNActivityView.h"
#import "ConnectionManager.h"
#import "CommonProcessListViewController.h"

@interface ProductSelectionViewController ()

@end

@implementation ProductSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [self loadProductList];
    self.title = @"Select Product";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Process List" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonPressed)];
    productGroupArray = @[@"ARGUS", @"ICELSIUS", @"GRILLVILLE", @"ICELSIUS BLUE", @"OTHERS"];
    NSMutableArray* productGroupNameArray = @[@"Argus", @"iCelsius", @"GrillVille", @"Bluetooth", @"Others"];

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    control = [[DZNSegmentedControl alloc] initWithItems:productGroupNameArray];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.selectedSegmentIndex = 1;
    control.frame = CGRectMake(0, 70, screenRect.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self getProductList];
}

- (void)rightButtonPressed {
    CommonProcessListViewController *commonProcessListVC = [CommonProcessListViewController new];
    [self.navigationController pushViewController:commonProcessListVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTag:(int)tag_ {
    tag = tag_;
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    [self filterProductList];
}

- (void)filterProductList {
    filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < productsArray.count; ++i) {
        NSMutableDictionary *productData = productsArray[i];
        if (control.selectedSegmentIndex == 4) {
            if (![productGroupArray containsObject:productData[@"Group"]]) {
                [filteredArray addObject:productData];
            }
        }
        else if (control.selectedSegmentIndex == 3) {
            if (([productData[@"Group"] containsString:@"ICELSIUS BLUE"])||([productData[@"Name"] containsString:@"Receptor"])||([productData[@"Name"] containsString:@"Inspector"])) {
                [filteredArray addObject:productData];
            }
        }
        else {
            if ([productData[@"Group"] containsString:[productGroupArray[control.selectedSegmentIndex] uppercaseString]]) {
                [filteredArray addObject:productData];
            }
        }
    }
    NSLog(@"filteredArray=%@",filteredArray);
    [control setCount:[NSNumber numberWithInt:filteredArray.count] forSegmentAtIndex:control.selectedSegmentIndex];
    [_tableView reloadData];
}

- (void)loadProductList {
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"ProductsData" ofType:@"plist"];
    
    productsArray = [[NSMutableArray alloc] initWithContentsOfFile:path];

    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ProductSelectionViewCell";
    
    ProductSelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    [cell setCellData:filteredArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tag == 0) {
        DailyEntryViewController *dailyEntryVC = [DailyEntryViewController new];
         [dailyEntryVC setProduct:filteredArray[indexPath.row]];
         [self.navigationController pushViewController:dailyEntryVC animated:FALSE];
    }
    else {
        ProcessFlowViewController *processFlowVC = [ProcessFlowViewController new];
        [processFlowVC setSelectedProduct:filteredArray[indexPath.row]];
        [self.navigationController pushViewController:processFlowVC animated:true];
    }
}

- (void)getProductList {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Product list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:@"http://aginova.info/aginova/json/product_list.php" withTag:6];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
     productsArray = [[NSMutableArray alloc] init];
    
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
            productsArray = json;
        }
        else {
            productsArray = [[NSMutableArray alloc] init];
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
    [self filterProductList];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
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
