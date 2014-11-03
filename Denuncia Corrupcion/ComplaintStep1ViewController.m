//
//  LocationViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "ComplaintStep1ViewController.h"
#import "MenuViewController.h"
#import "ComplaintStep2ViewController.h"
#import <MapKit/MapKit.h>
#import "ComplaintsViewController.h"

@interface ComplaintStep1ViewController ()
{
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *complaintSelector;
    IBOutlet UIView *glosaryFrame;
    float latitude;
    float longitude;
    NSString *address;
    IBOutlet UIButton *glosaryButton;
    UIImageView *imgView;
    CGImageRef cgImg;
    CIContext *context;
    UIViewController *rootViewC;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
}

@end

@implementation ComplaintStep1ViewController
@synthesize complaintSelection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"ComplaintsStep1";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Denunciar"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"denunciaBarIcon.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    [glosaryFrame removeFromSuperview];
    [self performSelector:@selector(setUserLocation) withObject:nil afterDelay:1.f];
    [self setTitle:@" "];
}

-(IBAction)complaintSelectedButtons:(id)sender{
    
    complaintSelection = [[NSNumber alloc] initWithInteger:[sender tag]];
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        complaintSelector.frame = CGRectMake(-300, 91, 288,300);
        
    } completion:^(BOOL finished) {
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
            
        }
        ComplaintStep2ViewController *viewController = (ComplaintStep2ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintStep2ViewController"];
        [viewController setComplaintValue:complaintSelection];
        [viewController setUserLocation:coordinate];
        //do what you need to do when animation ends...
        [viewController setRootViewController:rootViewC];
        [self.navigationController pushViewController:viewController animated:NO];
        complaintSelector.frame = CGRectMake(16, 91, 288,300);
    }];
    
    [glosaryFrame removeFromSuperview];
    
}

-(IBAction)cancelComplaintProcess:(id)sender{
    
    [[self navigationController] popToViewController:rootViewC animated:YES];
    
}

-(IBAction)onCloseGlosaryView:(id)sender{
    
    
    //**BLUR**//
    [self.view addSubview:glosaryFrame];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        glosaryFrame.frame = CGRectMake(35, 570, 250, 350);
        
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
        [glosaryButton setEnabled:YES];

    }];
    
}

-(IBAction)setBlurOnCurrentView:(id)sender{
    
    [glosaryButton setEnabled:NO];
    
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
    imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = outputImg;
    [imgView addSubview:blurView];
    [self.view addSubview:imgView];
    //**BLUR**//
    [self.view addSubview:glosaryFrame];
    
    [imgView setAlpha:0];
    [UIView animateWithDuration:.3 animations:^{
        
        [imgView setAlpha:1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            glosaryFrame.frame = CGRectMake(35, 115, 250, 350);
            
        } completion:^(BOOL finished) {
            
        }];

        
    }];
    

}

- (void)setUserLocation
{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    #endif
    [locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    MKCoordinateRegion region;
    //coordinate = mapView.userLocation.location.coordinate;
     CLLocationCoordinate2D coord  = {(19.3823797),(-99.1762844)};
    coordinate = coord;
    region.center = coordinate;
    region.span = MKCoordinateSpanMake(0.05, 0.05);
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (IBAction)showMenu:(id)sender
{
    [[MenuViewController menuController] showMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRootViewController:(UIViewController *) rootView{
    
    rootViewC = rootView;
    
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
