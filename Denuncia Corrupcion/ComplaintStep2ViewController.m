//
//  TicketViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "ComplaintStep2ViewController.h"
#import "ComplaintStep3ViewController.h"

#import "MenuViewController.h"
#import "ComplaintStep1ViewController.h"
#import <MapKit/MapKit.h>
#import "ComplaintsViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ComplaintStep2ViewController (){
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *complaintSelector;
    IBOutlet UISwitch *anonimousSwitch;
    IBOutlet UISwitch *publicSwitch;
    IBOutlet UIView *anonimousFrame;
    
    IBOutlet UITextField *description;
    IBOutlet UITextField *date0;
    IBOutlet UITextField *date1;
    IBOutlet UITextField *date2;
    
    IBOutlet UITextField *name;
    IBOutlet UITextField *pLastName;
    IBOutlet UITextField *mLastName;
    IBOutlet UITextField *email;
    
    IBOutlet UILabel *mapInstruction;
    CLLocationCoordinate2D coord;
    CLLocationCoordinate2D coordinate;
    
    BOOL isAnonimus;
    BOOL isPublic;
    BOOL havePic;
    BOOL haveVid;
    BOOL haveAud;
    BOOL haveWhitness;
    
    int complaintSelection;
    UIImageView *imgView;
    CGImageRef cgImg;
    NSInteger evidenceTag;
    
    UIViewController *rootViewC;
    CLLocationManager *locationManager;



}

@end

@implementation ComplaintStep2ViewController

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
    self.screenName = @"ComplaintsStep2";

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *titleView = [[NSString alloc] init];
    NSString *rightImageNamed = [[NSString alloc] init];
    evidenceTag = 0;
    haveAud = NO;
    havePic = NO;
    haveVid = NO;
    
    switch (complaintSelection) {
        case 0:
            titleView = @"Extorsión";
            rightImageNamed = @"extorsionButton copia.png";
            break;
        case 1:
            titleView = @"Soborno";
            rightImageNamed = @"sobornoButton copia.png";
            break;
        case 2:
            titleView = @"Fraude";
            rightImageNamed = @"fraudeButton copia.png";
            break;
        case 3:
            titleView = @"Peculado";
            rightImageNamed = @"peculadoButton copia.png";
            break;
        case 4:
            titleView = @"Colusión";
            rightImageNamed = @"colusionButton copia.png";
            break;
        case 5:
            titleView = @"T.Influencias";
            rightImageNamed = @"tinfluenciasButton copia.png";
            break;
        case 6:
            titleView = @"No Ético";
            rightImageNamed = @"noeticoButton copia.png";
            break;
        case 7:
            titleView = @"Otro";
            rightImageNamed = @"otroButton copia.png";
            break;
            
        default:
            break;
    }
    
    UILabel *label = [[MenuViewController menuController] labelWithTitle:titleView];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:rightImageNamed];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    [anonimousFrame removeFromSuperview];
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [recognizer setNumberOfTapsRequired:1];
    [mapView addGestureRecognizer:recognizer];
    [self setTitle:@" "];
    
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        mapInstruction.frame = CGRectMake(76, 150, 168, 48);
        
    } completion:^(BOOL finished) {
    }];
    
}

-(IBAction)anonimousSwitcher:(id)sender{
    
    if(![anonimousSwitch isOn]){
        [self anonimousFrameDrawer];
    }
    
}
-(IBAction)publicSwitcher:(id)sender{
    
}

-(void)setComplaintValue:(NSNumber *)value{
    
    complaintSelection = [value intValue];
    
}

#pragma mark - ShareAction

-(IBAction)sharePicker:(id)sender{
    
    [self shareText:@"Usa la app DenunciaCorrupción de la SFP y denuncia funcionarios públicos que no hacen bien su trabajo." andImage:[UIImage imageNamed:@"iconForSM.png"] andUrl:nil];
    
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

-(IBAction)evidencePicker:(id)sender{
    
    evidenceTag = [sender tag];
    switch ([sender tag]) {
        case 1:
            [self presentImagePickerControllerPic:nil];
            break;
        case 2:
            [self presentImagePickerControllerVid:nil];
            break;
        case 3:
            [self presentImagePickerControllerAud:nil];
            break;
        case 4:
            [self presentImagePickerControllerWhit:nil];
            break;
            
        default:
            break;
    }
    
}

- (void)presentImagePickerControllerWhit:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.mediaTypes =  nil;
    //picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)presentImagePickerControllerPic:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.mediaTypes =  nil;
    //picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)presentImagePickerControllerVid:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.mediaTypes =  nil;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)presentImagePickerControllerAud:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.mediaTypes =  nil;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if(evidenceTag==1 || info[UIImagePickerControllerOriginalImage]){
        haveWhitness=YES;
    }
    if(evidenceTag==2 || info[UIImagePickerControllerMediaType]){
        haveVid=YES;
    }
    if(evidenceTag==3 || info[UIImagePickerControllerMediaType]){
        havePic=YES;
    }
    if(evidenceTag==4 || info[UIImagePickerControllerOriginalImage]){
        haveAud=YES;
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == description) {
        [description resignFirstResponder];
        [date0 becomeFirstResponder];
    }
    else if (textField == date0) {
        [date0 resignFirstResponder];
        [date1 becomeFirstResponder];
    }
    else if (textField == date1) {
        [date1 resignFirstResponder];
        [date2 becomeFirstResponder];
    }
    else if (textField == date2) {
        [date2 resignFirstResponder];
    }
    
    
    if (textField == name) {
        [name resignFirstResponder];
        [pLastName becomeFirstResponder];
    }
    else if (textField == pLastName) {
        [pLastName resignFirstResponder];
        [mLastName becomeFirstResponder];
    }
    else if (textField == mLastName) {
        [mLastName resignFirstResponder];
        [email becomeFirstResponder];
    }
    else if (textField == email) {
        [email resignFirstResponder];
    }

    return YES;
}


