//
//  Station.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "Station.h"

@implementation Station

- (void)setStationId:(int)stationId_ {
    stationId = stationId_;
    processEntries = [[NSMutableArray alloc] init];
}

- (void)setStationName:(NSString*)stationName_ {
    stationName = stationName_;
}

- (void)setOperatorName:(NSString*)operatorName_ {
    operatorName = operatorName_;
}

- (void)setQuantity:(int)quantity_ {
    quantity = quantity_;
}

- (void)setTime:(int)time_ {
    time = time_;
}

- (int)getStationId {
    return  stationId;
}

- (NSString*)getStationName {
    return stationName;
}

- (NSString*)getOperatorName {
    return operatorName;
}

- (int)getQuantity {
    return quantity;
}

- (int)getTime {
    return time;
}

-(void)addProcessEntry:(NSMutableDictionary*)processEntry {
    [processEntries addObject:processEntry];
}

-(NSMutableArray*)getProcessEntries {
    return processEntries;
}

@end
