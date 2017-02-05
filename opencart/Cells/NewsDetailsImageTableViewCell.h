//
//  NewsDetailsImageTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 01/01/15.
//  Copyright (c) 2015 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailsImageTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *imagesUrls;

@end
