//
//  PlaneViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "ProcedureViewController.h"
#import "MenuViewController.h"
#import "ProcedureChildViewController.h"


@interface ProcedureViewController (){
    UIImageView *blurImageView;
    CGImageRef cgImg;
    CIContext *context;
}

@end

@implementation ProcedureViewController

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
    self.screenName = @"Procedure";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Procedimiento"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"procedimientosMenuButton.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    //**Pager Init**//
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ProcedureChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    //**Pager Init**//
    
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

- (ProcedureChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ProcedureChildViewController *childViewController = [[ProcedureChildViewController alloc] initWithNibName:@"ProcedureChildViewController" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ProcedureChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ProcedureChildViewController *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
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
