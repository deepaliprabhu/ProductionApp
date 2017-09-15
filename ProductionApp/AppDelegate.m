//
//  AppDelegate.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 17/06/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DSNavigationBar.h"
#import <Instabug/Instabug.h>
#import "Crittercism.h"
#import "DataManager.h"
#import "Data.h"
#import <Parse/Parse.h>
#import "Utilities.h"
#import "DashboardViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Instabug startWithToken:@"1b02636c8e5ac645dcd0bf45d10c888d" invocationEvent:IBGInvocationEventShake];
    [Crittercism enableWithAppID:@"55ed5174d224ac0a00ed3c47"];
    
    [self setupParse];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    DashboardViewController *dashboardVC = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[DSNavigationBar class] toolbarClass:nil];
    
    UIColor * color = [UIColor colorWithRed:(190/255.0) green:(218/255.0) blue:(218/255) alpha:0.5f];
    [[DSNavigationBar appearance] setNavigationBarWithColor:color];
    
    UIColor *topColor = [UIColor colorWithRed:(190/255.0) green:(218/255.0) blue:(218/255) alpha:1.0f];
    UIColor *bottomColor = [UIColor colorWithRed:(190/255.0) green:(218/255.0) blue:(218/255) alpha:0];
    [[DSNavigationBar appearance] setNavigationBarWithColors:@[[UIColor clearColor],[UIColor clearColor]]];
    [navigationController setViewControllers:@[dashboardVC]];

    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupParse {
    if (![Utilities isNetworkReachable]) {
        // [Parse enableLocalDatastore];
    }

    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"8bt2VSdezwVq4A2VOg86OJDGk51yMSJxapnK2XoR";
        configuration.clientKey = @"6HVTHAoTThUC9uM9UIPBorcxsOyDue3v6t4GRLtK";
        configuration.server = @"https://parseapi.back4app.com/";
    }]];
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicWriteAccess:YES];
    [defaultACL setPublicReadAccess:YES];

    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"called application will terminate");
    /*[[NSFileManager defaultManager] removeItemAtPath:[RLMRealmConfiguration defaultConfiguration].path error:nil];
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    NSMutableArray *runsArray = [__DataManager getRuns];
    Data *realmData = [[Data alloc] init];
    
    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = runsArray[i];

        [realmData.runs addObject:run];
    }
    
    [realm beginWriteTransaction];
    [realm addObject:realmData];
    [realm commitWriteTransaction];
    
    // Query
    NSLog(@"Realm path = %@",[RLMRealmConfiguration defaultConfiguration].path);
    RLMResults *results = [Run allObjectsInRealm:realm];
   // RLMResults *results2 = [results objectsWhere:@"runId == 246"];
    //Run *run = [results2 objectAtIndex:0];
    // Queries are chainable!
    //Process *process = [run.processes objectAtIndex:0];
   // NSLog(@"Number of jobs: %li", (unsigned long)run.jobs.count);
    //NSLog(@"run id =: %d", run.runId);
  // NSLog(@"run processes =: %d", [run.processes count]);
    NSLog(@"results run count = %lu",(unsigned long)results.count);
    NSLog(@"saving runs");*/
}

@end
