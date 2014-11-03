//
//  MenuViewController.h
//  7sEvents
//
//  Created by 7Seconds Technologies on 16/06/14.
//  Copyright (c) 2014 7Seconds Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate;

@interface MenuViewController : UIViewController

- (void)showMenu;
- (void)hideMenu;
- (UILabel *)labelWithTitle:(NSString *)title;
+ (MenuViewController *)menuController;

@property id<MenuViewControllerDelegate> delegate;

@end

@protocol MenuViewControllerDelegate <NSObject>

@optional
- (void)selectedViewController:(id)viewController;
-(void)hideMenuController;

@end