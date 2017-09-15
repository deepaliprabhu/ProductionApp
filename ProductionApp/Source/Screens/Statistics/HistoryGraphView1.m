//
//  HistoryGraphView.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/01/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "HistoryGraphView.h"

@implementation HistoryGraphView

__CREATEVIEW(HistoryGraphView, @"HistoryGraphView", 0);

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setStatsDataArray:(NSMutableArray*)array {
    self.labels = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    statsArray = array;
    NSMutableArray *qtyArray = [[NSMutableArray alloc] init];
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (int i=0; i<statsArray.count; ++i) {
        NSDictionary *statsData = statsArray[i];
        [qtyArray addObject:statsData[@"TotalQuantity"]];
        [timeArray addObject:statsData[@"TotalTime"]];
        [self.labels addObject:statsData[@"Date"]];
    }
    [self.data addObject:qtyArray];
    [self.data addObject:timeArray];
    NSLog(@"data= %@",self.data);
}

- (void)initGraph {
    //self.backgroundColor = [UIColor gk_cloudsColor];

    /*self.data = @[
                  @[@20, @40, @20, @60, @40, @140, @80],
                  @[@40, @20, @60, @100, @60, @20, @60],
                  @[@80, @60, @40, @160, @100, @40, @110],
                  @[@120, @150, @80, @120, @140, @100, @0],
                  //                  @[@620, @650, @580, @620, @540, @400, @0]
                  ];
    
    self.labels = @[@"2001", @"2002", @"2003", @"2004", @"2005", @"2006", @"2007"];*/
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    self.graph.valueLabelCount = 6;
    //self.graph.isUserInteractionEnabled = true;
    
    [self.graph draw];
}

#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return [self.data count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return [[@[@1, @1.6] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}



@end
