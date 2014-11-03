//
//  TicketViewController.h
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface ComplaintStep3ViewController : GAITrackedViewController<MKMapViewDelegate,  CLLocationManagerDelegate>

-(void)setComplaintLocation:(CLLocationCoordinate2D)location;

@end
