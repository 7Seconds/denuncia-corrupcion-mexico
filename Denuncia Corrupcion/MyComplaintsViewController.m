//
//  SponsorsViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "MyComplaintsViewController.h"
#import "MenuViewController.h"
#import "MyComplaintsDetailViewController.h"

@interface MyComplaintsViewController (){
    
    IBOutlet UILabel *username;
    NSMutableArray *complaints;
    
    IBOutlet UILabel *totalComplaintsLabel;
    IBOutlet UILabel *receivedComplaintsLabel;
    IBOutlet UILabel *inprocessComplaintsLabel;
    IBOutlet UILabel *resolvedComplaintsLabel;
    
    NSInteger receibedComplaints;
    NSInteger inprocessComplaints;
    NSInteger resolvedComplaints;
    UIImageView *blurImageView;
    CGImageRef cgImg;
    CIContext *context;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyComplaintsViewController

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
    self.screenName = @"MyComplaints";
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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"settings:user"])
        [username setText:[prefs objectForKey:@"settings:user"]];
    else
        [username setText:@""];
    
    receibedComplaints = 0;
    inprocessComplaints = 0;
    resolvedComplaints = 0;

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    complaints = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"mycomplaints"]];
    
    [totalComplaintsLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[complaints count]]];
    
    for(NSDictionary *dict in complaints){
        if([[dict objectForKey:@"status"] isEqualToString:@"Recibida"])
            receibedComplaints+=1;
        else if([[dict objectForKey:@"status"] isEqualToString:@"En proceso"])
            inprocessComplaints+=1;
        
    }
    
    [receivedComplaintsLabel setText:[NSString stringWithFormat:@"%ld",(long)receibedComplaints]];
    [inprocessComplaintsLabel setText:[NSString stringWithFormat:@"%ld",(long)inprocessComplaints]];
    
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
    } completion:^(BOOL fin){
        [blurImageView removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UILabel *labelDate = (UILabel *)[cell viewWithTag:6];
    UILabel *labelType = (UILabel *)[cell viewWithTag:2];
    UILabel *labelSumm = (UILabel *)[cell viewWithTag:3];
    UILabel *labelStatus = (UILabel *)[cell viewWithTag:4];
    
    UIImageView *imageType = (UIImageView *)[cell viewWithTag:1];
    
    [labelDate setText:[[complaints objectAtIndex:indexPath.row] objectForKey:@"date"]];
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
    
    [labelSumm setText:[[complaints objectAtIndex:indexPath.row] objectForKey:@"description"]];
    [labelStatus setText:[[complaints objectAtIndex:indexPath.row] objectForKey:@"status"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    MyComplaintsDetailViewController *viewController = (MyComplaintsDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyComplaintsDetailViewController"];
    [viewController setComplaintIndex:[indexPath row]];
    [[self navigationController] pushViewController:viewController animated:YES];
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
