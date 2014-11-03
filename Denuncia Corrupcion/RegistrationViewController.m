//
//  StreamingViewController.m
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MenuViewController.h"
#import "ComplaintsViewController.h"

@interface RegistrationViewController (){
    
    IBOutlet UITextField *nickname;
    IBOutlet UITextField *password;
    IBOutlet UITextField *email;
    IBOutlet UIButton *loginButton;
    IBOutlet UIView *messageFrame;
    IBOutlet UILabel *messageTitle;
    IBOutlet UILabel *messageText;

    UIImageView *imgView;
    CGImageRef cgImg;
    CIContext *context;
    BOOL loginFlag;
    UIImageView *blurImageView;
    

}

@end

@implementation RegistrationViewController

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
    self.screenName = @"Registration";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[MenuViewController menuController] labelWithTitle:@"Registro"];
    [label setTextColor:[UIColor darkGrayColor]];
    self.navigationItem.titleView = label;
    
    UIImage *rightImage = [UIImage imageNamed:@"registroMenuButton.png"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    loginFlag = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"settings:user"]) {
        
        [nickname setText:[prefs objectForKey:@"settings:user"]];
        [password setText:[prefs objectForKey:@"settings:password"]];
        [email setText:[prefs objectForKey:@"settings:email"]];
        
        [nickname setEnabled:NO];
        [password setEnabled:NO];
        [email setEnabled:NO];
        [loginButton setEnabled:NO];
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Ya te has registrado"
                                                         message:@"Si deseas cerrar sesión ve a Configuración"
                                                        delegate:self
                                               cancelButtonTitle:@"Aceptar"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else{
        [nickname setEnabled:YES];
        [password setEnabled:YES];
        [email setEnabled:YES];
    }
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
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs objectForKey:@"settings:user"]) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"¡No se ha registrado!"
                                                         message:@"Complete su registro para poder usar Denuncia Corrupción"
                                                        delegate:self
                                               cancelButtonTitle:@"Aceptar"
                                               otherButtonTitles: nil];
        [alert show];
    } else {
        blurImageView = [self loadBlurView];
        [blurImageView setAlpha:0];
        [self.view addSubview:blurImageView];
        [UIView animateWithDuration:0.4 animations:^{
            [blurImageView setAlpha:1];
        }];
        [[MenuViewController menuController] showMenu];
        
    }

}

-(void)hideMenuController{
    [blurImageView setAlpha:1];
    [UIView animateWithDuration:0.4 animations:^{
        [blurImageView setAlpha:0];
    } completion:^(BOOL fin){
        [blurImageView removeFromSuperview];
    }];
}




-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
    if([[nickname text] isEqualToString:@""])
       [nickname setText:@"Seudónimo"];
    if([[password text] isEqualToString:@""])
        [password setText:@"password"];
    if([[email text] isEqualToString:@""])
        [email setText:@"Correo electrónico"];
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

-(void)setBlurOnCurrentView{
    
    [loginButton setEnabled:NO];
    
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
    [self.view addSubview:messageFrame];
    
    [imgView setAlpha:0];
    [UIView animateWithDuration:.3 animations:^{
        
        [imgView setAlpha:1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            messageFrame.frame = CGRectMake(35, 115, 250, 250);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }];
    
    
    
    
}

-(IBAction)onCloseGlosaryView:(id)sender{
    
    
    //**BLUR**//
    [self.view addSubview:messageFrame];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        messageFrame.frame = CGRectMake(35, 570, 250, 250);
        
    } completion:^(BOOL finished) {
        if(loginFlag){
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
        ComplaintsViewController *viewController = (ComplaintsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ComplaintsViewController"];
        //do what you need to do when animation ends...
        //[[super navigationController] pushViewController:viewController animated:YES];
        [[[MenuViewController menuController] delegate] selectedViewController:viewController];
            //[[MenuViewController menuController] hideMenu];
        }
        else{
            [imgView removeFromSuperview];
            [loginButton setEnabled:YES];
        }
        
    }];
    
    
}

-(IBAction)loginTask:(id)sender{
    
    if([[nickname text] isEqualToString:@""] || [[nickname text] isEqualToString:@"Seudónimo"] || [[password text] isEqualToString:@""] || [[password text] isEqualToString:@"Contraseña"] || [[email text] isEqualToString:@""] || [[email text] isEqualToString:@"Correo electrónico"] || ![self isValidEmail:[email text]]){
        
        [messageTitle setText:@"¡Error!"];
        [messageText setText:@"Completa correctamente todos los campos."];
        
        
        
        loginFlag = NO;
    }
    else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if (![prefs objectForKey:@"settings:user"]) {
            [prefs setObject:[nickname text] forKey:@"settings:user"];
            [prefs setObject:[password text] forKey:@"settings:password"];
            [prefs setObject:[email text] forKey:@"settings:email"];
            [prefs setObject:@"on" forKey:@"settings:myComplaintsStatusValue"];
        } else {
            // El usuario ya está registrado.
        }
        [messageTitle setText:@"¡Registro exitoso!"];
        [messageText setText:@"Se han registrado correctamente tus datos."];
        loginFlag = YES;
    }
    
    [self setBlurOnCurrentView];
    
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
