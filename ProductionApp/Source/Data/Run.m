//
//  Run.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Run.h"
#import "Job.h"
#import "Defect.h"

@implementation Run {

}

- (void)setRunData:(NSDictionary*)runData_ {
    runData = [runData_ mutableCopy];
    _runId = [[runData objectForKey:@"Run"] intValue];
    _sequence = [[runData objectForKey:@"Sequence"] intValue];
    _quantity = [[runData objectForKey:@"Qty"] intValue];
    _requestDate = [runData objectForKey:@"REQUESTDATE"];
    _runDate = [runData objectForKey:@"Updated"];
    _vendorName = [runData objectForKey:@"VENDOR_ID"];
    _inProcess = [[runData objectForKey:@"Inprocess"] intValue];
    _ready = [[runData objectForKey:@"Ready"] intValue];
    _shipped = [[runData objectForKey:@"Shipped"] intValue];
    _rework = [[runData objectForKey:@"Rework"] intValue];
    _reject = [[runData objectForKey:@"Reject"] intValue];
    _status = [runData objectForKey:@"Status"];
    _productId = [[runData objectForKey:@"PRODUCT_REV_ID"] intValue];
    runJobs = [[NSMutableArray alloc] init];
    _productName = [runData objectForKey:@"Product"];
    _productNumber = [runData objectForKey:@"Product ID"];
    _runType = [runData objectForKey:@"Run Type"];
    _vendorName = [runData objectForKey:@"Vendor_name"];
    _detail = [runData objectForKey:@"description"];
    _shipping = [runData objectForKey:@"Shipping"];
    _activated = [[runData objectForKey:@"JOBS"] boolValue];
    _priority = 0;
    //_sequence = 0;
    if ([runData[@"Category"] isEqualToString:@"PCB"]) {
        _category = 0;
    }
    else {
        _category = 1;
    }
    NSString *priorityString = (NSString*)[runData objectForKey:@"Priority"];
    if ([priorityString isEqualToString:@"High"]) {
        _priority = 2;
    }
    else if ([priorityString isEqualToString:@"Medium"]) {
        _priority = 1;
    }
    runDefects = [[NSMutableArray alloc] init];
    runProcesses = [[NSMutableArray alloc] init];
    runFeedbacks = [[NSMutableArray alloc] init];

    [self generateJobs];
}

- (void)updateRunStatus:(NSString*)statusString{
    _status = statusString;
    [runData setValue:_status forKey:@"Status"];
}

- (void)updateRunStatus:(NSString*)statusString withQty:(int)quantity andTag:(int)tag{
    _status = statusString;
    [runData setValue:_status forKey:@"Status"];

    if (tag == 0) {
        _inProcess = [NSString stringWithFormat:@"%d",quantity];
        [runData setValue:[NSString stringWithFormat:@"%d",quantity] forKey:@"Inprocess"];
    }
    else if (tag == 1) {
        _ready = [NSString stringWithFormat:@"%d",quantity];
        [runData setValue:[NSString stringWithFormat:@"%d",quantity] forKey:@"Ready"];
    }
    else {
        _shipped = [NSString stringWithFormat:@"%d",quantity];
        [runData setValue:[NSString stringWithFormat:@"%d",quantity] forKey:@"Shipped"];
    }

}

- (void)updateRunData:(NSDictionary*)runData_ {
    _inProcess = [[runData_ objectForKey:@"InProcess"] intValue];
    _ready = [[runData_ objectForKey:@"Quantity"] intValue];
    _shipped = [[runData_ objectForKey:@"Shipped"] intValue];
    _rework = [[runData_ objectForKey:@"Rework"] intValue];
    _reject = [[runData_ objectForKey:@"Reject"] intValue];
    _status = [runData_ objectForKey:@"Status"];
    _shipping = [runData_ objectForKey:@"Shipping"];
    //_sequence = [[runData_ objectForKey:@"Sequence"] intValue];
    [runData setValue:_status forKey:@"Status"];
    //[runData setValue:[runData_ objectForKey:@"Quantity"] forKey:@"Qty"];
    [runData setValue:[runData_ objectForKey:@"Shipped"] forKey:@"Shipped"];
    [runData setValue:[runData_ objectForKey:@"Quantity"] forKey:@"Ready"];
    [runData setValue:[runData_ objectForKey:@"Rework"] forKey:@"Rework"];
    [runData setValue:[runData_ objectForKey:@"Reject"] forKey:@"Reject"];
    [runData setValue:[runData_ objectForKey:@"InProcess"] forKey:@"Inprocess"];
    [runData setValue:[runData_ objectForKey:@"Shipping"] forKey:@"Shipping"];
    //[runData setValue:[runData_ objectForKey:@"Sequence"] forKey:@"Sequence"];
    NSLog(@"updated rundata=%@",runData);
}

- (NSMutableDictionary*)getRunData {
    return runData;
}

- (int)getRunId {
    return self.runId;
}

- (int)getQuantity {
    return _quantity;
}

- (int)getReject {
    return _reject;
}

- (int)getRework {
    return _rework;
}

- (int)getProductId {
    return _productId;
}

- (NSString*)getRunType {
    return _runType;
}

- (NSString*)getProductNumber {
    return _productNumber;
}

