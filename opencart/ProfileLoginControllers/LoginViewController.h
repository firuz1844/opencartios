//
//  LoginViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)canceledLoginVC;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;

@end
