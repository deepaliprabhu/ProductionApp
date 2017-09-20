//
//  ServerManager.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "ServerManager.h"
#import "DataManager.h"
#import "Utilities.h"
#import <UIKit/UIKit.h>

static ServerManager *_sharedInstance = nil;

@implementation ServerManager

+ (id) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [self new];
        [_sharedInstance initData];
        
    });
    
    return _sharedInstance;
}

- (void)initData {
    
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (void)loginUser {
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:@"http://aginova.info/aginova/json/action.php?call=user_list"];
}

- (void)getRunsList {
    //get stored runs in Realm

    /*RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    RLMResults *results = [Data allObjectsInRealm:realm];
    NSLog(@"results run count = %lu",(unsigned long)results.count);
    if (results.count&&![Utilities isNetworkReachable]) {
        Data *data = [results objectAtIndex:0];
        Run *run = data.runs[0];
        NSLog(@"runs = %@",[run getProductName]);
        [__DataManager setRunsList:data.runs];
    }
    else {*/
        connectionManager = [ConnectionManager new];
        connectionManager.delegate = self;
        [connectionManager makeRequest:@"http://www.aginova.info/aginova/json/run_list.php"];
   // }
}

- (void)setJobDetailsWithJsonString:(NSString*)jsonString {
   /* NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://aginova.info/aginova/json/action.php?call=setJobDetails"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *stringData = [self urlEncodeUsingEncoding:jsonString];
    //stringData = [self urlEncodeUsingEncoding:stringData];
    NSData *postData = [stringData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    request.HTTPBody = postData;
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makePostRequest:request];*/
    NSString *urlString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?call=set_job_details&do=update%@",[self urlEncodeUsingEncoding:jsonString]];
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:urlString];
}

- (void)updateRun:(int)runId withJsonString:(NSString*)jsonString {
    NSString *urlString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?call=update_runs&id=%d&do=update%@",runId,[self urlEncodeUsingEncoding:jsonString]];
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:urlString];
}

- (void)updateRunProcesses:(int)runId withJsonString:(NSString*)jsonString {
    NSString *urlString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?call=set_process_details&id=%d&do=update%@",runId,[self urlEncodeUsingEncoding:jsonString]];
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:urlString];
}

- (void)updateCommonProcessesWithJsonString:(NSString*)jsonString {
    NSString *urlString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=updateProcessList&do=update%@",[self urlEncodeUsingEncoding:jsonString]];
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:urlString];
}

- (void)updateProcessFlowWithJsonString:(NSString*)jsonString {
    NSString *urlString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=updateProcessFlow&do=add%@",[self urlEncodeUsingEncoding:jsonString]];
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:urlString];
}


- (void)getJobsListForRunId:(int)runId {
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:@"http://aginova.info/aginova/json/action.php?call=get_jobs&id=246" withTag:1];
}

- (void)getJobsListTest {
    [__DataManager setCurrentRunId:246];
    NSError* error;
    NSString *dataString = @"[{\"jobID\":\"JN1\",\"status\":2},{\"jobID\":\"JN2\",\"status\":2},{\"jobID\":\"JN3\",\"status\":2},{\"jobID\":\"JN4\",\"status\":2},{\"jobID\":\"JN5\",\"status\":2},{\"jobID\":\"JN6\",\"status\":1},{\"jobID\":\"JN7\",\"status\":1},{\"jobID\":\"JN8\",\"status\":1},{\"jobID\":\"JN9\",\"status\":1},{\"jobID\":\"JN10\",\"status\":1},{\"jobID\":\"JN11\",\"status\":0},{\"jobID\":\"JN12\",\"status\":0},{\"jobID\":\"JN13\",\"status\":0},{\"jobID\":\"JN14\",\"status\":0},{\"jobID\":\"JN15\",\"status\":0}]";
    
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json is Array class");
        [__DataManager setJobsList:json forRunId:246];
    }
}

- (void)getJobsDetailsForJobId:(NSString*)jobId {
    connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *urlString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?call=get_job_detail&jobid=%@",jobId];
    [connectionManager makeRequest:urlString withTag:2];
}

