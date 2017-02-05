//
//  NewsModel.m
//  opencart
//
//  Created by Firuz Narzikulov on 9/4/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "NewsModel.h"
#import "VKSdk.h"

@implementation NewsModel

- (instancetype) initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        self.text = dict[@"text"];
        NSTimeInterval interval = [dict[@"date"] doubleValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:interval];
        self.attachments = dict[@"attachments"];
        NSMutableArray *attachmentsMutable = [[NSMutableArray alloc] initWithCapacity:self.attachments.count];
        for (NSDictionary *obj in self.attachments) {
            VKPhoto *photo = [[VKPhoto alloc] initWithDictionary:obj[@"photo"]];
            if (photo)
                [attachmentsMutable addObject:photo];
        }
        self.attachments = attachmentsMutable;
        if (dict[@"copy_history"]) {
            self.child = [[NewsModel alloc] initWithDict:[dict[@"copy_history"] firstObject]];
        }
    }
    return self;
}

- (NSString*)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY, hh:mm"];
    return [formatter stringFromDate:self.date];
}

- (NSString*)title {
    if (!_title) {
        NSString *title = @"";
        if (self.text && self.text.length > 0) {
            title = [[self.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] firstObject];
            self.text = [self.text substringFromIndex:title.length];
            self.text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if (!self.text || self.text.length < 1) {
                self.text = title;
            }
        }
        _title = title;
    }
    return _title;
}
@end
