//
//  ProductListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 16/02/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *pdfView;
    IBOutlet UIWebView *pdfWebView;
    NSString *productCategory;
    IBOutlet UIButton *_closeButton;

    
    NSMutableArray *productsArray;
}
- (void)setProductCategory:(NSString*)category;
@end
