//
//  SFPChildViewController.h
//  PageSFP
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 SFPcoda. All rights reserved.
//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface SFPChildViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UITextView *screenNumber;

@end
