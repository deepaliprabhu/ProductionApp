//
//  Process.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Process.h"
#import "WorkInstruction.h"
#import "Checklist.h"
#import "Job.h"

@implementation Process

- (void)setProcessData:(NSDictionary*)processData {
    subProcesses = [[NSMutableArray alloc] init];
    workInstructions = [[NSMutableArray alloc] init];
    checklist = [[NSMutableArray alloc] init];
    jobsDone = [[NSMutableArray alloc] init];

    _processId = [processData objectForKey:@"id"];
    _processName = [processData objectForKey:@"name"];
    _status = 0;
    _timeLogged = 0;
    [self setSubProcesses:[processData objectForKey:@"subprocesses"]];
    [self setChecklist:[processData objectForKey:@"checklist"]];
    [self setWorkInstructions:[processData objectForKey:@"instructions"]];
}

- (void)setSubProcesses:(NSMutableArray*)subProcesses_ {
    for (int i = 0; i < [subProcesses_ count]; ++i) {
        Process *process = [[Process alloc] init];
        [process setProcessData:[subProcesses_ objectAtIndex:i]];
        [subProcesses addObject:process];
    }
}

- (NSString*)getProcessId {
    return _processId;
}

- (NSString*)getProcessName {
    return _processName;
}

- (int)getProcessStatus {
    return _status;
}

- (NSString*)getStartDate {
    return _startDate;
}

- (NSString*)getStopDate {
    return _stopDate;
}

- (NSString*)getProcessStatusDescription {
    switch (_status) {
        case 0:
            return @"Open";
            break;
        case 1:
            return @"In Progress";
            break;
        case 2:
            return @"Completed";
            break;
        default:
            break;
    }
    return nil;
}

- (NSMutableArray*)getSubProcesses {
    return subProcesses;
}

- (void)setWorkInstructions:(NSMutableArray*)instructions {
    NSLog(@"setting work instructtions");
    workInstructions = [[NSMutableArray alloc] init];

    for (int i=0; i < instructions.count; ++i) {
        NSMutableDictionary *instructionData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"id", [instructions objectAtIndex:i], @"description", nil];
        WorkInstruction *instruction = [[WorkInstruction alloc] init];
        [instruction setInstructionData:instructionData];
        [workInstructions addObject:instruction];
    }
}

- (void)setChecklist:(NSMutableArray*)checklist_ {
    checklist = [[NSMutableArray alloc] init];
    for (int i=0; i < checklist_.count; ++i) {
        //NSMutableDictionary *checklistData = [checklist_ objectAtIndex:i];
        NSMutableDictionary *checklistData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[checklist_ objectAtIndex:i], @"description", nil];
        Checklist *checklst = [[Checklist alloc] init];
        [checklst setChecklistData:checklistData];
        [checklist addObject:checklst];
    }
}

- (void)setProcessStatus:(int)status_ {
    _status = status_;
}

- (void)setStartDate:(NSString*)startDate_ {
    _startDate = startDate_;
}

- (void)setStopDate:(NSString*)stopDate_ {
    _stopDate = stopDate_;
}

- (NSMutableArray*)getChecklist {
    return checklist;
}

- (NSMutableArray*)getWorkInstructions {
    NSLog(@"getting work instructtions");

    return workInstructions;
}

- (NSInteger)getTimeLogged {
    return _timeLogged;
}

- (void)setTimeLogged:(int)time {
    _timeLogged = time;
}

- (void)setProcessJobs:(NSMutableArray*)jobs {
    processJobs = jobs;
    for (int i =0; i < [processJobs count]; ++i) {
        Job *job = processJobs[i];
        if ([job getJobType] == 2) {
            [jobsDone addObject:job];
            [job setProcessIndex:[job getProcessIndex]+1];
            [processJobs removeObjectAtIndex:i];
        }
    }
}

- (NSMutableArray*)getProcessJobs {
    return processJobs;
}

- (void)finishedJob:(NSString*)jobId {
    for (int i =0; i < [processJobs count]; ++i) {
        Job *job = processJobs[i];
        if ([[job getJobId] isEqualToString:jobId]) {
            [job setStatus:2];
            [jobsDone addObject:job];
            [job setProcessIndex:[job getProcessIndex]+1];
            //[processJobs removeObjectAtIndex:i];
        }
    }
}

- (NSMutableArray*)getJobsDone {
    return jobsDone;
}

@end
