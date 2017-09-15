//
//  Defect.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 06/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Defect.h"

@implementation Defect

- (void)setDefectData:(NSMutableDictionary*)defectData {
    defectId = [defectData objectForKey:@"Id"];
    defectType = [[defectData objectForKey:@"Type"] intValue];
    text = [defectData objectForKey:@"Title"];
    detailText = [defectData objectForKey:@"Description"];
    if (!defectStats) {
        defectStats = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *defectStat = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[defectData objectForKey:@"operator"],@"operator",[defectData objectForKey:@"time"],@"time", nil];
    [self addDefectStat:defectStat];
}

- (void)addDefectStat:(NSMutableDictionary*)defectStat {
    [defectStats addObject:defectStat];
    timesFound++;
}

- (void)setDefectId:(NSString*)id_ {
    defectId = id_;
}

- (void)setDefectText:(NSString*)text_ {
    text = text_;
}

- (void)setDefectDetailText:(NSString*)detailText_ {
    detailText = detailText_;
}

- (void)setDefectType:(int)type {
    defectType = type;
}

- (NSString*)getDefectId {
    return defectId;
}

- (int)getDefectType {
    return defectType;
}

- (int)getDefectStatus {
    return status;
}

- (int)getTimesFound {
    return timesFound;
}

- (NSString*)getText {
    return text;
}

- (NSString*)getDetailText {
    return detailText;
}

- (NSString*)getJobId {
    return jobId;
}

- (NSString*)getDefectRunId {
    return runId;
}

- (NSMutableArray*)getDefectStats {
    return defectStats;
}

@end
