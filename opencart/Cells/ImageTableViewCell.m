//
//  ImageTableViewCell.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/22/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "Configurator.h"

@implementation ImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self prepareForShow];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self prepareForShow];
}

- (void) prepareForShow {
//    _priceView.backgroundColor = [Configurator getContrastedColor];
//    _priceView.layer.cornerRadius = 3;
    _priceView.layer.masksToBounds = YES;
//    _priceView.layer.borderWidth = 0.5;
//    _priceView.layer.borderColor = [Configurator getBorderColor].CGColor;
//    _priceLabel.textColor = [Configurator getBorderColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self prepareForShow];
    // Configure the view for the selected state
}

@end
