//
//  ProductListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 16/02/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProductListViewController.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadProductList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProductCategory:(NSString*)category {
    productCategory = category;
}

- (void)loadProductList {
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"ProductGrouping" ofType:@"plist"];
    
    NSMutableDictionary *productsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    productsArray = [productsDict[productCategory] mutableCopy];
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
    NSString *path = [[NSBundle mainBundle] pathForResource:productsArray[indexPath.row] ofType:@"xlsx"];
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

@end
