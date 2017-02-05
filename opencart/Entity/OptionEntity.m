//
//  OptionEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "OptionEntity.h"
#import "OptionValueEntity.h"

@implementation OptionEntity

- (NSDictionary *)attributesKeyMap {
    return @{
             @"type":@"type",
             @"required":@"required",
             @"product_option_id":@"product_option_id",
             @"option_id":@"option_id",
             @"name":@"name",
             @"value":@"value"
             };
}

- (NSDictionary *)children {
    return @{
             @"option_value->option_value":[OptionValueEntity new]
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self startObserving];
    }
    return self;
}

- (void)startObserving {
    [self addObserver:self forKeyPath:@"option_value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"option_value"])
    {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if ([newValue isKindOfClass:[NSArray<OptionValueEntity*> class]]) {
            for (OptionValueEntity *valueEntity in (NSArray*)newValue) {
                valueEntity.parent = self;
            }
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"option_value"];
}

@end