- (void)getProcessListForRunId:(int)runId {
    // Path to the plist (in the application bundle)
    Run*run = [__DataManager getRunWithId:runId];
    NSString *productNumber = [run getProductNumber];
    NSString *path;
    if ([productNumber isEqualToString:@"IPROBE-4000-0009"]) {
        path = [[NSBundle mainBundle] pathForResource:
                          @"DualBBQ_Processes" ofType:@"plist"];
    }
    else if ([productNumber isEqualToString:@"ICBLUE-2000-0001"]) {
        path = [[NSBundle mainBundle] pathForResource:
                @"iCBlueRH_Processes" ofType:@"plist"];
    }
    else
        path = [[NSBundle mainBundle] pathForResource:
                      @"SentinelNext_Processes" ofType:@"plist"];
    
    // Build the array from the plist
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSMutableArray *processArray = [[NSMutableArray alloc] init];
    for (int i=0; i < [array count]; ++i) {
        Process *process = [[Process alloc] init];
        [process setProcessData:[array objectAtIndex:i]];
        [process setProcessJobs:[[NSMutableArray alloc] initWithArray:[__DataManager getJobsForRunId:runId] copyItems:YES]];
        [processArray addObject:process];
    }
    [__DataManager setProcessList:processArray forRunId:runId];
   // [__ServerManager getChecklistList];
}


- (void)getWorkInstructionsList {
    NSLog(@"fetching work instructions");
    NSError* error;
    NSString *dataString = @"[{\"id\":\"1\",\"description\":\"Take the separated PCB from Panel\"},{\"id\":\"2\",\"description\":\"Solder Power connector at p1 battery connector pin.\"},{\"id\":\"3\",\"description\":\"Solder daughterboard connector at j3 pin and cut the extra stands of connectors to up to 2mm below PCB.\"},{\"id\":\"4\",\"description\":\"Check each solder joint for dry solder, shorts and fix it.\"},{\"id\":\"5\",\"description\":\"Check all component pin alignments and correct any bent pins.\"},{\"id\":\"6\",\"description\":\"Clean board and PCB to remove flux.\"}]";
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json is Array class");
        [__DataManager setWorkInstructions:json forProcessId:@"PN1"];
    }
}

- (void)getChecklistList {
    NSLog(@"fetching work instructions");
    NSError* error;
    NSString *dataString = @"[{\"id\":\"1\",\"description\":\"All pins are straight aligned\"},{\"id\":\"2\",\"description\":\"No dry solder\"},{\"id\":\"3\",\"description\":\"PCB Cleaned\"},{\"id\":\"4\",\"description\":\"No shorts presents\"},{\"id\":\"5\",\"description\":\"Connector joints cut\"}]";
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json is Array class");
        [__DataManager setChecklistArray:json];
    }
}

- (void)getDefects {
    NSLog(@"fetching work instructions");
    NSError* error;
    NSString *dataString = @"[{\"id\":\"0\",\"operator\":\"Arvind\",\"time\":\"09/03/2015 12:55PM\",\"text\":\"Red LED not working\",\"detailtext\":\"Red LED not lighting when sensor is connected to USB Charger\",\"type\":\"0\"},{\"id\":\"1\",\"operator\":\"Govind\",\"time\":\"09/03/2015 12:55PM\",\"text\":\"Green LED not visible\",\"detailtext\":\"Green LED light is dim from within the Top button\",\"type\":\"1\"},{\"id\":\"2\",\"operator\":\"Ram\",\"time\":\"09/03/2015 12:55PM\",\"text\":\"Scratches in Mould\",\"detailtext\":\"Scratches in Mould\",\"type\":\"2\"}]";
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json is Array class");
        [__DataManager setDefectsList:json forRunId:[__DataManager getCurrentRunId]];
    }
}

- (void)getPartsShort {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:@"http://www.aginova.info/aginova/json/run_list.php" withTag:3];
}

- (void)getRMAs {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://aginova.info/aginova/json/rma_list.php";
    [connectionManager makeRequest:reqString withTag:6];
}

- (void)getFeedbacks {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://aginova.info/aginova/json/feedback_list.php";
    [connectionManager makeRequest:reqString withTag:8];
}

- (void)getDemands {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = @"http://www.aginova.info/aginova/json/demands.php";
    [connectionManager makeRequest:reqString withTag:5];
}

