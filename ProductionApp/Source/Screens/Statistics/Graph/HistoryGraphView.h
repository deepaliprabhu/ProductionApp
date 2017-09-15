//
//  GraphView.h
//  SentinelNext
//
//  Created by Aginova on 24/11/14.
//  Copyright (c) 2014 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "CorePlot-CocoaTouch.h"
#import "ConnectionManager.h"
#import "GraphData.h"

@protocol HistoryGraphViewProtocol;
@interface HistoryGraphView : UIView <CPTPlotDataSource,CPTScatterPlotDataSource, CPTScatterPlotDelegate, CPTPlotSpaceDelegate, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *timeperiodLabel;
    IBOutlet UILabel *noGraphLabel;
    IBOutlet UILabel *tempLabel;
    IBOutlet UILabel *temp1Label;
    IBOutlet UILabel *humidityLabel;
    IBOutlet UILabel *alarmActiveLabel;
    IBOutlet UIButton *tempButton;
    IBOutlet UIButton *temp1Button;
    IBOutlet UIButton *humidityButton;
    IBOutlet UIButton *alarmActiveButton;
    IBOutlet UIButton *detailsButton;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *expandButton;
    IBOutlet UIButton *zoomButton;
    IBOutlet UIButton *_selectedGraphButton;
    IBOutlet UIButton *_logButton;

    IBOutlet UIView *tempView;
    IBOutlet UIView *temp1View;
    IBOutlet UIView *humidityView;
    IBOutlet UIView *detailsView;
    IBOutlet UIView *alarmActiveView;
    IBOutlet UIView *xAxisSeparatorView;
    IBOutlet UIImageView *downArrowImageView;
    UIView *graphColorsView;
    NSMutableArray *tempArray;
    NSMutableArray *temp1Array;
    NSMutableArray *tempIntArray;
    NSMutableArray *humidityArray;
    NSMutableArray *avgCorrRateArray;
    NSMutableArray *maxCorrRateArray;

    NSMutableArray *timestampArray;
    NSMutableArray *dateArray;

    CPTGraphHostingView* hostView;
    CPTGraphHostingView* hostView1;

    int sensorId;
    UILabel *xAxisLabel;
    BOOL hasActiveAlarm;
    BOOL showingDetails;
    
    NSMutableDictionary *alarmData;
    
    NSMutableArray *alarms;
    NSMutableArray *alarmStartDates;
    NSMutableArray *alarmPinned;
    //NSMutableArray *alarmStopDates;
    NSDate *alarmStartDate;
    NSDate *alarmStopDate;
    float thresholdMinVal;
    float thresholdMaxVal;
    int graphType;
    int showingCustomGraphOptionsView;
    //CPTScatterPlot* plot;
    NSMutableArray *alarmIndices;
    int graphScaleX;
    int graphScaleY;
    int aggregate;
    
    NSMutableArray *plots;
    BOOL showingGraphList;
    UITableView *table;
    NSMutableArray *graphList;
    int selectedGraphIndex;
    NSMutableArray *statsDataArray;
    NSMutableArray *quantityArray;
    
    GraphData *graphData;
    NSMutableArray *graphs;
}
__CREATEVIEWH(HistoryGraphView);
__pd(HistoryGraphViewProtocol);
- (void) initLayout;
- (void)initWithSensorId:(int)sensorId_;
- (void)initWithGraphData:(GraphData*)graphData_;
- (void)setGraphType:(int)type;
- (void)getGraphDataWithStartDate:(NSString*)startDate endDate:(NSString*)endDate aggregate:(int)aggregate;
- (void)graphTypeButtonTappedForPlotIndex:(NSUInteger)index;
- (void)activeAlarmButtonTapped;
- (NSMutableArray*)getPlots;
- (void)setStatsDataArray:(NSMutableArray*)statsArray;

@end

@protocol HistoryGraphViewProtocol <NSObject>
- (void) displayErrorWithMessage:(NSString *)errorMessage;
- (void) zoomGraph;
- (void) contractGraph;
- (void) showCustomGraphOptions;
- (void) hideCustomGraphOptions;
- (void) enableGraphType:(int)index;
- (void) hideLoadingView;
@end
