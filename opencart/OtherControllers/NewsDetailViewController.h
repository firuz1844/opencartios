//
//  NewsDetailViewController.h
//  ;
//
//  Created by Firuz Narzikulov on 9/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;

@interface NewsDetailViewController : UITableViewController
@property (nonatomic, strong) NewsModel *model;

@end
