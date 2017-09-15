//
//  Defect.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 06/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Defect : NSObject {
    NSString *defectId;
    int defectType;
    int status;
    NSString *text;
    NSString *detailText;
    NSString *jobId;
    NSString *runId;
    int timesFound;
    NSMutableArray *defectStats;
}
- (void)setDefectData:(NSMutableDictionary*)defectData;
- (void)addDefectStat:(NSMutableDictionary*)defectStat;
- (void)setDefectId:(NSString*)id_;
- (void)setDefectText:(NSString*)text_;
- (void)setDefectType:(int)type;
- (void)setDefectDetailText:(NSString*)detailText_;
- (NSString*)getDefectId;
- (int)getDefectType;
- (int)getDefectStatus;
- (int)getTimesFound;
- (NSMutableArray*)getDefectStats;
- (NSString*)getJobId;
- (NSString*)getDefectRunId;
- (NSString*)getText;
- (NSString*)getDetailText;
@end
