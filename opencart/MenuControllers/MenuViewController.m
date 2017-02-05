//
//  MenuViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 04.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "MenuViewController.h"
#import "CartViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"content"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    
    self.delegate = self;
    
    [self setupOffsets];
}

- (void)setupOffsets {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.contentViewInPortraitOffsetCenterX = CGRectGetWidth(self.view.bounds)/3;
        self.contentViewInLandscapeOffsetCenterX = 0;
    } else {
        self.contentViewInPortraitOffsetCenterX = -CGRectGetWidth(self.view.bounds)/5;
        self.contentViewInLandscapeOffsetCenterX = -CGRectGetWidth(self.view.bounds)/5.3;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self hideMenuViewController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupOffsets];
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    // Handle CartViewController
    if ([menuViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nv = (UINavigationController*)menuViewController;
        CartViewController *cv = [[nv viewControllers] firstObject];
        
        if ([cv isKindOfClass:[CartViewController class]]) {
            [cv handleRefresh];
        }
    }
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
