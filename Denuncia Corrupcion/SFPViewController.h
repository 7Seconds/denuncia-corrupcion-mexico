//
//  PresentationsViewController.h
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SFPViewController : GAITrackedViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;


@end
