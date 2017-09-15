//
//  Station.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject {
    int stationId;
    int quantity;
    int time;
    NSString *stationName;
    NSString *operatorName;
    NSMutableArray *processEntries;
}
- (void)setStationId:(int)stationId;
- (void)setStationName:(NSString*)stationName_;
- (void)setOperatorName:(NSString*)operatorName_;
- (void)setQuantity:(int)quantity_;
- (void)setTime:(int)time_;
- (int)getStationId;
- (NSString*)getStationName;
- (NSString*)getOperatorName;
- (int)getQuantity;
- (int)getTime;
-(void)addProcessEntry:(NSMutableDictionary*)processEntry;
-(NSMutableArray*)getProcessEntries;
@end
