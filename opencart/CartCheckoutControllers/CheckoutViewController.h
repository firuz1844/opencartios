//
//  CheckoutViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 12.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "LoginViewController.h"


@interface CheckoutViewController : XLFormViewController <XLFormViewControllerDelegate, XLFormDescriptorDelegate, LoginViewControllerDelegate>

@end
