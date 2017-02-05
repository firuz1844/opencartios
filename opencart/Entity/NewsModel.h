//
//  NewsModel.h
//  opencart
//
//  Created by Firuz Narzikulov on 9/4/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *attachments;
@property (nonatomic, strong) NewsModel *child;

- (instancetype) initWithDict:(NSDictionary*)dict;

@end
