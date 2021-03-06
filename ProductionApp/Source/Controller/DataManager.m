//
//  DataManager.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "DataManager.h"
#import "Constants.h"
#import "Defines.h"
#import "ServerManager.h"
#import "ConnectionManager.h"
#import "Data.h"
//#import <Realm/Realm.h>

static DataManager *_sharedInstance = nil;

@implementation DataManager
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
    runsArray = [[NSMutableArray alloc] init];
    processArray = [[NSMutableArray alloc] init];
    editedProcessesArray = [[NSMutableArray alloc] init];
}

- (void)setCurrentRunId:(int)runId {
    currentRunId = runId;
}

- (void)setCurrentJobId:(NSString*)jobId {
    currentJobId = jobId;
}

- (void)setCurrentProcessId:(NSString*)processId {
    currentProcessId = processId;
}

- (void)setCurrentJob:(Job*)job {
    currentJob = job;
}

- (Job*)getCurrentJob {
    return currentJob;
}

- (int)getCurrentRunId {
    return currentRunId;
}

- (NSString*)getCurrentJobId {
    return currentJobId;
}

- (NSString*)getCurrentProcessId {
    return currentProcessId;
}

- (void)setRunsList:(NSMutableArray*)runsArray_ {
    runsArray = runsArray_;
    __notifyObj(kNotificationRunsReceived, nil);
}

- (void)setJobsList:(NSMutableArray*)jobsArray forRunId:(int)runId {
    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = [runsArray objectAtIndex:i];
        if ([run getRunId]==runId) {
            currentRunId = runId;
            [run setRunJobs:jobsArray];
            
            break;
        }
    }
}

- (void)setDefectsList:(NSMutableArray*)defectsArray forRunId:(int)runId {
    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = [runsArray objectAtIndex:i];
        if ([run getRunId]==runId) {
            currentRunId = runId;
            [run setRunDefects:defectsArray];
            break;
        }
    }
}

- (void)setProcessList:(NSMutableArray*)processesArray forRunId:(int)runId {
    NSLog(@"setting run processes = %@",processesArray);

    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = [runsArray objectAtIndex:i];
        if ([run getRunId]==runId) {
            [run setRunProcesses:processesArray];
            break;
        }
    }
}

- (void)setProcessList:(NSMutableArray*)processArray_ {
    processArray = [[NSMutableArray alloc] init];
    for (int i=0; i < [processArray_ count]; ++i) {
        Process *process = [[Process alloc] init];
        Run *run = [self getRunWithId:currentRunId];
        [process setProcessData:[processArray_ objectAtIndex:i]];
        [process setProcessJobs:[[run getRunJobs] mutableCopy]];
        [processArray addObject:process];
    }
}

- (void)setWorkInstructions:(NSMutableArray*)instructions forProcessId:(NSString*)processId{

    for (int i=0; i < [processArray count]; ++i) {
        Process *process = processArray[i];
        if ([[process getProcessId]  isEqualToString: @"PN1"]) {
            [process setWorkInstructions:instructions];
            NSLog(@"setting work instruction text:%@",instructions);
            break;
        }
    }
}

- (void)setChecklistArray:(NSMutableArray*)checklist {
    for (int i=0; i < [processArray count]; ++i) {
        Process *process = processArray[i];
        //if ([[process getProcessId]  isEqualToString: @"PN1"]) {
            NSLog(@"setting work checklist text:%@",checklist);
            [process setChecklist:checklist];
         //   break;
       // }
    }
}

- (Run*)getRunWithId:(int)runId {
    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = [runsArray objectAtIndex:i];
        if ([run getRunId]==runId) {
            return run;
            break;
        }
    }
    return nil;
}

- (NSMutableArray*)getRunsWithProductId:(NSString*)productId {
    NSLog(@"Product id = %@",productId);
    NSMutableArray *runsArray_ = [[NSMutableArray alloc] init];
    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = [runsArray objectAtIndex:i];
        if ([[run getProductNumber] isEqualToString:productId]) {
            [runsArray_ addObject:run];
        }
    }
    return runsArray_;
}

- (NSMutableArray*)getRuns {
    return runsArray;
}

- (NSMutableArray*)getInProgressRuns {
    NSMutableArray *inProgressRuns = [[NSMutableArray alloc] init];
    for (int i=0; i < runsArray.count; ++i) {
        Run *run = runsArray[i];
        if ([[run getStatus] isEqualToString:@"IN PROGRESS"]) {
            [inProgressRuns addObject:run];
        }
    }
    return inProgressRuns;
}

- (NSMutableArray*)getJobsForRunId:(int)runId {
    for (int i=0; i < [runsArray count]; ++i) {
        Run *run = [runsArray objectAtIndex:i];
        if ([run getRunId]==runId) {
            return [run getRunJobs];
            break;
        }
    }
    return nil;
}

