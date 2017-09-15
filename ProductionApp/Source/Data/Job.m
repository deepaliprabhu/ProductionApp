//
//  Job.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Job.h"
#import "DataManager.h"

@implementation Job

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setJobId:[jobId copyWithZone:zone]];
    }
    
    return copy;
}

- (void)setJobData:(NSMutableDictionary*)jobData_ {
    jobDefects = [[NSMutableArray alloc] init];
    jobData = jobData_;
    jobId = [jobData objectForKey:@"jobid"];
    jobDetails = nil;
    NSString *statusString = (NSString*)[jobData objectForKey:@"status"];
    status = 0;
   /* if (statusString != (id)[NSNull null]) {
        status = [statusString intValue];
    }*/
    startDate = @"--";
    stopDate = @"--";
    jobType = status;
    status = 0;
    processIndex = 0;
    //[self generateUniqueId];
}

- (void)setJobDetail:(NSMutableDictionary*)jobDetail {
    NSLog(@"setting job detail");
    jobDetails = jobDetail;
    if ([jobDetail objectForKey:@"starttime"] != (id)[NSNull null]) {
        startDate = [jobDetail objectForKey:@"starttime"];
    }
    if ([jobDetail objectForKey:@"starttime"] != (id)[NSNull null]) {
        stopDate = [jobDetail objectForKey:@"stoptime"];
    }
}

- (NSMutableDictionary*)getJobDetails {
    return jobDetails;
}

- (void)setBatchId:(int)batchId_ {
    batchId = batchId_;
}

- (int)getBatchId {
    return batchId;
}

- (void)generateUniqueId {
    [__DataManager getCurrentRunId];
    jobId = [NSString stringWithFormat:@"%d-%@",[__DataManager getCurrentRunId],jobId];
}

- (void)setJobId:(NSString*)jobId_ {
    jobId = jobId_;
}

- (NSString*)getJobId {
    return jobId;
}

- (int)getJobStatus {
    return status;
}

- (NSString*)getStartDate {
    return startDate;
}

- (NSString*)getStopDate {
    return stopDate;
}

- (void)setStatus:(int)status_ {
    status = status_;
    jobType = status;
}

- (void)setStartDate:(NSString*)startDate_ {
    marked = true;
    startDate = startDate_;
}

- (void)setStopDate:(NSString*)stopDate_ {
    marked = true;
    stopDate = stopDate_;
}

- (void)setJobType:(int)type {
    marked = true;
    jobType = type;
}

- (int)getJobType {
    return jobType;
}

- (void)addJobDefect:(Defect*)defect {
    NSLog(@"adding job defect");
    for (int i=0; i < [jobDefects count]; ++i) {
        Defect *defect1 = jobDefects[i];
        if ([[defect1 getDefectId] isEqualToString:[defect getDefectId]]) {
            jobDefects[i] = defect;
            return;
        }
    }
    [jobDefects addObject:defect];
}

- (NSMutableArray*)getJobDefects {
    return jobDefects;
}

- (void)setTimeLogged:(int)time {
    timeLogged = time;
}

- (int)getTimeLogged {
    return timeLogged;
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@" ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (NSMutableDictionary*)getJobData {
    NSMutableDictionary *jsonData = [NSMutableDictionary dictionaryWithObjectsAndKeys:jobId, @"jobid", [NSString stringWithFormat:@"%d",status], @"status", [self urlEncodeUsingEncoding:startDate], @"starttime", [self urlEncodeUsingEncoding:stopDate], @"stoptime", nil];
    return jsonData;
}

- (BOOL)isMarked {
    return marked;
}

- (void)setProcessIndex:(int)processIndex_ {
    processIndex = processIndex_;
}

- (int)getProcessIndex {
    return processIndex;
}

@end
