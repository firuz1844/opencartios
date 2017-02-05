//
//  CatalogViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface CatalogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *parentId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
