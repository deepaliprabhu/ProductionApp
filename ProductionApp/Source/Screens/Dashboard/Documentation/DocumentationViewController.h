//
//  DocumentationViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 16/02/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentationViewController : UIViewController<UIWebViewDelegate, UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UIButton *_closeButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *pdfView;
    IBOutlet UIWebView *pdfWebView;
    
    NSMutableArray *productsArray;
}

@end