- (NSMutableArray*)getProcesses {
    return processArray;
}

- (NSMutableArray*)getWorkInstructionsForProcessId:(NSString*)processId {
    for (int i=0; i < [processArray count]; ++i) {
        Process *process = processArray[i];
        if ([[process getProcessId]  isEqualToString: @"PN1"]) {
            return [process getWorkInstructions];
        }
    }
    return nil;
}

- (NSMutableArray*)getChecklistArray {
    for (int i=0; i < [processArray count]; ++i) {
        Process *process = processArray[i];
        if ([[process getProcessId]  isEqualToString: @"PN1"]) {
            return [process getChecklist];
        }
    }
    return nil;
}

- (void)syncDatabase {
    //loop through runs in DB and update Jobs
    Run *run = [self getRunWithId:246];
    int count = 0;
    NSString *jsonString = @"[";
    for (int i=0; i < [[run getRunJobs] count]; ++i) {
        Job *job = [[run getRunJobs] objectAtIndex:i];
        if ([job isMarked]) {
            if (count != 0) {
                jsonString = [NSString stringWithFormat:@"%@,",jsonString];
            }
            jsonString = [jsonString stringByAppendingString:[self jsonString:[job getJobData] WithPrettyPrint:false]];

            count++;
        }
    }
    
    if (count > 0) {
        jsonString = [NSString stringWithFormat:@"&count=%d&json=%@]",count,jsonString];
        [__ServerManager setJobDetailsWithJsonString:jsonString];
    }
    NSLog(@"json string = %@",jsonString);
}

- (void)syncRuns {
    //loop through runs in DB and update Jobs
    int count = 0;
    NSString *jsonString = @"[";
    for (int i=0; i < [[self getRuns] count]; ++i) {
        Run *run = [[self getRuns] objectAtIndex:i];
            if (count != 0) {
                jsonString = [NSString stringWithFormat:@"%@,",jsonString];
            }
            jsonString = [jsonString stringByAppendingString:[self jsonString:[run getRunData] WithPrettyPrint:false]];
            count++;
    }
    
    if (count > 0) {
        jsonString = [NSString stringWithFormat:@"&count=%d&json=%@]",count,jsonString];
        [__ServerManager updateRunsWithJsonString:jsonString];
    }
    NSLog(@"json string = %@",jsonString);
}

- (void)syncRun:(int)runId {
    //loop through runs in DB and update Jobs
    int count = 0;
    NSString *jsonString = @"[";
    Run *run = [self getRunWithId:runId];
    //for (int i=0; i < [[self getRuns] count]; ++i) {
     //   Run *run = [[self getRuns] objectAtIndex:i];
        jsonString = [jsonString stringByAppendingString:[self jsonString:[run getRunData] WithPrettyPrint:false]];
        count++;
    //}
    
    if (count > 0) {
        jsonString = [NSString stringWithFormat:@"&count=%d&json=%@]",count,jsonString];
        [__ServerManager setDelegate:self];
        [__ServerManager updateRun:runId withJsonString:jsonString];
    }
    NSLog(@"json string = %@",jsonString);
}

- (void)syncRunProcesses:(int)runId {
    int count = 0;
    NSString *jsonString = @"[";
    Run *run = [self getRunWithId:runId];
    NSMutableArray *runProcessesArray = [run getRunProcesses];
    NSMutableDictionary *runProcessesDict = [[NSMutableDictionary alloc] init];
    for (int i=0; i < [runProcessesArray count]; ++i) {
       NSMutableDictionary *dict = [runProcessesArray objectAtIndex:i];
        [runProcessesDict setObject:dict[@"Count"] forKey:dict[@"ProcessName"]];
    }
    jsonString = [jsonString stringByAppendingString:[self jsonString:runProcessesDict WithPrettyPrint:false]];
    count++;

    if (count > 0) {
        jsonString = [NSString stringWithFormat:@"&count=%d&json=%@]",count,jsonString];
        [__ServerManager updateRunProcesses:runId withJsonString:jsonString];
    }
    NSLog(@"json string = %@",jsonString);
}

- (void)syncCommonProcesses {
    int count = 0;
    NSString *jsonString = @"";
    jsonString = [jsonString stringByAppendingString:[self jsonString:editedProcessesArray WithPrettyPrint:false]];
    count++;
    
    if (count > 0) {
        jsonString = [NSString stringWithFormat:@"&count=%lu&json=%@",(unsigned long)editedProcessesArray.count,jsonString];
        [__ServerManager setDelegate:self];
        [__ServerManager updateCommonProcessesWithJsonString:jsonString];
    }
    NSLog(@"json string = %@",jsonString);
}

