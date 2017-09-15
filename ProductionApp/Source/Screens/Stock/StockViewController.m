//
//  StockViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 22/07/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "StockViewController.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"



@interface StockViewController ()

@end

@implementation StockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    stockArray = [[NSMutableArray alloc] init];
    puneStockArray = [[NSMutableArray alloc] init];
    masonStockArray = [[NSMutableArray alloc] init];
    lausanneStockArray = [[NSMutableArray alloc] init];
    filteredArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = @"In Stock";
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"Products" ofType:@"plist"];
    
    // Build the array from the plist
    productArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    locationArray = @[@"Pune",@"Mason",@"Lausanne"];
    
    control = [[DZNSegmentedControl alloc] initWithItems:locationArray];
    control.tintColor = [UIColor orangeColor];
    // control.delegate = self;
    control.frame = CGRectMake(0, 80, self.view.frame.size.width, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    [self getStock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPressed:(id)sender {
    _addProductView.hidden = false;
}

- (IBAction)cancelPressed:(id)sender {
    _addProductView.hidden = true;
}

- (IBAction)submitPressed:(id)sender {
    _addProductView.hidden = true;
    [self addProductToStock];
}

- (void) selectedListIndex:(int)index {
    dropDown = nil;
}

- (IBAction)productButtonPressed:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 195;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :productArray :nil :@"down"];
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

- (void)selectedSegment:(DZNSegmentedControl *)control {
    NSLog(@"selected segment:%d",control.selectedSegmentIndex);
    switch (control.selectedSegmentIndex) {
        case 0:
            filteredArray = puneStockArray;
            break;
        case 1:
            filteredArray = masonStockArray;
            break;
        case 2:
            filteredArray = lausanneStockArray;
            break;
        default:
            break;
    }
    [_tableView reloadData];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}
- (void)addProductToStock {
    PFQuery *query = [PFQuery queryWithClassName:@"Stock"];
    NSArray *objects = [query findObjects];
    //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    int j=0;
    NSLog(@"objects count = %lu",(unsigned long)[objects count]);
    for (j=0; j < [objects count]; ++j) {
        PFObject *parseObject = [objects objectAtIndex:j];
        if (([parseObject[@"ProductName"] isEqualToString:_productButton.titleLabel.text])&&([parseObject[@"Location"] isEqualToString:_locationButton.titleLabel.text])) {
            parseObject[@"Count"] = _countTextfield.text;
            [parseObject save];
            break;
        }
    }
    if (j == [objects count]) {
        PFObject *parseObject = [PFObject objectWithClassName:@"Stock"];
        parseObject[@"ProductName"] = _productButton.titleLabel.text;
        parseObject[@"Location"] = _locationButton.titleLabel.text;
        parseObject[@"Count"] = _countTextfield.text;
        [parseObject save];
    }
    [self getStock];
}

- (void)getStock {
    [self.navigationController.view showActivityViewWithLabel:@"fetching demands"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    puneStockArray = [[NSMutableArray alloc] init];
    masonStockArray = [[NSMutableArray alloc] init];
    lausanneStockArray = [[NSMutableArray alloc] init];
    filteredArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Stock"];
    NSArray *objects = [query findObjects];
    //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    int j=0;
    NSLog(@"objects count = %lu",(unsigned long)[objects count]);
    for (j=0; j < [objects count]; ++j) {
        PFObject *parseObj = [objects objectAtIndex:j];
        if ([parseObj[@"Location"] isEqualToString:@"Pune"]) {
            [puneStockArray addObject:parseObj];
        }
        else if ([parseObj[@"Location"] isEqualToString:@"Mason"]) {
            [masonStockArray addObject:parseObj];
        }
        else {
            [lausanneStockArray addObject:parseObj];
        }
    }
    filteredArray = puneStockArray;
    [self.navigationController.view hideActivityView];
    [control setCount:[NSNumber numberWithInt:puneStockArray.count] forSegmentAtIndex:0];
    [control setCount:[NSNumber numberWithInt:masonStockArray.count] forSegmentAtIndex:1];
    [control setCount:[NSNumber numberWithInt:lausanneStockArray.count] forSegmentAtIndex:2];
    [_tableView reloadData];
}

- (void)filterStockArray {
    for (int i=0; i < stockArray; ++i) {
        PFObject *parseObj = stockArray[i];
        if ([parseObj[@"Location"] isEqualToString:@"Pune"]) {
            [puneStockArray addObject:parseObj];
        }
        else if ([parseObj[@"Location"] isEqualToString:@"Mason"]) {
            [masonStockArray addObject:parseObj];
        }
        else {
            [lausanneStockArray addObject:parseObj];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DailyStatsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject *run = [filteredArray objectAtIndex:indexPath.row];
    cell.textLabel.text = run[@"ProductName"];
    cell.detailTextLabel.text = run[@"Count"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _addProductView.hidden = false;
    PFObject *run = [filteredArray objectAtIndex:indexPath.row];
    [_productButton setTitle:run[@"ProductName"] forState:UIControlStateNormal];
    _countTextfield.text = run[@"Count"];
    [_locationButton setTitle:run[@"Location"] forState:UIControlStateNormal];
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
