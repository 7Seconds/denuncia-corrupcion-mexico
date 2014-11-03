//
//  PreviousEventsViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "ConfigViewController.h"
#import "MenuViewController.h"
#import "RegistrationViewController.h"

@interface ConfigViewController (){
    
    IBOutlet UISwitch *newPublicComplaints;
    IBOutlet UISwitch *myComplaintsStatus;
    IBOutlet UISwitch *newsSFP;
    IBOutlet UIButton *logOut;
    
    NSUserDefaults *prefs;
    UIImageView *blurImageView;
    CGImageRef cgImg;
    CIContext *context;
    
}

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Configuration";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Configuración"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"configMenuButton.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    prefs = [NSUserDefaults standardUserDefaults];
    
        if ([[prefs objectForKey:@"settings:newPublicComplaintsValue"] isEqualToString:@"on"]) {
            [newPublicComplaints setOn:YES];
        } else {
            [newPublicComplaints setOn:NO];
        }
        
        if ([[prefs objectForKey:@"settings:myComplaintsStatusValue"]isEqualToString:@"on"]) {
            [myComplaintsStatus setOn:YES];
        } else {
            [myComplaintsStatus setOn:NO];
        }
    
        if ([[prefs objectForKey:@"settings:newsSFPValue"] isEqualToString:@"on"]) {
            [newsSFP setOn:YES];
        } else {
            [newsSFP setOn:NO];
        }

    
}

-(IBAction)newPublicComplaintsSwitcher:(id)sender{
    
    if(![newPublicComplaints isOn]){

        prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:newPublicComplaintsValue"]) {
            [prefs setObject:@"off" forKey:@"settings:newPublicComplaintsValue"];
        } else {
            [prefs removeObjectForKey:@"settings:newPublicComplaintsValue"];
            [prefs setObject:@"off" forKey:@"settings:newPublicComplaintsValue"];
        }

        
    }
    else{
        
        prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:newPublicComplaintsValue"]) {
            [prefs setObject:@"on" forKey:@"settings:newPublicComplaintsValue"];
        } else {
            [prefs removeObjectForKey:@"settings:newPublicComplaintsValue"];
            [prefs setObject:@"on" forKey:@"settings:newPublicComplaintsValue"];
        }

    }
    
}

-(IBAction)myComplaintsStatusSwitcher:(id)sender{
    
    if(![myComplaintsStatus isOn]){
        
        prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:myComplaintsStatusValue"]) {
            [prefs setObject:@"off" forKey:@"settings:myComplaintsStatusValue"];
            //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        } else {
            [prefs removeObjectForKey:@"settings:myComplaintsStatusValue"];
            [prefs setObject:@"off" forKey:@"settings:myComplaintsStatusValue"];
            //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
        
        
    }
    else{
        
        prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:myComplaintsStatusValue"]) {
            [prefs setObject:@"on" forKey:@"settings:myComplaintsStatusValue"];
        } else {
            [prefs removeObjectForKey:@"settings:myComplaintsStatusValue"];
            [prefs setObject:@"on" forKey:@"settings:myComplaintsStatusValue"];
        }
        
    
        
    }
    
}


-(IBAction)newsSFPSwitcher:(id)sender{
    
    if(![newsSFP isOn]){
        
        prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:newsSFPValue"]) {
            [prefs setObject:@"off" forKey:@"settings:newsSFPValue"];
        } else {
            [prefs removeObjectForKey:@"settings:newsSFPValue"];
            [prefs setObject:@"off" forKey:@"settings:newsSFPValue"];
        }
        
    }
    else{
        
        prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:newsSFPValue"]) {
            [prefs setObject:@"on" forKey:@"settings:newsSFPValue"];
        } else {
            [prefs removeObjectForKey:@"settings:newsSFPValue"];
            [prefs setObject:@"on" forKey:@"settings:newsSFPValue"];
        }
        
    }
    
}

-(IBAction)logOutAction:(id)sender{
    
    [prefs removeObjectForKey:@"settings:user"];
    [prefs removeObjectForKey:@"settings:password"];
    [prefs removeObjectForKey:@"settings:email"];
    
    [prefs removeObjectForKey:@"settings:name"];
    [prefs removeObjectForKey:@"settings:pLname"];
    [prefs removeObjectForKey:@"settings:mLname"];
    
    [prefs removeObjectForKey:@"complaints"];
    [prefs removeObjectForKey:@"mycomplaints"];
    
    [prefs removeObjectForKey:@"settings:newPublicComplaintsValue"];
    [prefs removeObjectForKey:@"settings:myComplaintsStatusValue"];
    [prefs removeObjectForKey:@"settings:newsSFPValue"];
    
    
    UIStoryboard *storyboard = nil;
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
        
    }    id viewController = (RegistrationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self.navigationController pushViewController:viewController animated:YES];

}


-(UIImageView *)loadBlurView{
    
    
    //**BLUR**//
    //Get a screen capture from the current view.
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Blur the image
    CIImage *blurImg = [CIImage imageWithCGImage:viewImg.CGImage];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:blurImg forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:7.0f] forKey:@"inputRadius"];
    
    context = [CIContext contextWithOptions:nil];
    cgImg = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[blurImg extent]];
    UIImage *outputImg = [UIImage imageWithCGImage:cgImg];
    
    //Add UIImageView to current view.
    UIView *blurView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [blurView setBackgroundColor:[UIColor colorWithWhite:0.05 alpha:0.5]];
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imagView.image = outputImg;
    [imagView addSubview:blurView];
    return imagView;
}

- (IBAction)showMenu:(id)sender
{
    blurImageView = [self loadBlurView];
    [blurImageView setAlpha:0];
    [self.view addSubview:blurImageView];
    [UIView animateWithDuration:0.4 animations:^{
        [blurImageView setAlpha:1];
    }];
    [[MenuViewController menuController] showMenu];
}

-(void)hideMenuController{
    [blurImageView setAlpha:1];
    [UIView animateWithDuration:0.4 animations:^{
        [blurImageView setAlpha:0];
    } completion:^(BOOL fin){
        [blurImageView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
