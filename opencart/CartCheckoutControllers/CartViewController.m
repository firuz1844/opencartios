//
//  BasketViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "CartViewController.h"
#import "UserInstance.h"
#import "ProductInCartTableViewCell.h"
#import "TotalForCartTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MoneyHelper.h"
#import "TotalEntity.h"
#import "Configurator.h"
#import "OptionValueEntity.h"
#import "ProductViewController.h"

#import "CheckoutViewController.h"

#import "RESideMenu.h"
#import "RestClient.h"
#import "CartEntity.h"

@interface CartViewController () <RESideMenuDelegate> {
    NSIndexPath *selectedRowIndex;
    UIRefreshControl *refreshControl;
    ProductEntity *justDeletedProduct;
    ProductEntity *selectedProduct;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkoutButton;

@property (nonatomic, strong) CartEntity *cart;

@end

@implementation CartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    [Configurator applyDesignStyleForViewController:self];

    [self handleRefresh];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!refreshControl) {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refreshControl];
    }
    [refreshControl endRefreshing];
    
    [self handleRefresh];
}

- (void)fetchCart {
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:[CartEntity new] atPath:@"/api/rest/cart" keyPath:@"data" withParameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            weakSelf.cart = [result firstObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.checkoutButton.enabled = YES;
                self.editButton.enabled = YES;
                
                [self.tableView reloadData];
                [refreshControl endRefreshing];
                
                TotalEntity *total = [weakSelf.cart.totals lastObject];
                self.title = [NSString stringWithFormat:@"%@: %@", total.title, total.text];
            });
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.checkoutButton.enabled = NO;
            self.editButton.enabled = NO;
            
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            
            self.title = NSLocalizedString(@"Cart", nil);
        });

        NSLog(@"error");
    }];
}

-(void) handleRefresh {
    [self fetchCart];
}

- (void)didDeleteProductFromCart:(BOOL)success {

    [self.cart.products removeObject:justDeletedProduct];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [self fetchCart];
}

//Errors
- (void) fetchingSessionFailedWithError:(NSError *)error {
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}
- (void) addingProductFailedWithError:(NSError *)error {
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}
- (void) getCartWithError:(NSError *)error {
    self.checkoutButton.enabled = NO;
    self.editButton.enabled = NO;
    
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.parentViewController.tabBarItem = [[UITabBarItem alloc]
                                                initWithTitle:NSLocalizedString(@"Cart", nil)
                                                image:[UIImage imageNamed:@"cartEmpty"]
                                                tag:3];
        self.title = NSLocalizedString(@"Cart", nil);
        [self.cart.products removeAllObjects];
        self.cart.totals = nil;
        
        if (!self.cart) {
            self.cart = [CartEntity new];
            self.cart.products = [[NSMutableArray alloc] initWithCapacity:1];
        }
        ProductEntity *emptyProd = [ProductEntity new];
        emptyProd.name = NSLocalizedString(@"There are no products in your cart!", nil);
        emptyProd.options = nil;
        emptyProd.uid = @"000";
        emptyProd.price = @"";
        emptyProd.image = @"";
        [self.cart.products addObject:emptyProd];

        [self.tableView reloadData];

        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        
    });

}

- (void) deleteProductFromCartWithError:(NSError *)error {
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
    
}

#pragma mark -
- (void) proceedOrder {
    [self performSegueWithIdentifier:@"selectShipping" sender:self];
}


#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 0;
    if (self.cart.products && self.cart.products.count > 0) {
        numberOfSections += 1;
    }
    if (self.cart.totals && self.cart.totals.count > 0) {
        numberOfSections += 1;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.cart) {
        if (section == 0) {
            if (self.cart.products) {
                return self.cart.products.count;
            }
        }
        if (section == 1) {
            if (self.cart.totals) {
                return self.cart.totals.count;
            }
        }
    }
    return 0;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 106;
