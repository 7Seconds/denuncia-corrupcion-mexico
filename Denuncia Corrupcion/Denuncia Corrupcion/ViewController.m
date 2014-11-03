//
//  ViewController.m
//  Denuncia Corrupcion
//  Created by Sergio Arizaga on 10/9/14.
//  Copyright (c) 2014 7seconds. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "ComplaintsViewController.h"
#import "RegistrationViewController.h"

@interface ViewController (){
    
    UIViewController *rootController;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setTintColor:[UIColor grayColor]];
    
    [[[self navigationController] view] addSubview:[[MenuViewController menuController] view]];
    [[MenuViewController menuController] setDelegate:self];
    [[MenuViewController menuController] hideMenu];
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

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs objectForKey:@"settings:user"]) {
        RegistrationViewController *infoVC = (RegistrationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
        [[self navigationController] pushViewController:infoVC animated:NO];
        rootController = infoVC;
    } else {
        ComplaintsViewController *infoVC = (ComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintsViewController"];
        [[self navigationController] pushViewController:infoVC animated:NO];
        rootController = infoVC;
        // El usuario ya está registrado.
    }
    
}

-(void)hideMenuController{
    
    if([rootController respondsToSelector:@selector(hideMenuController)]){
        [rootController performSelector:@selector(hideMenuController) withObject:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"ViewController";
}


- (void)selectedViewController:(id)viewController
{
    NSLog(@"Selected ViewController: %@",viewController);
    NSLog(@"Selected RootViewController: %@",[[[UIApplication sharedApplication] keyWindow]rootViewController]);
    rootController = viewController;
    [[MenuViewController menuController] hideMenu];
    [[self navigationController] popToRootViewControllerAnimated:NO];
    [[self navigationController] pushViewController:viewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
