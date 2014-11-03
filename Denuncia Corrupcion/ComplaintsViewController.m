//
//  InfoViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "ComplaintsViewController.h"
#import "MenuViewController.h"
#import "ComplaintStep1ViewController.h"
#import "MyComplaintsViewController.h"

@interface ComplaintsViewController ()
{
    IBOutlet UIButton *glosaryButton;
    IBOutlet UIView *glosaryFrame;
    UIImageView *imgView;
    CGImageRef cgImg;
    CIContext *context;
    UIImageView *blurImageView;
    
    NSMutableArray *complaints;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ComplaintsViewController

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
    self.screenName = @"Complaints";
}


-(IBAction)complaintNow :(id)sender{
        
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
        
    }    ComplaintStep1ViewController * viewController = (ComplaintStep1ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintStep1ViewController"];
    [viewController setRootViewController:self];
    [[self navigationController] pushViewController:viewController animated:YES];
    
    
}
-(IBAction)myComplaints :(id)sender{
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
        
    }    id viewController = (MyComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyComplaintsViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Denuncias"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"misdenunciasMenuButton.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    [glosaryFrame removeFromSuperview];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    complaints = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"complaints"]];
    [self setTitle:@" "];
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
        NSLog(@"poniendo alpha al blur");
    } completion:^(BOOL fin){
        [blurImageView removeFromSuperview];
        NSLog(@"quitando el blur de la vista");
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [complaints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComplaintCell"];
    
    UILabel *labelDate = (UILabel *)[cell viewWithTag:1];
    UILabel *labelDesc = (UILabel *)[cell viewWithTag:2];
    UILabel *labelType = (UILabel *)[cell viewWithTag:3];
    UIImageView *imageType = (UIImageView *)[cell viewWithTag:4];
    
    switch ([[[complaints objectAtIndex:indexPath.row] objectForKey:@"type"] integerValue]) {
        case 0:
            [labelType setText: @"Extorsión"];
            [imageType setImage:[UIImage imageNamed:@"extorsionButton.png"]];
            break;
        case 1:
            [labelType setText:@"Soborno"];
            [imageType setImage:[UIImage imageNamed:@"sobornoButton.png"]];
            break;
        case 2:
            [labelType setText:@"Fraude"];
            [imageType setImage:[UIImage imageNamed:@"fraudeButton.png"]];
            break;
        case 3:
            [labelType setText:@"Peculado"];
            [imageType setImage:[UIImage imageNamed:@"peculadoButton.png"]];
            break;
        case 4:
            [labelType setText:@"Colusión"];
            [imageType setImage:[UIImage imageNamed:@"colusionButton.png"]];
            break;
        case 5:
            [labelType setText:@"T.Influencias"];
            [imageType setImage:[UIImage imageNamed:@"tinfluenciasButton.png"]];
            break;
        case 6:
            [labelType setText:@"No Ético"];
            [imageType setImage:[UIImage imageNamed:@"noeticoButton.png"]];
            break;
        case 7:
            [labelType setText:@"Otro"];
            [imageType setImage:[UIImage imageNamed:@"otroButton.png"]];
            break;
            
        default:
            break;
    }
    
    [labelDate setText:[[complaints objectAtIndex:indexPath.row] objectForKey:@"date"]];
    [labelDesc setText:[[complaints objectAtIndex:indexPath.row] objectForKey:@"description"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
