//
//  DocumentationViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 16/02/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "DocumentationViewController.h"
#import "ProductListViewController.h"

@interface DocumentationViewController ()

@end

@implementation DocumentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    productsArray = [NSMutableArray arrayWithObjects:@"Wireless", @"Wired ",@"Bluetooth", @"Corrosion", @"Others",nil];
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

- (IBAction)productGroupingPressed:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProductGrouping" ofType:@"xlsx"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    pdfView.hidden = false;
    [pdfWebView loadRequest:request];
    [self.view bringSubviewToFront:pdfView];
    [self.view bringSubviewToFront:_closeButton];
}

- (IBAction)closeButtonPressed:(id)sender {
    pdfView.hidden = true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = productsArray[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListViewController *productListVC = [ProductListViewController new];
    [productListVC setProductCategory:productsArray[indexPath.row]];
    [self.navigationController pushViewController:productListVC animated:NO];
}

@end