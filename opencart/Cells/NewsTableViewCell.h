//
//  NewsTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 9/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *newsImageView;
@property (nonatomic, strong) IBOutlet UILabel *newsLabel;
@property (nonatomic, strong) IBOutlet UILabel *newsDate;

@end
