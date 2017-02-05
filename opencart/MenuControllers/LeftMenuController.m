//
//  MenuTableViewController.m
//  PunicAppPromo
//
//  Created by Firuz Narzikulov on 05/06/14.
//  Copyright (c) 2014 PunicApp LLC. All rights reserved.
//

#import "LeftMenuController.h"
#import "Configurator.h"
#import "UserInstance.h"
#import "Masonry.h"

typedef enum : NSUInteger {
    MenuItemProfile,
    MenuItemProducts,
    MenuItemNews,
    MenuItemAbout
} MenuItem;

@interface LeftMenuController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(50, 10, 10, self.sideMenuViewController.contentViewInPortraitOffsetCenterX * 3));
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:kLoginStatusChanged object:nil];
}

- (void)reloadTable {
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case MenuItemProfile:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"profile"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case MenuItemProducts:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"catalog"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case MenuItemNews:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"news"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case MenuItemAbout:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"about"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;

        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return titles().count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:21.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.highlightedTextColor = [Configurator getContrastedColor];
        cell.selectedBackgroundView = [UIView new];
    }
    
    cell.textLabel.text = titles()[indexPath.row];
    if (indexPath.row == MenuItemProfile && [UserInstance sharedInstance].loggedIn) {
        cell.textLabel.text = [UserInstance sharedInstance].email;
    }
    
    cell.imageView.image = [UIImage imageNamed:images()[indexPath.row]];
    
    return cell;
}

static NSArray *titles() {
    return @[@"Profile", @"Products", @"News", @"About"];
}

static NSArray *images() {
    return @[@"user", @"catalog", @"news", @"about"];
}
    
@end
