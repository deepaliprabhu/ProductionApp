//
//  Plot.m
//  SentinelNext
//
//  Created by Aginova on 09/03/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Plot.h"

@implementation Plot

- (void)initWithIdentifier:(NSString*)plotIdentifier_ withColor:(UIColor*)plotColor withTag:(int)plotTag andData:(NSMutableArray*)dataArray{
    tag = plotTag;
    plotIdentifier = plotIdentifier_;
    self.identifier = plotIdentifier;
    color = plotColor;
    data = dataArray;
}

- (UIColor*)plotColor {
    return color;
}

- (NSString*)plotIdentifier {
    return plotIdentifier;
}

- (int)plotTag {
    return tag;
}

- (NSMutableArray*)plotArray {
    return data;
}

- (void)reloadPlotSymbols {
}

/*- (void)setDelegate:(id)delegate {
    self.delegate = delegate;
}*/

@end
