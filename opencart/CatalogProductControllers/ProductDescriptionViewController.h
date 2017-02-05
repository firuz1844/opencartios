//
//  ProductDescriptionViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/27/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *descriptionProduct;
@end
