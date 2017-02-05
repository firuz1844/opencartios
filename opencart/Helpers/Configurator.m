//
//  Configurator.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "Configurator.h"

@implementation Configurator


//custem settings dictionary
NSDictionary* customSettings(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CustomerSettings"];
}


+(NSString*) getDefaultRootParentUid{
    return @"0";
}

+(NSString*) getApiKey {
    //    NSDictionary* customerSettings = customSettings();
    //    return [customerSettings objectForKey:@"apiKey"];
    return @"roastmaster123";
}

+(NSString*) getDefaultLanguage {
    NSDictionary *customerSettings = customSettings();
    return [customerSettings objectForKey:@"defaultLanguageForAPI"];
}

+(NSString*) getStoreName {
    NSDictionary* customerSettings = customSettings();
    return [customerSettings objectForKey:@"storeName"];
}

+(NSString*) getStorePhone {
    NSDictionary* customerSettings = customSettings();
    return [customerSettings objectForKey:@"storePhone"];
}

+(NSString*) getDefaultCountry {
    NSDictionary* customerSettings = customSettings();
    return [customerSettings objectForKey:@"defaultCountry"];
}

+(NSString*) getDefaultCity {
    NSDictionary* customerSettings = customSettings();
    return [customerSettings objectForKey:@"defaultCity"];
}

#pragma mark Image Processor
+ (UIImage*) transparentImage:(UIImage*)image {
    const CGFloat colorMasking[6] = {242, 255, 242, 255, 242, 255};
    struct CGImage *img = CGImageCreateWithMaskingColors(image.CGImage, colorMasking);
    image = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    return image;
}

#pragma mark Design colors
+(NSString*) getBackgroundPatternName {
//    NSDictionary* customerSettings = customSettings();
    NSString *patternName = @"pattern_white";
    return patternName;
}

+(NSString*) getDialogsBackgroundPatternName {
    NSDictionary* customerSettings = customSettings();
    NSString *patternName = [NSString stringWithFormat:@"dialog_%@", [customerSettings objectForKey:@"designStyle"]];
    return patternName;
}

+(UIBarStyle) getStatusBarStyle {
    NSDictionary* customerSettings = customSettings();
    NSString *styleColor = [customerSettings objectForKey:@"designStyle"];
    
    if ([styleColor isEqualToString:@"black"] ||
        [styleColor isEqualToString:@"red"] ||
        [styleColor isEqualToString:@"green"] ||
        [styleColor isEqualToString:@"blue"]) {
        return UIBarStyleBlack;
    } else {
        return UIBarStyleDefault;
    }
    
}

