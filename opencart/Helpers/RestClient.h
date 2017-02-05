//
//  RestClient.h
//  opencart
//
//  Created by Firuz Narzikulov on 04.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Superclass of all entities
@class MappedEntity;

@interface RestClient : NSObject

+ (instancetype)sharedInstance;

- (void)loadEntities:(MappedEntity*)entity
              atPath:(NSString*)path
             keyPath:(NSString*)keyPath
      withParameters:(NSDictionary*)queryParameters
             success:(void (^)(id result))success
             failure:(void (^)(NSError *error))failure;

- (void)deleteEntity:(MappedEntity*)entity
              atPath:(NSString*)path
      withParameters:(NSDictionary*)queryParameters
             success:(void (^)(id result))success
             failure:(void (^)(NSError *error))failure;

- (void)postEntity:(MappedEntity*)entity
            atPath:(NSString*)path
           keyPath:(NSString*)keyPath
    withParameters:(NSDictionary*)queryParameters
           success:(void (^)(id result))success
           failure:(void (^)(NSError *error))failure;

- (void)putEntity:(MappedEntity*)entity
           atPath:(NSString*)path
          keyPath:(NSString*)keyPath
   withParameters:(NSDictionary*)queryParameters
          success:(void (^)(id result))success
          failure:(void (^)(NSError *error))failure;

@end
