//
//  WorkInstruction.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 11/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkInstruction : NSObject{
    int instructionId;
    NSString *instructionText;
}
- (void)setInstructionData:(NSDictionary*)instructionData;
- (int)getInstructionId;
- (NSString*)getInstructionText;
@end
