//
//  HistoryGraphView.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/01/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "GraphKit.h"

@interface HistoryGraphView : UIView <GKLineGraphDataSource> {
    NSMutableArray *statsArray;
}
@property (nonatomic, weak) IBOutlet GKLineGraph *graph;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *labels;
__CREATEVIEWH(HistoryGraphView);
- (void)initGraph;
- (void)setStatsDataArray:(NSMutableArray*)array;
@end
