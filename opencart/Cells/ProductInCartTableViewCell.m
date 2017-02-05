//
//  ProductInCartTableViewCell.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/25/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ProductInCartTableViewCell.h"

@implementation ProductInCartTableViewCell

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
    self.name.text = @"";
    self.options.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
