//
//  NewsTableViewCell.m
//  opencart
//
//  Created by Firuz Narzikulov on 9/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell {
    CGRect textLabelFrame;
    CGRect detailTextLabelFrame;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.newsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.newsImageView.clipsToBounds = YES;
    self.newsImageView.frame = CGRectMake(10,4,36,36);
    self.newsImageView.layer.cornerRadius = 18;
    self.newsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
