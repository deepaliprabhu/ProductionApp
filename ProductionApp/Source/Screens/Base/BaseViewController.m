//
//  BaseViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 09/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "BaseViewController.h"
#import "VMGearLoadingView.h"
#import "Datatify.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];

    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    statusBar = [StatusBar createView];
    statusBar.frame = CGRectMake(0, screenRect.size.height-statusBar.frame.size.height, screenRect.size.width, statusBar.frame.size.height);
    [statusBar initView];
    [self.view addSubview:statusBar];
    [[Datatify sharedDatatify] initWithParent:self.view];
    
    [[Datatify sharedDatatify] setCallback:^(int net){
        NSLog(@"Call back %d",net);
    }];
    // Initialize Reachability
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reachability.reachableBlock = ^(Reachability *reachability) {
        NSLog(@"Network is reachable.");
        [statusBar setNetworkStatus:1];
    };
    
    reachability.unreachableBlock = ^(Reachability *reachability) {
        NSLog(@"Network is unreachable.");
        [statusBar setNetworkStatus:0];
    };
    
    // Start Monitoring
   // [reachability startNotifier];
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

-(void)showLoadingView
{
    [VMGearLoadingView showGearLoadingForView:self.view];
    
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:5];
}

-(void)hideLoadingView
{
    [VMGearLoadingView hideGearLoadingForView:self.view];

}

- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        [statusBar setNetworkStatus:1];
    } else {
        NSLog(@"Unreachable");
        [statusBar setNetworkStatus:0];
    }
}


- (BOOL)isNetworkReachable {
    // Initialize Reachability
    return [statusBar getNetworkStatus];
}

@end