- (void)syncProcesses:(NSMutableArray*)processesArray withProcessData:(NSMutableDictionary*)processData {
    int count = 0;
    NSString *jsonString = @"";
    jsonString = [jsonString stringByAppendingString:[self jsonString:processesArray WithPrettyPrint:false]];
    count++;
    
    if (count > 0) {
        jsonString = [NSString stringWithFormat:@"&process_ctrl_id=%@&process_ctrl_name=%@&originator=%@&approver=%@&comments=%@&timestamp=%@&description=%@&productid=%@&versionid=%@&status=%@&count=%lu&json=%@",processData[@"process_ctrl_id"], processData[@"process_ctrl_name"], processData[@"Originator"], processData[@"Approver"],processData[@"Comments"], processData[@"Timestamp"], processData[@"Description"],processData[@"ProductId"],processData[@"VersionId"],processData[@"Status"],(unsigned long)processesArray.count,jsonString];
        [__ServerManager setDelegate:self];
        [__ServerManager updateProcessFlowWithJsonString:jsonString];
    }
    NSLog(@"json string = %@",jsonString);
}


-(NSString*) jsonString:(NSDictionary*)data WithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

- (void)saveParseRuns:(NSMutableArray*)parseRuns_ {
    parseRuns = parseRuns_;
}

- (NSMutableArray*)getParseRuns {
    return parseRuns;
}

- (NSMutableDictionary*)getParseRunForId:(int)runId {
    for (int i=0; i < parseRuns.count; ++i) {
        NSMutableDictionary *parseObj = (NSMutableDictionary*)parseRuns[i];
        if ([parseObj[@"RunId"] intValue] == runId) {
            return parseObj;
        }
    }
    return nil;
}

- (void)setRMAList:(NSMutableArray*)rmaArray_ {
    rmaArray = rmaArray_;
    __notifyObj(kNotificationRmasReceived, nil);

}

- (NSMutableArray*)getRMAList {
    return rmaArray;
}

- (void)setDemandList:(NSMutableArray*)demandsArray_ {
    demandsArray = demandsArray_;
    __notifyObj(kNotificationDemandsReceived, nil);
}

- (NSMutableArray*)getDemandList {
    return demandsArray;
}

- (void)setPartsTransferList:(NSMutableArray*)partsTransferArray_ {
    partsTransferArray = partsTransferArray_;
}

- (NSMutableArray*)getPartsTransferList {
    return partsTransferArray;
}

- (NSMutableArray*)getFeedbackList {
    return  feedbacksArray;
}

- (void)setFeedbackList:(NSMutableArray*)feedbacksArray_ {
    feedbacksArray = feedbacksArray_;
    for (int i=0; i<feedbacksArray.count; ++i) {
        NSMutableDictionary *feedbackData = feedbacksArray[i];
        NSString* productId = feedbackData[@"Product Id"];
        NSMutableArray* runsArray_ = [self getRunsWithProductId:productId];
        //NSLog(@"runsarray recvd=%@",runsArray_);
        for (int j=0; j < runsArray_.count; ++j) {
            Run *run = runsArray_[j];
            [run addRunFeedback:feedbackData];
        }
    }
    __notifyObj(kNotificationFeedbacksReceived, nil);
}

- (void)receivedSuccessResponse {
    NSLog(@"inside receivedSuccessResponse");
    [_delegate receivedSuccessResponse];
}

- (void)receivedErrorResponse {
    [_delegate receivedErrorResponse];
}

- (void)setTaskList:(NSMutableArray*)taskArray_ {
    tasksArray = taskArray_;
}

- (NSMutableArray*)getTaskList {
    return tasksArray;
}

- (void)setThisWeekRuns:(NSMutableArray*)thisWeekRuns {
    thisWeekRunsArray = thisWeekRuns;
}

- (NSMutableArray*)getThisWeekRuns {
    return thisWeekRunsArray;
}

- (void)setNextWeekRuns:(NSMutableArray*)nextWeekRuns {
    nextWeekRunsArray = nextWeekRuns;
}

- (NSMutableArray*)getNextWeekRuns {
    return nextWeekRunsArray;
}

- (void)setThisWeekOperations:(NSMutableArray*)thisWeekOperations {
    thisWeekOperationsArray = thisWeekOperations;
}

- (NSMutableArray*)getThisWeekOperations {
    return thisWeekOperationsArray;
}

- (void)setCommonProcesses:(NSMutableArray*)commonProcessesArray_ {
    editedProcessesArray = [[NSMutableArray alloc] init];
    commonProcessesArray = commonProcessesArray_;
    __notifyObj(kNotificationCommonProcessesReceived, nil);
}

- (NSMutableArray*)getCommonProcesses {
    return commonProcessesArray;
}

- (void)updateProcessAtIndex:(int)index process:(NSMutableDictionary*)processData {
    [commonProcessesArray replaceObjectAtIndex:index withObject:processData];
    [editedProcessesArray addObject:processData];
}

@end