- (void)getPartsTransfer {
    int numberOfDays=60;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSString *startDateString = [dateFormat stringFromDate:startDate];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:startDateString];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:-i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startDate options:0];
        NSString *nextDayString = [dateFormat stringFromDate:nextDay];
        [dates addObject:nextDayString];
    }
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/transfer_parts.php/?location=1&date1=%@&date2=%@",[dates lastObject],dates[0]];
    [connectionManager makeRequest:reqString withTag:7];
}

- (void)getProcessList {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:@"http://aginova.info/aginova/json/processes.php?call=getProcessList" withTag:9];
}

- (void) displayErrorWithMessage:(NSString*)errorMessage {
    
}

- (void) parseJsonResponse:(NSData*)jsonData {
    NSError* error;
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
    }
    
    if ([json isKindOfClass:[NSArray class]]){ 
        // [self displaySuccess];
        
        NSLog(@"json is Array class");
            /*for (NSDictionary *dictionary in json) {
                int val =[[dictionary objectForKey:@"PRODUCTION_ID"] intValue];
                NSLog(@"production id = %d",val);

            }*/
            [__DataManager setRunsList:json];
    }
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    NSError* error;
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    if ([dataString isEqualToString:@"<pre>1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        //[alertView show];
        if ([_delegate respondsToSelector:@selector(receivedSuccessResponse)]) {
            [_delegate receivedSuccessResponse];
        }
        return;
    }
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"ryanbigger@yahoo.com	" withString:@"ryanbigger@yahoo.com"];

    [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"[\r\n]"
                                                         withString:@""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, dataString.length)];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    dataString = [dataString stringByReplacingOccurrencesOfString:@"etnchunter@gmail.com " withString:@"etnchunter@gmail.com"];


    //dataString = [dataString stringByReplacingOccurrencesOfString:@"\\" withString:@"s"];


    dataString = [dataString stringByReplacingOccurrencesOfString:@"\"orange peel\"" withString:@"s"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"	" withString:@""];

    if (tag == 6) {
        NSLog(@"rma data string = %@",dataString);
    }

    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        //[self displayError];
        if ([_delegate respondsToSelector:@selector(receivedErrorResponse)]) {
            [_delegate receivedErrorResponse];
        }
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        // [self displaySuccess];
        
        NSLog(@"json is Array class");
        /*for (NSDictionary *dictionary in json) {
         int val =[[dictionary objectForKey:@"PRODUCTION_ID"] intValue];
         NSLog(@"production id = %d",val);
         
         }*/

        switch (tag) {
            case 0: {
                //[[NSFileManager defaultManager] removeItemAtPath:[RLMRealmConfiguration defaultConfiguration].path error:nil];
               // RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
                
                //RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:nil]; // Create realm pointing to default file
               // Data *realmData = [[Data alloc] init];
                NSMutableArray *runsArray = [[NSMutableArray alloc] init];
                for (int i=0; i < [json count]; ++i) {
                    Run *run = [[Run alloc] init];
                    run.productName = @"test name";
                    [run setRunData:[json objectAtIndex:i]];
                    [runsArray addObject:run];
                    
                    // Save your object
                   /* [realm beginWriteTransaction];
                    [realm addObject:run];
                    [realm commitWriteTransaction];
                    [realmData.runs addObject:run];*/
                }
                
                //[realm beginWriteTransaction];
                //[realm addObject:realmData];
                //[realm commitWriteTransaction];
                [__DataManager setRunsList:runsArray];
                //[self getPartsShort];
            }
                break;
            case 1:
                [__DataManager setJobsList:json forRunId:246];
                //[_delegate receivedServerResponse];
                break;
            case 2: {
                NSMutableDictionary *jobDetail = json[0];
                NSLog(@"jobdetail = %@",jobDetail);
                NSString *jobId = [jobDetail objectForKey:@"jobid"];
                [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] setJobDetail:json[0] ForJobId:jobId];
                [_delegate receivedServerResponse];
            }
                break;
            case 5: {
                [__DataManager setDemandList:json];
            }
                break;
            case 6: {
                [__DataManager setRMAList:json];
            }
                break;
            case 7: {
                [__DataManager setPartsTransferList:json];
            }
                break;
            case 8: {
                [__DataManager setFeedbackList:json];
            }
                break;
            case 9: {
                [__DataManager setCommonProcesses:[json mutableCopy]];
            }
                break;
            default:
                break;
        }
    }
}


@end
