//
//  APPChildViewController.h
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcedureChildViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UITextView *text1;
@property (strong, nonatomic) IBOutlet UITextView *text2;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;


@end
