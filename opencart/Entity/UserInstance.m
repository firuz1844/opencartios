//
//  UserInstance.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInstance.h"

#import "RestClient.h"
#import "Keychain.h"
#import "SVProgressHUD.h"


NSString * const kLoginStatusChanged = @"kLoginStatusChanged";
static NSString * const kUserDict = @"userDict";

@interface UserInstance()

@end

@implementation UserInstance

+ (UserInstance *)sharedInstance
{
    static UserInstance *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary *)attributesKeyMap {
    return @{@"session":@"session",
             @"customer_id":@"customer_id",
             @"store_id":@"store_id",
             @"firstname":@"firstname",
             @"lastname":@"lastname",
             @"email":@"email",
             @"telephone":@"telephone",
             @"fax":@"fax",
             @"salt":@"salt",
             @"cart":@"cart",
             @"wishlist":@"wishlist",
             @"newsletter":@"newsletter",
             @"address_id":@"address_id",
             @"customer_group_id":@"customer_group_id",
             @"ip":@"ip",
             @"status":@"status",
             @"approved":@"approved",
             @"token":@"token",
             @"date_added":@"date_added"
             };
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] postEntity:[UserInstance new] atPath:@"/api/rest/login" keyPath:@"data" withParameters:@{@"email":username, @"password":password} success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            UserInstance *user = [(NSArray*)result firstObject];
            if ([user isKindOfClass:[UserInstance class]]) {
                [weakSelf loadDataFromAnotherUser:user];
                self.loggedIn = YES;
                NSLog(@"Authorized!");
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChanged object:nil];
            } else {
                NSAssert(NO, @"Error in login");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    if (self.isSavePassword) {
        [self savePassword:password];
    }
}

- (void)logout {
    
    __weak typeof(self) weakSelf = self;
    
    [[RestClient sharedInstance] postEntity:[MappedEntity new] atPath:@"/api/rest/logout" keyPath:nil withParameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            MappedEntity *ent = [(NSArray*)result firstObject];
            if (!ent.success) {
                [SVProgressHUD showErrorWithStatus:ent.errorMessage];
            } else {
                self.loggedIn = NO;
                [weakSelf resetUser];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChanged object:nil];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)saveUser {
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    if (_customer_id) {
        [userDict setObject:_customer_id forKey:@"customer_id"];
    }
    if (_store_id) {
        [userDict setObject:_store_id forKey:@"store_id"];
    }

    if (_firstname) {
        [userDict setObject:_firstname forKey:@"firstname"];
    }

    if (_lastname) {
        [userDict setObject:_lastname forKey:@"lastname"];
    }

    if (_email) {
        [userDict setObject:_email forKey:@"email"];
    }

    if (_telephone) {
        [userDict setObject:_telephone forKey:@"telephone"];
    }

    if (_fax) {
        [userDict setObject:_fax forKey:@"fax"];
    }

    if (_salt) {
        [userDict setObject:_salt forKey:@"salt"];
    }

    if (_cart) {
        [userDict setObject:_cart forKey:@"cart"];
    }

    if (_wishlist) {
        [userDict setObject:_wishlist forKey:@"wishlist"];
    }

    if (_newsletter) {
        [userDict setObject:_newsletter forKey:@"newsletter"];
    }

    if (_address_id) {
        [userDict setObject:_address_id forKey:@"address_id"];
    }

    if (_customer_group_id) {
        [userDict setObject:_customer_group_id forKey:@"customer_group_id"];
    }

    if (_ip) {
        [userDict setObject:_ip forKey:@"ip"];
    }

    if (_status) {
        [userDict setObject:_status forKey:@"status"];
    }

    if (_approved) {
        [userDict setObject:_approved forKey:@"approved"];
    }

    if (_token) {
        [userDict setObject:_token forKey:@"token"];
    }

    if (_date_added) {
        [userDict setObject:_date_added forKey:@"date_added"];
    }
    
    if (_loggedIn) {
        [userDict setObject:@(_loggedIn) forKey:@"loggedIn"];
    }

    if (_session) {
        [userDict setObject:_session forKey:@"session"];
    }

    [userDict setObject:@(self.isSavePassword) forKey:@"savePassword"];
    [userDict setObject:[NSDate date] forKey:@"saveDate"];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDict];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDict];
}

- (void)setSavePassword:(BOOL)savePassword {
    _savePassword = savePassword;
    [self saveUser];
}

- (void)loadUser {
    
    NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDict];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];

    _customer_id = userDict[@"customer_id"];
    _store_id = userDict[@"store_id"];
    _firstname = userDict[@"firstname"];
    _lastname = userDict[@"lastname"];
    _email = userDict[@"email"];
    _telephone = userDict[@"telephone"];
    _fax = userDict[@"fax"];
    _salt = userDict[@"salt"];
    _cart = userDict[@"cart"];
    _wishlist = userDict[@"wishlist"];
    _newsletter = userDict[@"newsletter"];
    _address_id = userDict[@"address_id"];
    _customer_group_id = userDict[@"customer_group_id"];
    _ip = userDict[@"ip"];
    _status = userDict[@"status"];
    _approved = userDict[@"approved"];
    _token = userDict[@"token"];
    _date_added = userDict[@"date_added"];
    _loggedIn = [userDict[@"loggedIn"] boolValue];
    _session = userDict[@"session"];
    _savePassword = [userDict[@"savePassword"] boolValue];
}

- (void)savePassword:(NSString*)password {
    if (password && password.length > 0) {
        Keychain *keychain = [Keychain new];
        [keychain mySetObject:password forKey:(__bridge id)kSecValueData];
    }
}

- (NSString*)password {
    Keychain *keychain = [Keychain new];
    NSString *ps = [keychain myObjectForKey:(__bridge id)kSecValueData];
    return ps;
}

- (void)relogin {
    if (self.email && [self password] && [self password].length>0) {
        [self loginWithUsername:self.email andPassword:[self password]];
    }
}

- (void)forgotPassword:(NSString*)email {
    [[RestClient sharedInstance] postEntity:[MappedEntity new] atPath:@"/api/rest/forgotten" keyPath:@"" withParameters:@{@"email":email} success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            MappedEntity *ent = [(NSArray*)result firstObject];
            if (!ent.success) {
                [SVProgressHUD showErrorWithStatus:ent.errorMessage];
            }
        }

    } failure:^(NSError *error) {
    
    }];
}

- (void)resetUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDict];
    _customer_id = nil;
    _store_id = nil;
    _firstname = nil;
    _lastname = nil;
    _email = nil;
    _telephone = nil;
    _fax = nil;
    _salt = nil;
    _cart = nil;
    _wishlist = nil;
    _newsletter = nil;
    _address_id = nil;
    _customer_group_id = nil;
    _ip = nil;
    _status = nil;
    _approved = nil;
    _token = nil;
    _date_added = nil;
    _loggedIn = NO;
    _session = nil;
    _savePassword = NO;
    Keychain *keychain = [Keychain new];
    [keychain mySetObject:@"" forKey:(__bridge id)kSecValueData];
}

- (void)loadDataFromAnotherUser:(UserInstance*)user {
    @try {
        [self setValuesForKeysWithDictionary:[user propertiesAndValues]];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    [self saveUser];
}

@end
