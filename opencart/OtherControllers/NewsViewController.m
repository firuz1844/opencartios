//
//  NewsViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 8/8/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailViewController.h"
#import "Configurator.h"

#import "RESideMenu.h"

@interface NewsViewController () {
    
}

@property (nonatomic, strong) NSMutableArray *news;
@end

@implementation NewsViewController {
    NewsModel *model;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(update:) name:@"VK_NEWS"
                                               object:nil];
    NSString *group_id = @"-117245264";
    [AppDelegate getVkNewsForGroup:group_id Offset:0 count:10];
    
    [Configurator applyDesignStyleForViewController:self];

    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self                                                                                action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cart", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self                                                                                action:@selector(presentRightMenuViewController:)];

}

- (NSMutableArray*)news {
    if (!_news) {
        _news = [NSMutableArray new];
    }
    return _news;
}

- (void) update:(NSNotification*)sender {
    if ([sender.userInfo isKindOfClass:[NSDictionary class]]) {
        for (NSDictionary *dict in sender.userInfo[@"items"]) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NewsModel *nm = [[NewsModel alloc] initWithDict:dict];
                [self.news addObject:nm];
            }
        }
    }
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    NewsModel *nm = (NewsModel*)[self.news objectAtIndex:indexPath.row];
    if (nm.child) {
        nm = nm.child;
    }
    cell.newsLabel.text = nm.title;
    cell.newsDate.text = nm.dateString;
    cell.newsImageView.image = [UIImage imageNamed:@"info"];
    if (nm.attachments.count > 0) {
        VKPhoto *photo = [nm.attachments firstObject];
        if (photo.photo_130) {
            [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:photo.photo_75]
                                  placeholderImage:[UIImage imageNamed:@"info"]];
        }
        
        cell.clipsToBounds = YES;
        
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    model = [self.news objectAtIndex:indexPath.row];
    return indexPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NewsDetailViewController *nextVC = [segue destinationViewController];
    nextVC.model = model;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
