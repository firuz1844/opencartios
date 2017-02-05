//
//  ProfileDetailsViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 05.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ProfileDetailsTypeAddresses,
    ProfileDetailsTypeOrders,
    ProfileDetailsTypeAccount,
    ProfileDetailsTypeFavorites
} ProfileDetailsType;

@interface ProfileDetailsViewController : UITableViewController

@property (nonatomic, assign) ProfileDetailsType detailsType;

@end