+(UIColor*) getStyleTranslucentColor {
    NSDictionary* customerSettings = customSettings();
    NSString *styleColor = [customerSettings objectForKey:@"designStyle"];
    if ([styleColor isEqualToString:@"white"]) {
        return [UIColor colorWithWhite:1 alpha:0.5];
    }
    if ([styleColor isEqualToString:@"black"]) {
        return [UIColor colorWithWhite:0 alpha:0.5];
    }
    if ([styleColor isEqualToString:@"red"]) {
        return [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.5];
    }
    if ([styleColor isEqualToString:@"green"]) {
        return [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.5];
    }
    if ([styleColor isEqualToString:@"blue"]) {
        return [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5];
    }
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

+(UIColor*) getStyleColor {
    NSDictionary* customerSettings = customSettings();
    NSString *styleColor = [customerSettings objectForKey:@"designStyle"];
    if ([styleColor isEqualToString:@"white"]) {
        return [UIColor colorWithWhite:1 alpha:1];
    }
    if ([styleColor isEqualToString:@"black"]) {
        return [UIColor colorWithWhite:0.3 alpha:1];
    }
    if ([styleColor isEqualToString:@"red"]) {
        return [UIColor colorWithRed:0.75 green:0 blue:0 alpha:1];
    }
    if ([styleColor isEqualToString:@"green"]) {
        return [UIColor colorWithRed:0 green:0.75 blue:0 alpha:1];
    }
    if ([styleColor isEqualToString:@"blue"]) {
        return [UIColor colorWithRed:0 green:0 blue:0.75 alpha:1];
    }
    if ([styleColor componentsSeparatedByString:@","].count >= 3) {
        NSArray *comps = [styleColor componentsSeparatedByString:@","];
        float red = [comps[0] floatValue] / 255;
        float green = [comps[1] floatValue] / 255;
        float blue = [comps[2] floatValue] / 255;
        float alpha;
        @try {
            alpha = [comps[3] floatValue];
        }
        @catch (NSException *exception) {
            alpha = 1;
        }
        @finally {
        }
        if (alpha == 0) alpha = 1;
        
        
        return [UIColor colorWithRed:red
                               green:green
                                blue:blue
                               alpha:alpha];
    }
    return [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
}


+(UIColor*) getContrastedColor {
    NSDictionary* customerSettings = customSettings();
    NSString *styleColorName = [customerSettings objectForKey:@"designStyle"];
    if ([styleColorName isEqualToString:@"white"]) {
        return [UIColor darkGrayColor];
    }
    if ([styleColorName isEqualToString:@"black"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"red"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"green"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"blue"]) {
        return [UIColor whiteColor];
    }
    
    UIColor *styleColor = [Configurator getStyleColor];
    CGFloat red, green, blue, alpha;
    [styleColor getRed:&red green:&green blue:&blue alpha:&alpha];
    float mess = (red+green+blue)/3;
    if (mess > 0.3) {
        return [UIColor whiteColor];
    }
    
    return [UIColor blackColor];
}


+(UIColor*) getBorderColor {
    NSDictionary* customerSettings = customSettings();
    NSString *styleColorName = [customerSettings objectForKey:@"designStyle"];
    if ([styleColorName isEqualToString:@"white"]) {
        return [UIColor darkGrayColor];
    }
    if ([styleColorName isEqualToString:@"black"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"red"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"green"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"blue"]) {
        return [UIColor whiteColor];
    }
    
    UIColor *styleColor = [Configurator getStyleColor];
    CGFloat red, green, blue, alpha;
    [styleColor getRed:&red green:&green blue:&blue alpha:&alpha];
    return [UIColor colorWithRed:red-0.1
                           green:green-0.1
                            blue:blue-0.1
                           alpha:alpha];
}

+(UIColor*) getBorderLightColor {
    NSDictionary* customerSettings = customSettings();
    NSString *styleColorName = [customerSettings objectForKey:@"designStyle"];
    if ([styleColorName isEqualToString:@"white"]) {
        return [UIColor lightGrayColor];
    }
    if ([styleColorName isEqualToString:@"black"]) {
        return [UIColor darkGrayColor];
    }
    if ([styleColorName isEqualToString:@"red"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"green"]) {
        return [UIColor whiteColor];
    }
    if ([styleColorName isEqualToString:@"blue"]) {
        return [UIColor whiteColor];
    }
    
    UIColor *styleColor = [Configurator getStyleColor];
    CGFloat red, green, blue, alpha;
    [styleColor getRed:&red green:&green blue:&blue alpha:&alpha];
    return [UIColor colorWithRed:red-0.05
                           green:green-0.05
                            blue:blue-0.05
                           alpha:alpha];
    return [UIColor blackColor];
}


#pragma mark Base URLS

+(NSString*) getStoreBaseUrl {
    NSDictionary* customerSettings = customSettings();
    return [customerSettings objectForKey:@"baseUrl"];
}

+(NSString*) getStoreAPIUrl {
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", [self getStoreBaseUrl], @"api/rest/"];
    return apiUrl;
}

+(NSString*) getStoreImageCacheUrl {
    NSString *cache = [NSString stringWithFormat:@"%@%@", [self getStoreBaseUrl], @"image/cache/"];
    return cache;
}

#pragma mark Catalog

+(NSString*) getUrlCategoriesByParentUid {
    return @"categories/parent/";
}
+(NSString*) getUrlProductsByCategoryUid {
    return @"products/category/";
}
+(NSString*) getUrlProductByUid {
    return @"products/";
}

#pragma mark User
+(NSString*) getUrlSession {
    return @"session";
}
+(NSString*) getUrlRegisterGuestUser:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"guest/";
}
+(NSString*) getUrlRegisterUser:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"register";
}
+(NSString*) getUrlLoginUser:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"login";
}
+(NSString*) getUrlLogoutUser:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"logout";
}
+(NSString*) getUrlCheckUser {
    return @"checkuser";
}