-(void)anonimousFrameDrawer{
    
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
    
    CIContext *context = [CIContext contextWithOptions:nil];
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
    [self.view addSubview:anonimousFrame];
    
    
    [imgView setAlpha:0];
    [UIView animateWithDuration:.3 animations:^{
        
        [imgView setAlpha:1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            anonimousFrame.frame = CGRectMake(35, 75, 250, 350);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }];
    
    
    

}

-(IBAction)cancelComplaintProcess:(id)sender{
    
    [[self navigationController] popToViewController:rootViewC animated:YES];
    
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)onCloseAnonimousView:(id)sender{
    
    if([[name text] isEqualToString:@""] || [[name text] isEqualToString:@"Nombre"] || [[pLastName text] isEqualToString:@""] || [[pLastName text] isEqualToString:@"Apellido Paterno"] || [[mLastName text] isEqualToString:@""] || [[mLastName text] isEqualToString:@"Apellido Materno"] || [[email text] isEqualToString:@"Confirmar correo"] || ![self isValidEmail:[email text]]){
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Completa los campos"
                                                         message:@"Para continuar completa correctamente todos los campos de texto."
                                                        delegate:self
                                               cancelButtonTitle:@"Aceptar"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[name text] forKey:@"settings:name"];
        [defaults setObject:[name text] forKey:@"settings:pLname"];
        [defaults setObject:[name text] forKey:@"settings:mLname"];
        [defaults setObject:[name text] forKey:@"settings:email"];

    //**BLUR**//
    [self.view addSubview:anonimousFrame];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        anonimousFrame.frame = CGRectMake(35, 570, 250, 350);
        
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];        
    }];
    }
    
}

-(IBAction)sendComplaint:(id)sender{
    
    if([[description text] isEqualToString:@""] || [[date0 text] isEqualToString:@""] || [[date1 text] isEqualToString:@""] || [[date2 text] isEqualToString:@""]){
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Completa los campos"
                                                         message:@"Para continuar completa correctamente todos los campos de texto."
                                                        delegate:self
                                               cancelButtonTitle:@"Aceptar"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else{
        
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
        
        CIContext *context = [CIContext contextWithOptions:nil];
        cgImg = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[blurImg extent]];
        UIImage *outputImg = [UIImage imageWithCGImage:cgImg];
        
        //Add UIImageView to current view.
        UIView *blurView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [blurView setBackgroundColor:[UIColor colorWithWhite:0.05 alpha:0.5]];
        imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.image = outputImg;
        [imgView addSubview:blurView];
        [self.view addSubview:imgView];
        
        [imgView setAlpha:0];
        [UIView animateWithDuration:.3 animations:^{
            
            [imgView setAlpha:1];
            
        } completion:^(BOOL finished) {
            
            UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityView.center=self.view.center;
            [activityView startAnimating];
            [self.view addSubview:activityView];
            [self.view setUserInteractionEnabled:NO];
            [self saveComplaint];
            [self performSelector:@selector(showComplaintSended) withObject:nil afterDelay:3.0];
            
            
        }];
        
       
    }
    
    
}


