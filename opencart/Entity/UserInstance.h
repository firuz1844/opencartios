//
//  UserInstance.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

extern NSString * const kLoginStatusChanged;

@interface UserInstance : MappedEntity

@property (nonatomic, retain) NSString *session;

+ (UserInstance *)sharedInstance;

@property (nonatomic, strong) NSString *customer_id;
@property (nonatomic, strong) NSString *store_id;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *cart;
@property (nonatomic, strong) NSString *wishlist;
@property (nonatomic, strong) NSString *newsletter;
@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *customer_group_id;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *approved;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *date_added;

@property (nonatomic, assign, getter=isSavePassword) BOOL savePassword;
@property (nonatomic, assign, getter=isLoggedIn) BOOL loggedIn;

- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password;
- (void)logout;

- (void)saveUser;
- (void)loadUser;
- (void)relogin;
- (NSString*)password;
- (void)forgotPassword:(NSString*)email;


@end
