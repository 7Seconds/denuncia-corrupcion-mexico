//
//  TicketViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "ComplaintStep3ViewController.h"
#import "MenuViewController.h"
#import <MapKit/MapKit.h>
#import "ComplaintsViewController.h"

@interface ComplaintStep3ViewController (){
    IBOutlet MKMapView *mapView;
    
    IBOutlet UIView *complaintFrame;
    int complaintSelection;
    UIImageView *imgView;
    CGImageRef cgImg;
    
    IBOutlet UILabel *folio;
    IBOutlet UIImageView *qrCode;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
    

}

@end

@implementation ComplaintStep3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(setUserLocation) withObject:nil afterDelay:0.f];
    [super viewWillAppear:animated];
    self.screenName = @"ComplaintsStep3";
}


-(void)successFrameDrawer{
    
    
    [self.view addSubview:complaintFrame];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        complaintFrame.frame = CGRectMake(35, 115, 250, 350);
        
    } completion:^(BOOL finished) {
        
    }];
    

}


- (void)showQRCode
{
    // Do any additional setup after loading the view from its nib.
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //    NSLog(@"filterAttributes:%@", filter.attributes);
    
    [filter setDefaults];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [[defaults objectForKey:@"mycomplaints"] count]-1;
    NSString *token = [NSString stringWithFormat:@"%@",[[[defaults objectForKey:@"mycomplaints"] objectAtIndex: index] objectForKey:@"folio"]];
    NSLog(@"token: %@", token);
    
    NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:10.0];
    
    qrCode.image = resized;
    
    CGImageRelease(cgImage);
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}


-(IBAction)onCloseAnonimousView:(id)sender{
    
    
    //**BLUR**//
    [self.view addSubview:complaintFrame];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        complaintFrame.frame = CGRectMake(35, 570, 250, 350);
        
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
            
        }        id viewController = (ComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintsViewController"];
        //do what you need to do when animation ends...
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Denuncia"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"denunciaBarIcon.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    [complaintFrame removeFromSuperview];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [[defaults objectForKey:@"mycomplaints"] count]-1;
    [folio setText:[NSString stringWithFormat:@"%@",[[[defaults objectForKey:@"mycomplaints"] objectAtIndex: index] objectForKey:@"folio"]]];
    
    [self showQRCode];
    
    [self successFrameDrawer];

}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

-(void)setComplaintLocation:(CLLocationCoordinate2D)location{
    coordinate = location;
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
    //CLLocationCoordinate2D coordinate = mapView.userLocation.location.coordinate;
    
    region.center = coordinate;
    region.span = MKCoordinateSpanMake(0.05, 0.05);
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
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