//    }
//    if (indexPath.section == 1) {
//        return 28;
//    }
//    return 44;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductInCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductInCartCell" forIndexPath:indexPath];
        if (cell) {
            ProductEntity *product = self.cart.products[indexPath.row];
            NSString *name = product.name;
            if ([product.uid isEqualToString:@"000"]) {
                cell.name.text = name;
                cell.options.text = @"";
                cell.thumb.image = [UIImage imageNamed:@"AppIcon"];
//                cell.lableName.textAlignment = NSTextAlignmentCenter;
//                cell.lableName.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }

            NSString *quantityAndPrice = [NSString stringWithFormat:@"%d х %@", [product.quantity intValue], product.price];
            
            cell.name.text = [NSString stringWithFormat:@"%@ %@", name, quantityAndPrice];
            if (!product.thumb || [product.thumb isKindOfClass:[NSNull class]]) {
                product.thumb = @"";
            } else {
                cell.thumb.image = nil;
            }
            [cell.thumb sd_setImageWithURL:product.thumb
                       placeholderImage:[UIImage imageNamed:@"noImage"]];
            
            NSString *descriptionString = @"";
            if (product.option && product.option.count > 0) {
                for (OptionValueEntity *optionValue in product.option) {
                    descriptionString = [descriptionString stringByAppendingString:[optionValue print]];
                    descriptionString = [descriptionString stringByAppendingString:@"\n"];
                }
//                if (descriptionString.length > 3) descriptionString = [descriptionString substringToIndex:descriptionString.length-2];
                if (product.reward) {
                    descriptionString = [descriptionString stringByAppendingString:product.reward];
                }
            }
            cell.options.text = descriptionString;
        }
        return cell;
    }
    if (indexPath.section == 1) {
        TotalForCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalForCartCell" forIndexPath:indexPath];
        if (cell) {
            TotalEntity *total = self.cart.totals[indexPath.row];
            cell.textLabel.text = total.title;
            cell.detailTextLabel.text = total.text;
        }
        return cell;
    }
    return [[UITableViewCell alloc] init];
}
- (IBAction)editAction:(UIBarButtonItem*)sender {
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductEntity *prod;
        if (self.cart.products.count > 0) {
            prod = [self.cart.products objectAtIndex:indexPath.row];
        }
        if (!prod) {
            return NO;
        } else if ([prod.uid isKindOfClass:[NSString class]] && [prod.uid isEqualToString:@"000"]) {
            //This is empty prod
            return NO;
        }
        return YES;
    } else {
        return NO;
    };
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            justDeletedProduct = self.cart.products[indexPath.row];
            [[RestClient sharedInstance] deleteEntity:[ProductEntity new] atPath:@"/api/rest/cart" withParameters:@{@"key":justDeletedProduct.key} success:^(id result) {
                NSLog(@"Deleted");
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row <= self.cart.products.count-1)) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        selectedProduct = self.cart.products[indexPath.row];
    }
    return indexPath;
}

#pragma mark Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"OpenProductFromCart"]) {
        if ([[(ProductEntity*)[self.cart.products firstObject] uid] isEqualToString:@"000"]) {
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OpenProductFromCart"]) {
        if ([[segue destinationViewController] isKindOfClass:[ProductViewController class]]) {
            ProductViewController *productVC = [segue destinationViewController];
            productVC.product = selectedProduct;
        }
    }

    //Slide menu unwind segue
    if ([segue.identifier isEqualToString:@"unwind"]) {
        NSLog(@"UNWIIIIIIND");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)checkout:(UIBarButtonItem*)sender {
    
    UIView *view = [sender valueForKey:@"view"];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    UINavigationController *ncvc = [sb instantiateViewControllerWithIdentifier:@"checkout"];
    
    if ([view isKindOfClass:[UIView class]]) {
        ncvc.modalPresentationStyle = UIModalPresentationPopover;
        ncvc.popoverPresentationController.sourceView = view;
        ncvc.popoverPresentationController.sourceRect = view.frame;
        ncvc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;

    }
    [self.navigationController presentViewController:ncvc animated:YES completion:nil];

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
