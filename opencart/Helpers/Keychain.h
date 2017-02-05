//
//  Keychain.h
//  opencart
//
//  Created by Firuz Narzikulov on 10.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface Keychain : NSObject {
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
}

@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end
