//
//  OperationsLogViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperationsLogViewController.h"
#import "OperationsLogTableViewCell.h"


@interface OperationsLogViewController ()

@end

@implementation OperationsLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [operationDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"OperationsLogTableViewCell";
    OperationsLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    
    [cell setCellData:operationDataArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)analyseData:(NSMutableArray*)parseDataArray {
   operationDataArray = [[NSMutableArray alloc] init];
    for (int j=0; j < [parseDataArray count]; ++j) {
        NSMutableDictionary *parseData = parseDataArray[j];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:parseData[@"ProcessName"],@"Operation",parseData[@"Quantity"],@"Quantity",parseData[@"Operator"],@"Operator",parseData[@"Time"],@"Hours", nil];
        [operationDataArray addObject:dict];
    }
    [_tableView reloadData];
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
