//
//  Plot.h
//  SentinelNext
//
//  Created by Aginova on 09/03/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"


@interface Plot : CPTScatterPlot {
    NSString *plotIdentifier;
    UIColor *color;
    int tag;
    NSMutableArray *data;
}

- (void)initWithIdentifier:(NSString*)plotIdentifier_ withColor:(UIColor*)plotColor withTag:(int)plotTag andData:(NSMutableArray*)dataArray;
- (UIColor*)plotColor;
- (NSString*)plotIdentifier;
- (int)plotTag;
- (NSMutableArray*)plotArray;
- (void)reloadPlotSymbols;
//- (void)setDelegate:(id)delegate;

@end
