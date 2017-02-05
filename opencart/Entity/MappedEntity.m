//
//  MappedEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 04.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "MappedEntity.h"

@implementation MappedEntity

- (NSDictionary *)attributesKeyMap {
    return @{
             @"success":@"success",
             @"error":@"error"
             };
}

- (NSString *)nestedArbitraryKey {
    return nil;
}

- (NSDictionary *)children {
//      Example
//    @{
//      @"fromKey->toKey":[SubClassOfMappedEntity new],
//      @"->toKey":[SubClassOfMappedEntity new]
//      };

    return nil;
}

- (NSDictionary*)propertiesAndValues {
    NSMutableDictionary *propsValues = [NSMutableDictionary new];
    
    for (NSString *key in [self attributesKeyMap].allKeys) {
        SEL selector = NSSelectorFromString(key);
        if ([self respondsToSelector:selector]) {
            IMP imp = [self methodForSelector:selector];
            id (*func)(id, SEL) = (void *)imp;
            id value = self ? func(self, selector) : nil;
            
            if (value) {
                [propsValues setObject:value forKey:key];
            }
        }
    }
    
    return propsValues;
}

- (NSString*)errorMessage {
    NSString *message = @"Error: please try later! ©🤖";
    if ([self.error isKindOfClass:[NSDictionary class]]) {
        message = [[(NSDictionary*)self.error allValues] componentsJoinedByString:@"\n"];
    }
    if ([self.error isKindOfClass:[NSArray class]]) {
        message = [(NSArray*)self.error componentsJoinedByString:@"\n"];
    }
    if ([self.error isKindOfClass:[NSString class]]) {
        message = (NSString*)self.error;
    }
    return message;
}

- (NSDictionary*)jsonDictionary {
    NSMutableDictionary *json = [NSMutableDictionary new];
    for (NSString *key in [self keysForPUT]) {
        
        NSArray *keyComps = [key componentsSeparatedByString:@"."];
        
        NSString *last = [keyComps lastObject];
        NSAssert([last isKindOfClass:[NSString class]], @"KeyPath component must be a string!");
        
        NSString *toKey = [[last componentsSeparatedByString:@"->"] lastObject];
        NSAssert([toKey isKindOfClass:[NSString class]], @"KeyPath component must be a string!");
        
        id value = [self extractValueFrom:self atKeyPath:keyComps];
        if (value) {
            [json setObject:value forKey:toKey];
        }
    }
    return json;
}

- (id)extractValueFrom:(MappedEntity*)object atKeyPath:(NSArray*)keyComps {
    
    if (keyComps.count > 0) {
        
        NSString *first = [keyComps firstObject];
        NSMutableArray *remain = [keyComps mutableCopy];
        [remain removeObject:first];
        
        NSString *fromKey = [[first componentsSeparatedByString:@"->"] firstObject];

        NSAssert([first isKindOfClass:[NSString class]], @"KeyPath component must be a string!");
        
        SEL selector = NSSelectorFromString(fromKey);
        if ([self respondsToSelector:selector]) {
            IMP imp = [self methodForSelector:selector];
            id (*func)(id, SEL) = (void *)imp;
            id value = self ? func(self, selector) : nil;
            
            if (value && [value isKindOfClass:[MappedEntity class]]) {
                return [value extractValueFrom:value atKeyPath:remain];
            }
            return value;
        }
    }
    
    return nil;
}

- (NSArray*)keysForPUT {
    NSLog(@"Define keys for creating PUT json object in %@", self.class);
    return nil;
}

@end
