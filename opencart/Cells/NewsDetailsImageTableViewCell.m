//
//  NewsDetailsImageTableViewCell.m
//  opencart
//
//  Created by Firuz Narzikulov on 01/01/15.
//  Copyright (c) 2015 ServiceTrade LLC. All rights reserved.
//

#import "NewsDetailsImageTableViewCell.h"
#import "NewsPhotosCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsDetailsImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
    self.pageControl.numberOfPages = self.imagesUrls.count;
    self.pageControl.center = CGPointMake(self.contentView.center.x, self.contentView.frame.size.height * 0.95);
    if (self.imagesUrls && self.imagesUrls.count <= 1) {
        self.pageControl.hidden = YES;
    }
}

#pragma mark - ImagesCollection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_imagesUrls count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSURL *url = [_imagesUrls objectAtIndex:indexPath.row];
    [cell.image sd_setImageWithURL:url];
    cell.image.frame = cell.bounds;
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320, 240);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.pageControl.currentPage = indexPath.row;
}

@end
