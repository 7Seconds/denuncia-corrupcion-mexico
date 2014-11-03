//
//  WeatherViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "MyComplaintsDetailViewController.h"
#import "MenuViewController.h"
#import <MapKit/MapKit.h>

@interface MyComplaintsDetailViewController (){
    
    IBOutlet MKMapView *mapView;
    IBOutlet UIImageView *picEvidence;
    IBOutlet UIImageView *vidEvidence;
    IBOutlet UIImageView *audEvidence;
    IBOutlet UIImageView *whitEvidence;
    
    IBOutlet UILabel *complaintType;
    IBOutlet UILabel *complaintSummary;
    
    IBOutlet UIImageView *qrCode;
    IBOutlet UIImageView *complaintTypeImage;
    
    IBOutlet UILabel *folio;
    NSInteger complaintIndex;
    
    NSMutableArray *complaints;
    CLLocationManager *locationManager;

}

@end

@implementation MyComplaintsDetailViewController

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
    self.screenName = @"MyComplaintsDetail";
    [self performSelector:@selector(setComplaintLocation) withObject:nil afterDelay:0.f];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Mis Denuncias"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"denunciaBarIcon.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    complaints = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"mycomplaints"]];
    
    [folio setText:[NSString stringWithFormat:@"%@", [[complaints objectAtIndex:complaintIndex] objectForKey:@"folio"] ]];
    switch ([[[complaints objectAtIndex:complaintIndex] objectForKey:@"type"] integerValue]) {
        case 0:
            [complaintType setText: @"Extorsión"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"extorsionButton.png"]];
            break;
        case 1:
            [complaintType setText:@"Soborno"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"sobornoButton.png"]];
            break;
        case 2:
            [complaintType setText:@"Fraude"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"fraudeButton.png"]];
            break;
        case 3:
            [complaintType setText:@"Peculado"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"peculadoButton.png"]];
            break;
        case 4:
            [complaintType setText:@"Colusión"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"colusionButton.png"]];
            break;
        case 5:
            [complaintType setText:@"T.Influencias"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"tinfluenciasButton.png"]];
            break;
        case 6:
            [complaintType setText:@"No Ético"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"noeticoButton.png"]];
            break;
        case 7:
            [complaintType setText:@"Otro"];
            [complaintTypeImage setImage:[UIImage imageNamed:@"otroButton.png"]];
            break;
            
        default:
            break;
    }
    
    [complaintSummary setText:[[complaints objectAtIndex:complaintIndex] objectForKey:@"description"]];
    
    if(![[[complaints objectAtIndex:complaintIndex] objectForKey:@"havePic"] boolValue])
        [picEvidence setHidden:YES];
    if(![[[complaints objectAtIndex:complaintIndex] objectForKey:@"haveVid"] boolValue])
        [vidEvidence setHidden:YES];
    if(![[[complaints objectAtIndex:complaintIndex] objectForKey:@"haveAud"] boolValue])
        [audEvidence setHidden:YES];
    if(![[[complaints objectAtIndex:complaintIndex] objectForKey:@"haveWhit"] boolValue])
        [whitEvidence setHidden:YES];
    
    [self showQRCode];
    [self setTitle:@" "];
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

-(void)setComplaintIndex:(NSInteger) index{
    
    complaintIndex = index;
}

- (IBAction)showMenu:(id)sender
{
    [[MenuViewController menuController] showMenu];
}

- (void)setComplaintLocation
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
    MKCoordinateRegion region;
    CLLocationCoordinate2D coordinate = {([[[complaints objectAtIndex:complaintIndex] objectForKey:@"latitude"] doubleValue]),([[[complaints objectAtIndex:complaintIndex] objectForKey:@"longitude"]doubleValue])};;
    
    region.center = coordinate;
    region.span = MKCoordinateSpanMake(0.003, 0.003);
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = @"Aquí sucedió";
    point.subtitle = @"";
    [mapView removeAnnotations:[mapView annotations]];
    [mapView addAnnotation:point];
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
