//
//  EditAddressViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "AddressEntity.h"

extern NSString *const kSelectorVCStoryboardID;

@interface EditAddressViewController : XLFormViewController <XLFormViewControllerDelegate, XLFormDescriptorDelegate>

@property (nonatomic, strong) AddressEntity *address;

@end
