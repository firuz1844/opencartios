//
//  RestClient.m
//  opencart
//
//  Created by Firuz Narzikulov on 04.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "RestClient.h"
#import <RestKit/RestKit.h>

#import "Configurator.h"
#import "UserInstance.h"

// Superclass of all entities to parse
#import "MappedEntity.h"

@interface RestClient()

@property (nonatomic, strong) RKObjectManager *objectManager;

@end
@implementation RestClient

+ (instancetype)sharedInstance {
    static RestClient *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[self alloc] init];
        [inst setup];
    });
    return inst;
}

- (void)setup
{
    NSURL *baseURL = [NSURL URLWithString:[Configurator getStoreBaseUrl]];
    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    [client setDefaultHeader:@"X-Oc-Merchant-Id" value:[Configurator getApiKey]];
    [client setDefaultHeader:@"X-Oc-Session" value:[UserInstance sharedInstance].session];

    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKLogConfigureByName("RestKit", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
}

- (void)loadEntities:(MappedEntity*)entity
              atPath:(NSString*)path
             keyPath:(NSString*)keyPath
      withParameters:(NSDictionary*)queryParameters
             success:(void (^)(id result))success
             failure:(void (^)(NSError *error))failure
{
    
    RKObjectMapping *parentMapping = [RKObjectMapping mappingForClass:[entity class]];
    
    [parentMapping addAttributeMappingFromKeyOfRepresentationToAttribute:[entity nestedArbitraryKey]];
    [parentMapping addAttributeMappingsFromDictionary:[entity attributesKeyMap]];

    [self addChildrenMappingsForParentMapping:parentMapping forEntity:entity];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:parentMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:keyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self.objectManager getObjectsAtPath:path
                              parameters:queryParameters
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     NSLog(@"%@", [NSString stringWithUTF8String:[[[operation HTTPRequestOperation] responseData] bytes]]);
                                     success([mappingResult.array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                                         return [evaluatedObject isKindOfClass:[entity class]];
                                     }]]);
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     failure(error);
                                 }];
}

- (void)deleteEntity:(MappedEntity*)entity
              atPath:(NSString*)path
      withParameters:(NSDictionary*)queryParameters
             success:(void (^)(id result))success
             failure:(void (^)(NSError *error))failure {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[entity class]];
    [mapping addAttributeMappingsFromDictionary:[entity attributesKeyMap]];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodDELETE
                                            pathPattern:nil
                                                keyPath:@"data"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self.objectManager deleteObject:entity
                                path:path
                          parameters:queryParameters
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 success(mappingResult.array);
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                 failure(error);
                             }];

}

- (void)postEntity:(MappedEntity*)entity
            atPath:(NSString*)path
           keyPath:(NSString*)keyPath
    withParameters:(NSDictionary*)queryParameters
           success:(void (^)(id result))success
           failure:(void (^)(NSError *error))failure {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[entity class]];
    [mapping addAttributeMappingsFromDictionary:[entity attributesKeyMap]];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:keyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self.objectManager postObject:entity
                              path:path
                        parameters:queryParameters
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               success(mappingResult.array);
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               failure(error);
                           }];

}

- (void)putEntity:(MappedEntity*)entity
           atPath:(NSString*)path
          keyPath:(NSString*)keyPath
   withParameters:(NSDictionary*)queryParameters
          success:(void (^)(id result))success
          failure:(void (^)(NSError *error))failure {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[entity class]];
    [mapping addAttributeMappingsFromDictionary:[entity attributesKeyMap]];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodPUT
                                            pathPattern:nil
                                                keyPath:keyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self.objectManager putObject:entity
                              path:path
                        parameters:queryParameters
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               success(mappingResult.array);
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               failure(error);
                           }];
    
}

#pragma mark - Helper methods

- (void)addChildrenMappingsForParentMapping:(RKObjectMapping*)parentMapping
                                 forEntity:(MappedEntity*)entity {
    if ([entity children]) {
        for (NSString *key in [entity children].allKeys) {
            NSString *fromKey = [[key componentsSeparatedByString:@"->"] firstObject];
            if (fromKey.length == 0) fromKey = nil;
            NSString *toKey = [[key componentsSeparatedByString:@"->"] lastObject];
            if (toKey.length == 0) toKey = nil;
            MappedEntity *child = [[entity children] objectForKey:key];
            
            RKObjectMapping *childMapping = [RKObjectMapping mappingForClass:[child class]];
            [childMapping addAttributeMappingsFromDictionary:[child attributesKeyMap]];
            
            [self addChildrenMappingsForParentMapping:childMapping forEntity:child];
            
            [parentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:fromKey
                                                                                          toKeyPath:toKey
                                                                                        withMapping:childMapping]];
            
        }
    }

}

@end
