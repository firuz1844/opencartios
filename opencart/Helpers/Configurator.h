//
//  Configurator.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configurator : NSObject

+(NSString*) getDefaultRootParentUid; //Default = 0
+(NSString*) getApiKey;
+(NSString*) getDefaultLanguage; //en, ru, de
+(NSString*) getStoreName;
+(NSString*) getStorePhone;
+(NSString*) getDefaultCountry;
+(NSString*) getDefaultCity;

//Image processor
+ (UIImage*) transparentImage:(UIImage*)image;

//Design colors
+(NSString*) getBackgroundPatternName;
+(NSString*) getDialogsBackgroundPatternName;
+(UIBarStyle) getStatusBarStyle;

+(UIColor*) getStyleColor;
+(UIColor*) getStyleTranslucentColor;
+(UIColor*) getContrastedColor;
+(UIColor*) getBorderColor;
+(UIColor*) getBorderLightColor;

//Urls

+(NSString*) getStoreBaseUrl;
+(NSString*) getStoreAPIUrl;
+(NSString*) getStoreImageCacheUrl;

//Catalog urls
+(NSString*) getUrlCategoriesByParentUid; //apiUrl + catsByParentUrl + ParentUid
+(NSString*) getUrlProductsByCategoryUid; //apiUrl + this + categoryUid
+(NSString*) getUrlProductByUid; //apiUrl + this + productUid

//User urls
+(NSString*) getUrlSession;
+(NSString*) getUrlRegisterGuestUser:(NSString**)HTTPMethod;
+(NSString*) getUrlRegisterUser:(NSString**)HTTPMethod;
+(NSString*) getUrlLoginUser:(NSString**)HTTPMethod;
+(NSString*) getUrlLogoutUser:(NSString**)HTTPMethod;
+(NSString*) getUrlCheckUser;

//Shipping
+(NSString*) getUrlSetGuestShippingAddress:(NSString**)HTTPMethod;
+(NSString*) getUrlGetShippingMethods;
+(NSString*) getUrlSelectShippingMethod:(NSString**)HTTPMethod;
+(NSString*) getUrlAddNewShippingAddress:(NSString**)HTTPMethod;
+(NSString*) getUrlSelectShippingAddressForOrder:(NSString**)HTTPMethod;
+(NSString*) getUrlGetShippingAddresses;

//Payment methods
+(NSString*) getUrlAddNewPaymentAdress:(NSString**)HTTPMethod;
+(NSString*) getUrlGetPaymentAdresses;
+(NSString*) getUrlSelectPaymentAddressForOrder:(NSString**)HTTPMethod;
+(NSString*) getUrlGetPaymentMethod;
+(NSString*) getUrlSelectPaymentMethod:(NSString**)HTTPMethod;

//cartUrls
+(NSString*) getUrlAddProductToCart:(NSString**)HTTPMethod;
+(NSString*) getUrlUpdateProductQuantityInCart:(NSString**)HTTPMethod;
+(NSString*) getUrlDeleteProductFromCart:(NSString**)HTTPMethod;
+(NSString*) getUrlGetCart:(NSString**)HTTPMethod;
+(NSString*) getUrlSaveCart:(NSString**)HTTPMethod;
+(NSString*) getUrlConfirmCart:(NSString**)HTTPMethod;
+(NSString*) getUrlSimpleSaveCart:(NSString**)HTTPMethod;
+(NSString*) getUrlSimpleConfirmCart:(NSString**)HTTPMethod;


//Other methods
+(NSString*) getDefaultCurrency;

+(NSDictionary*) getArrayOfProductPropertiesToShowInProductView;
+(NSDictionary*) getArrayOfProductArrayPropertiesToShowInProductView;

+(NSString*)localizedStringForKey:(NSString*) key;
+(void)applyDesignStyleForViewController:(UIViewController*)viewController;

@end