- (NSString*)getProductName {
    return self.productName;
}

- (NSString*)getVendorName {
    return _vendorName;
}

- (NSString*)getRequestDate {
    return _requestDate;
}

- (NSString*)getRunDate {
    return _runDate;
}

- (NSString*)getStatus {
    return _status;
}

- (NSString*)getDescription {
    return _detail;
}

- (int)getPriority {
    return _priority;
}

- (void)setCategory:(int)category_ {
    _category = category_;
}

- (int)getCategory {
    return _category;
}

- (BOOL)isActivated {
    return self.activated;
}

- (void)setRunJobs:(NSMutableArray*)jobsArray {
    runJobs = [[NSMutableArray alloc] init];

    for (int i=0; i < [jobsArray count]; ++i) {
        Job *job = [[Job alloc] init];
        [job setJobData:[jobsArray objectAtIndex:i]];
        NSMutableDictionary *productData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1001",@"productId",@"2",@"productRevId",@"Sentinel Next Pro",@"productName", nil];
        [job setProductId:_productNumber];
        //[job setProductRevId:_productId];
        //[job setProductName:_productName];
        [runJobs addObject:job];
      //  [_jobs addObject:job];
    }
   // NSLog(@"job count = %d",_jobs.count);
}

- (NSMutableArray*)getRunJobs {
    return runJobs;
}

- (NSMutableArray*)getRunJobsForType:(int)type {
    NSMutableArray *jobsArray = [[NSMutableArray alloc] init];
    for (int i=0; i < [runJobs count]; ++i) {
        Job *job = [runJobs objectAtIndex:i];
        if ([job getJobType]==type) {
            [jobsArray addObject:job];
        }
    }
    return jobsArray;
}

- (void)setRunProcesses:(NSMutableArray*)processesArray {

    runProcesses = processesArray;
    NSLog(@"after setting run processes = %@",runProcesses);
}

- (NSMutableArray*)getRunProcesses {
    return runProcesses;
}

- (void)setRunDefects:(NSMutableArray*)defectsArray {
    runDefects = [[NSMutableArray alloc] init];
    for (int i=0; i < [defectsArray count]; ++i) {
        Defect *defect = [[Defect alloc] init];
        [defect setDefectData:[defectsArray objectAtIndex:i]];
        [runDefects addObject:defect];
    }
}

- (void)addDefect:(Defect*)defect forJobId:(NSString*)jobId_ {
    for (int i=0; i < [runJobs count]; ++i) {
        Job *job = [runJobs objectAtIndex:i];
        if ([[job getJobId] isEqualToString:jobId_]) {
            [job addJobDefect:defect];
            [runDefects addObject:defect];
            break;
        }
    }
}

- (void)updateDefect:(Defect*)defect forJobId:(NSString*)jobId_ {
    
}

- (void)addDefect:(Defect*)defect {
    [runDefects addObject:defect];
}

- (NSMutableArray*)getRunDefects {
    return runDefects;
}

- (NSMutableArray*)getRunDefectsForType:(int)type {
    NSMutableArray *defectsArray = [[NSMutableArray alloc] init];
    for (int i=0; i < [runDefects count]; ++i) {
        Defect *defect = runDefects[i];
        if ([defect getDefectType] == type) {
            [defectsArray addObject:defect];
        }
    }
    return defectsArray;
}

- (NSMutableArray*)getRunDefectsForJobId:(NSString*)jobId {
    for (int i=0; i < [runJobs count]; ++i) {
        Job *job = runJobs[i];
        if ([jobId isEqualToString:[job getJobId]]) {
            return [job getJobDefects];
        }
    }
    return nil;
}


- (void)generateJobs {
    if ([runJobs count]>0) {
        return;
    }
    for (int i=0; i < _quantity; ++i) {
        Job *job = [[Job alloc] init];
        NSMutableDictionary *jobData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d-%d",_runId,i+1],@"jobid",@"0",@"status", nil];
        [job setJobData:jobData];
        [job setJobType:0];
        [job setProductId:_productNumber];
        //[job setProductRevId:_productId];
        //[job setProductName:_productName];
        [runJobs addObject:job];
        //[self.jobs addObject:job];
    }
   // NSLog(@"job count = %d",self.jobs.count);

}

- (void)setJobDetail:(NSMutableDictionary*)jobDetail ForJobId:(NSString*)jobId {
    for (int i=0; i < [runJobs count]; ++i) {
        Job *job = runJobs[i];
        if ([jobId isEqualToString:[job getJobId]]) {
            [job setJobDetail:jobDetail];
            break;
        }
    }
}

- (NSMutableArray*)getRunFeedbacks {
    return  runFeedbacks;
}

- (void)addRunFeedback:(NSMutableDictionary*)feedbackData {
    [runFeedbacks addObject:feedbackData];
}

- (void)setSequenceNum:(int)sequence_{
    _sequence = sequence_;
    [runData setValue:[NSString stringWithFormat:@"%d",sequence_] forKey:@"Sequence"];
}

- (NSMutableArray*)getRunPartsShort {
    return runPartsShort;
}

- (void)setRunPartsShort:(NSMutableArray*)partsShortArray {
    runPartsShort = partsShortArray;
}

@end
