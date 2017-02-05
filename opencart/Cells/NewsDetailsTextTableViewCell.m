//
//  NewsDetailsTextTableViewCell.m
//  opencart
//
//  Created by Firuz Narzikulov on 01/01/15.
//  Copyright (c) 2015 ServiceTrade LLC. All rights reserved.
//

#import "NewsDetailsTextTableViewCell.h"

@implementation NewsDetailsTextTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.contentView.frame;
}
@end
