//
//  NewsDetailViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 9/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsModel.h"
#import "VKSdk.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailsTextTableViewCell.h"
#import "NewsDetailsImageTableViewCell.h"
#import "NewsPhotosCollectionViewCell.h"


@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController {
    NSArray *imagesUrls;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.model.child) {
        self.model = self.model.child;
    }
    
    NSMutableArray *newArray = [NSMutableArray new];
    [self.model.attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[VKPhoto class]]) {
            VKPhoto *photo = obj;
            if (photo.photo_604) [newArray addObject:[NSURL URLWithString:photo.photo_604]];
        }
    }];
    imagesUrls = [newArray copy];


    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1: {
            if (!self.model.text || self.model.text.length < 1) {
                return 0;
            }
            NSStringDrawingContext *ctx = [NSStringDrawingContext new];
            NSAttributedString *aString = [[NSAttributedString alloc] initWithString:self.model.text];
            UITextView *calculationView = [[UITextView alloc] init];
            [calculationView setAttributedText:aString];
            CGRect textRect = [calculationView.text boundingRectWithSize:self.view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
            return textRect.size.height + 44;

        }
            break;
        case 2:
            return 240;
            break;
            
        default:
            break;
    }
    if (!self.model.title) {
        return 0;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (imagesUrls.count > 0) {
        return 3;
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            cell.textLabel.text = self.model.title;
            cell.detailTextLabel.text = self.model.dateString;
        }
            break;
        case 1:
        {
            NewsDetailsTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            cell.textView.text = self.model.text;
            return cell;
        }
            break;
        case 2: {
            NewsDetailsImageTableViewCell *imgCell = [tableView dequeueReusableCellWithIdentifier:@"imagesCell"];
            imgCell.imagesUrls = imagesUrls;
            [imgCell.collectionView reloadData];
            return imgCell;
        }
        default:
            break;
    }
    if (!cell) {
        cell = [UITableViewCell new];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
