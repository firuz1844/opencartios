//
//  BasketViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void) handleRefresh;

@end