-(void)saveComplaint{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[date0 text],[date1 text], [date2 text]];
    int random =  (arc4random() % 50000001) + 5000000;
    isAnonimus = [anonimousSwitch isOn];
    isPublic = [publicSwitch isOn];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:
                                [NSMutableArray arrayWithObjects:
                                [NSNumber numberWithInt: complaintSelection],
                                 [description text],
                                 date,
                                 [NSNumber numberWithDouble: coord.latitude],
                                 [NSNumber numberWithDouble: coord.longitude],
                                 [NSNumber numberWithBool:isAnonimus],
                                 [NSNumber numberWithBool:isPublic],
                                 [NSNumber numberWithBool:havePic],
                                 [NSNumber numberWithBool:haveVid],
                                 [NSNumber numberWithBool:haveAud],
                                 [NSNumber numberWithBool:haveWhitness],
                                 @"Recibida",
                                 [NSNumber numberWithInt: random],nil]
                                                             forKeys:
                                [NSMutableArray arrayWithObjects:
                                 @"type",
                                 @"description",
                                 @"date",
                                 @"latitude",
                                 @"longitude",
                                 @"isAnonimus",
                                 @"isPublic",
                                 @"havePic",
                                 @"haveVid",
                                 @"haveAud",
                                 @"haveWhit",
                                 @"status",
                                 @"folio",nil]];
    
    NSMutableArray *arrayC;
    NSMutableArray *arrayMC;
    
    if (![defaults arrayForKey:@"mycomplaints"]) {
        arrayMC = [[NSMutableArray alloc] initWithObjects:dictionary, nil];
        [defaults setObject:arrayMC forKey:@"mycomplaints"];
        [defaults synchronize];
    }
    else{
        arrayMC = [[defaults arrayForKey:@"mycomplaints"]mutableCopy];
        [arrayMC addObject:dictionary];
        [defaults setObject:arrayMC forKey:@"mycomplaints"];
        [defaults synchronize];
    }

    if(isPublic){
    if (![defaults arrayForKey:@"complaints"]) {
        arrayC = [[NSMutableArray alloc] initWithObjects:dictionary, nil];
        [defaults setObject:arrayC forKey:@"complaints"];
        [defaults synchronize];
    } else {
        arrayC = [[defaults arrayForKey:@"complaints"] mutableCopy];
        [arrayC addObject:dictionary];
        [defaults setObject:arrayC forKey:@"complaints"];
        [defaults synchronize];
    }
    }
    NSLog(@"%@", arrayC);
    NSLog(@"%@", arrayMC);
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:20/*((arc4random() % 1) + 40)*/];
    switch ([[[[defaults objectForKey:@"mycomplaints"] objectAtIndex:[[defaults objectForKey:@"mycomplaints"] count]-1] objectForKey:@"type"] integerValue]) {
        case 0:
            localNotification.alertBody = @"Su denuncia por Extorsión esta ahora en proceso.";
            break;
        case 1:
            localNotification.alertBody = @"Su denuncia por Soborno esta ahora en proceso.";
            break;
        case 2:
            localNotification.alertBody = @"Su denuncia por Fraude esta ahora en proceso.";
            break;
        case 3:
            localNotification.alertBody = @"Su denuncia por Peculado esta ahora en proceso.";
            break;
        case 4:
            localNotification.alertBody = @"Su denuncia por Colusión esta ahora en proceso.";
            break;
        case 5:
            localNotification.alertBody = @"Su denuncia por T.Influencias esta ahora en proceso.";
            break;
        case 6:
            localNotification.alertBody = @"Su denuncia por No Ético esta ahora en proceso.";
            break;
        case 7:
            localNotification.alertBody = @"Su denuncia por Otro esta ahora en proceso.";
            break;
            
        default:
            break;
    }
    
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    if([[defaults objectForKey:@"settings:myComplaintsStatusValue"] isEqualToString:@"on"])
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}


-(void)showComplaintSended{
    
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
        
    }    ComplaintStep3ViewController *viewController = (ComplaintStep3ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintStep3ViewController"];
    //do what you need to do when animation ends...
    [viewController setComplaintLocation:coord];
    [self.navigationController pushViewController:viewController animated:YES];
}




- (void)addPin:(UITapGestureRecognizer*)recognizer
{
    CGPoint tappedPoint = [recognizer locationInView:mapView];
    NSLog(@"Tapped At : %@",NSStringFromCGPoint(tappedPoint));
    coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    NSLog(@"lat  %f",coord.latitude);
    NSLog(@"long %f",coord.longitude);
    
    // add an annotation with coord
    // Some other stuff
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = @"Aquí sucedió";
    point.subtitle = @"";
    [mapView removeAnnotations:[mapView annotations]];
    [mapView addAnnotation:point];
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        mapInstruction.frame = CGRectMake(101, 570, 168, 48);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            complaintSelector.frame = CGRectMake(16, 91, 288,300);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    /*[UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        complaintSelector.frame = CGRectMake(16, 91, 288,300);
        
    } completion:^(BOOL finished) {
        
    }];*/

    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
    if([[name text] isEqualToString:@""])
        [name setText:@"Nombre"];
    if([[pLastName text] isEqualToString:@""])
        [pLastName setText:@"Apellido Paterno"];
    if([[mLastName text] isEqualToString:@""])
        [mLastName setText:@"Apellido Materno"];
    if([[email text] isEqualToString:@""])
        [email setText:@"Confirmar correo"];
    
}

-(void)setUserLocation:(CLLocationCoordinate2D) coordinat{
    
    coordinate = coordinat;
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
