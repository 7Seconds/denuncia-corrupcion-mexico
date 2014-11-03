//
//  MenuViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "ComplaintsViewController.h"
#import "ComplaintStep1ViewController.h"
#import "ProcedureViewController.h"
#import "PortalViewController.h"
#import "SFPViewController.h"
#import "HelpViewController.h"
#import "ConfigViewController.h"
#import "RegistrationViewController.h"
#import "ComplaintStep2ViewController.h"
#import "MyComplaintsViewController.h"
#import "MyComplaintsDetailViewController.h"

@interface MenuViewController ()
{
    IBOutlet UIView *backgroundView;
    IBOutlet UIScrollView *scrollView;
    IBOutletCollection(UILabel) NSArray *menuLabels;
}

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (MenuViewController *)menuController
{
    static  MenuViewController *singleton = nil;
    @synchronized(self) {
        if (!singleton) {
            singleton = [self new];
        }
    }
    return singleton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(setScrollView) withObject:nil afterDelay:0.5f];
    UIFont *customFont = [UIFont fontWithName:@"NexaLight" size:15.f];
    for (UILabel *label in menuLabels) {
        [label setFont:customFont];
    }
}

- (void)setScrollView
{
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake([backgroundView frame].size.width, [backgroundView frame].size.height-200)];
}

- (void)showMenu
{
    [UIView animateWithDuration:0.4f animations:^{
        [[self view] setFrame:CGRectMake(
                                         [[self view] frame].origin.x + 320.f,
                                         [[self view] frame].origin.y,
                                         [[self view] frame].size.width,
                                         [[self view] frame].size.height)];
    }];
}

- (void)hideMenu
{
    if ([[self view] frame].origin.x >= 0.f) {
        [UIView animateWithDuration:0.4f animations:^{
            [[self view] setFrame:CGRectMake(
                                             [[self view] frame].origin.x - 320.f,
                                             [[self view] frame].origin.y,
                                             [[self view] frame].size.width,
                                             [[self view] frame].size.height)];
        }];
    }
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    UIFont *customFont = [UIFont fontWithName:@"NexaLight" size:19.f];
    label.font = customFont;
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    return label;
}

- (IBAction)blankPressed:(id)sender
{
    
    [self hideMenu];
    if([[self delegate] respondsToSelector:@selector(hideMenuController)])
       [[self delegate] hideMenuController];
}

- (IBAction)selectedButtonAtIndex:(id)sender
{
    UIStoryboard *storyboard;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main4" bundle:nil];
            NSLog(@"Device has a 3.5inch Display.");
        }
        if (iOSDeviceScreenSize.height == 568)
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NSLog(@"Device has a 4inch Display.");
        }
        
    }

    id viewController;
    
    switch ([sender tag]) {
        case 0:
            viewController = (ComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintsViewController"];
            break;
        /*case 1:
            viewController = (MyComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyComplaintsViewController"];
            break;*/
        case 2:
            viewController = (ProcedureViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProcedureViewController"];
            break;
        case 3:
            viewController = (PortalViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PortalViewController"];
            break;
        case 4:
            viewController = (SFPViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SFPViewController"];
            break;
        case 5:
            viewController = (HelpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
            break;
        case 6:
            viewController = (ConfigViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ConfigViewController"];
            break;
        case 7:
            viewController = (RegistrationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
            break;/*
        case 8:
            viewController = (TicketViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TicketViewController"];
            break;
        case 9:
            viewController = (MyComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyComplaintsViewController"];
            break;
        case 10:
            viewController = (WeatherViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WeatherViewController"];
            break;*/
        default:
            break;
    }
    
    [[self delegate] selectedViewController:viewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