#pragma mark Shipping
+(NSString*) getUrlSetGuestShippingAddress:(NSString**)HTTPMethod{
    *HTTPMethod = @"POST";
    return @"guestshipping";
}
+(NSString*) getUrlGetShippingMethods {
    return @"shippingmethods";
}
+(NSString*) getUrlSelectShippingMethod:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"shippingmethods";
}
+(NSString*) getUrlAddNewShippingAddress:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"shippingaddress";
}
+(NSString*) getUrlSelectShippingAddressForOrder:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"shippingaddress";
}
+(NSString*) getUrlGetShippingAddresses {
    return @"shippingaddress";
}

#pragma mark Payment
+(NSString*) getUrlAddNewPaymentAdress:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"paymentaddress";
}
+(NSString*) getUrlGetPaymentAdresses {
    return @"paymentaddress";
}
+(NSString*) getUrlSelectPaymentAddressForOrder:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"paymentaddress";
}
+(NSString*) getUrlGetPaymentMethod {
    return @"paymentmethods";
}
+(NSString*) getUrlSelectPaymentMethod:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"paymentmethods";
}

#pragma mark Cart
+(NSString*) getUrlAddProductToCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"cart/";
}
+(NSString*) getUrlUpdateProductQuantityInCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"PUT";
    return @"cart/";
}
+(NSString*) getUrlDeleteProductFromCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"DELETE";
    return @"cart/";
}
+(NSString*) getUrlGetCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"GET";
    return @"cart/";
}
+(NSString*) getUrlSaveCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"confirm";
}
+(NSString*) getUrlConfirmCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"GET";
    return @"confirm";
}
+(NSString*) getUrlSimpleSaveCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"POST";
    return @"simpleconfirm";
}
+(NSString*) getUrlSimpleConfirmCart:(NSString**)HTTPMethod {
    *HTTPMethod = @"PUT";
    return @"simpleconfirm";
}



#pragma mark -

+(NSString*) getDefaultCurrency {
    return @".-";
}


#pragma mark Graphic User Interface settings
+(NSDictionary*) getArrayOfProductPropertiesToShowInProductView {
    //Here a list of product properties, shown on ProductViewController
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @1, @"manufacturer",
                         @2, @"model",
                         @3, @"reward",
                         @5, @"price",
                         @6, @"special",
                         @7, @"points",
                         //                    @8, @"discounts",
                         //                    @9, @"options",
                         //                    @10, @"description",
                         //                    @11, @"attribute_groups",
                         nil];
    return dic;
}

+(NSDictionary*) getArrayOfProductArrayPropertiesToShowInProductView {
    //Here a list of product properties, shown on ProductViewController
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @8, @"discounts",
                         @9, @"options",
                         @11, @"attribute_groups",
                         nil];
    return dic;
}

+(NSString*)localizedStringForKey:(NSString*) key {
    
    return NSLocalizedString(key, nil);
}

+(void)applyDesignStyleForViewController:(UIViewController*)viewController {
    
    viewController.navigationController.navigationBar.barTintColor = [Configurator getStyleColor];
    viewController.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:[Configurator getDialogsBackgroundPatternName]];
    viewController.navigationController.navigationBar.tintColor = [Configurator getContrastedColor];
    viewController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [Configurator getContrastedColor]};
    
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:[Configurator getDialogsBackgroundPatternName]] forBarMetrics:UIBarMetricsDefault];
    
    viewController.navigationController.navigationBar.barStyle = [Configurator getStatusBarStyle];
    
    //    [[UINavigationBar appearance] setTintColor:[Configurator getStyleColor]];
    
}

@end
