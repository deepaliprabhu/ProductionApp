//
//  OperatorLogViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperatorLogViewController.h"
#import "OperatorLogTableViewCell.h"

@interface OperatorLogViewController ()

@end

@implementation OperatorLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    operatorsArray = @[@"Arvind",@"Ram", @"Govind",@"Archana",@"Pranali",@"Sonali",@"Sumit",@"Sadashiv"];
    self.title = selectedDate;
    [self analyseData:operationsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setParseData:(NSMutableArray*)parseArray {
    operationsArray = parseArray;
}

- (void)setDateString:(NSString*)dateString {
    selectedDate = dateString;
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
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [operatorsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"OperatorLogTableViewCell";
    OperatorLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    
    [cell setCellData:operatorDataArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)analyseData:(NSMutableArray*)parseDataArray {
    operatorDataArray = [[NSMutableArray alloc] init];
    for (int i=0; i < operatorsArray.count; ++i) {
        int qty=0,operations=0,hours=0;
        for (int j=0; j < [parseDataArray count]; ++j) {
            NSMutableDictionary *parseData = parseDataArray[j];
            if ([parseData[@"Operator"] isEqualToString:operatorsArray[i]]) {
                qty = qty+[parseData[@"Quantity"] intValue];
                hours = hours+[parseData[@"Time"] intValue];
                operations = operations+1;
            }
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:operatorsArray[i],@"Operator",[NSString stringWithFormat:@"%d",qty],@"Quantity",[NSString stringWithFormat:@"%d",operations],@"Operations",[NSString stringWithFormat:@"%d",hours],@"Hours", nil];
        [operatorDataArray addObject:dict];
    }
    [_tableView reloadData];
}

@end
