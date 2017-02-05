//
//  MyAccountViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ProfileViewController.h"
#import "Configurator.h"
#import "UserInstance.h"
#import "LoginViewController.h"
#import "RESideMenu.h"

#import "ProfileDetailsViewController.h"
#import "RestClient.h"

@interface ProfileViewController () <LoginViewControllerDelegate>

@end

@implementation ProfileViewController

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

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    [Configurator applyDesignStyleForViewController:self];
        
    UIView *emptyView = [UIView new];
    [emptyView setFrame:CGRectZero];
    self.tableView.tableFooterView = emptyView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self                                                                                action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self                                                                                action:@selector(loginLogout)];
    [self loginStatusChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged) name:kLoginStatusChanged object:nil];
}


- (void)loginLogout {
    if (![[UserInstance sharedInstance] isLoggedIn]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        UINavigationController *nlvc = [sb instantiateViewControllerWithIdentifier:@"login"];
        
        UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
        UIView *view = [item valueForKey:@"view"];
        if ([view isKindOfClass:[UIView class]]) {
            nlvc.modalPresentationStyle = UIModalPresentationPopover;
            nlvc.popoverPresentationController.sourceView = view;
            nlvc.popoverPresentationController.sourceRect = view.bounds;
        }
        LoginViewController *lvc = [[nlvc viewControllers] firstObject];
        lvc.delegate = self;
        [self.navigationController presentViewController:nlvc animated:YES completion:nil];
    } else {
        [[UserInstance sharedInstance] logout];
    }
}

- (void)loginStatusChanged {
    self.tableView.userInteractionEnabled = [UserInstance sharedInstance].isLoggedIn;
    NSString *title = [UserInstance sharedInstance].isLoggedIn ? NSLocalizedString(@"Logout", nil) : NSLocalizedString(@"Login", nil);
    [self.navigationItem.rightBarButtonItem setTitle:title];
    
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    
    UIView *view = [item valueForKey:@"view"];
    if ([view isKindOfClass:[UIView class]]) {
        [view layoutIfNeeded];
    }

    [self.tableView reloadData];
}

- (void)canceledLoginVC {
    [self loginStatusChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (![UserInstance sharedInstance].isLoggedIn)
                return 0;
            break;
        case 1:
            if ([UserInstance sharedInstance].isLoggedIn)
                return 0;
            break;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - Navigation

static NSString *kAddressesSegueIdentifier = @"toAddresses";
static NSString *kFavoritesSegueIdentifier = @"toFavorites";
static NSString *kAccountDetailsSegueIdentifier = @"toAccountDetails";
static NSString *kMyOrdersSegueIdentifier = @"toOrders";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfileDetailsViewController *destVC = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:kAddressesSegueIdentifier]) {
        destVC.detailsType = ProfileDetailsTypeAddresses;
    }
    if ([segue.identifier isEqualToString:kFavoritesSegueIdentifier]) {
        destVC.detailsType = ProfileDetailsTypeFavorites;
    }
    if ([segue.identifier isEqualToString:kAccountDetailsSegueIdentifier]) {
        destVC.detailsType = ProfileDetailsTypeAccount;
    }
    if ([segue.identifier isEqualToString:kMyOrdersSegueIdentifier]) {
        destVC.detailsType = ProfileDetailsTypeOrders;
    }
}

@end
