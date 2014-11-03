//
//  WeatherViewController.h
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MyComplaintsDetailViewController : GAITrackedViewController<MKMapViewDelegate,  CLLocationManagerDelegate>

-(void)setComplaintIndex:(NSInteger) index;

@end
