//
//  CatalogViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "CatalogViewController.h"
#import "ProductViewController.h"
#import "Configurator.h"
#import "MoneyHelper.h"
#import "CategoryTableViewCell.h"
#import "ProductTableViewCell.h"

#import "CategoryEntity.h"
#import "ProductEntity.h"

#import "UIImageView+WebCache.h"
#import "UIImage+Additions.h"
#import "SVProgressHUD.h"
#import "RestClient.h"

static NSString * const kCategoryCellIdentifier = @"CategoryCell";
static NSString * const kProductCellIdentifier = @"ProductCell";

@interface CatalogViewController () <UIScrollViewDelegate> {
    NSIndexPath *selectedRowIndex;
    
    UIScrollView *bannerView;
    NSInteger currentPageNumber;
    NSInteger totalPagesNumber;
    UIPageControl *pageControl;
    NSTimer *timer;
}

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *products;

@end

@implementation CatalogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    NSString *path = [NSString stringWithFormat:@"/api/rest/categories/parent/%@", self.parentId];
    [[RestClient sharedInstance] loadEntities:[CategoryEntity new] atPath:path keyPath:@"data" withParameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            weakSelf.categories = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
    
    self.tableView.tableFooterView = [UIView new];
        
    currentPageNumber = 0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    
    [Configurator applyDesignStyleForViewController:self];
    
    self.tableView.separatorColor = [Configurator getContrastedColor];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", nil)];
    
    if (![self.parentId isEqualToString:[Configurator getDefaultRootParentUid]]) {
        //Lets fetch products in categories which are not root (Ex. parent_id is not equal to "0")
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", nil)];
        path = [NSString stringWithFormat:@"/api/rest/products/category/%@", self.parentId];
        [[RestClient sharedInstance] loadEntities:[ProductEntity new] atPath:path keyPath:@"data" withParameters:nil success:^(id result) {
            if ([result isKindOfClass:[NSArray class]]) {
                weakSelf.products = result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                });
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD dismiss];
        }];
    }
    
    if ([self.parentId isEqualToString:[Configurator getDefaultRootParentUid]]) {
        [self showBannerViewWithUrlsArray:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil)
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self                                                                                action:@selector(presentLeftMenuViewController:)];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cart", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self                                                                                action:@selector(presentRightMenuViewController:)];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_parentId isEqualToString:[Configurator getDefaultRootParentUid]]) {
        [self changePage:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(tickTack) userInfo:nil repeats:YES];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
}

- (void) viewDidLayoutSubviews {
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius  = 10.0f;
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.view.layer.shadowPath    = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
}

- (NSString *)parentId {
    if (!_parentId) {
        _parentId = [Configurator getDefaultRootParentUid];
    }
    return _parentId;
}

#pragma mark - Banner -

-(void) showBannerViewWithUrlsArray:(NSArray*)urlsArray {
    if (!urlsArray) {
        urlsArray = @[@"http://shop.insk.org/image/cache/catalog/slideOpenCart-1140x380.png",
                      @"http://shop.insk.org/image/cache/catalog/SliderDrom-1140x380.png"];
    }
    bannerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.3)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    bannerView.contentSize = CGSizeMake(self.view.frame.size.width * urlsArray.count, self.view.frame.size.height/2.3);
    bannerView.pagingEnabled = YES;
    bannerView.showsHorizontalScrollIndicator = NO;
    bannerView.showsVerticalScrollIndicator = NO;
    bannerView.backgroundColor = [UIColor whiteColor];
    bannerView.delegate = self;

    for (int i = 0; i<urlsArray.count; i++) {
        NSString *url = urlsArray[i];
        NSString *imageUrlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, bannerView.bounds.size.height);
        [bannerView addSubview:imageView];
    }
    
    UIView *gradient = [[UIView alloc] initWithFrame:CGRectMake(0, bannerView.bounds.size.height-70, bannerView.bounds.size.width, 70)];
    gradient.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = gradient.bounds;
    layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0.0] CGColor], (id)[[UIColor colorWithWhite:0 alpha:1] CGColor], nil];
    [gradient.layer insertSublayer:layer atIndex:0];
    
    int margin = 20;
    CGRect labelRect = CGRectMake(margin, margin*1.5, gradient.bounds.size.width-margin*2, gradient.bounds.size.height-margin*2);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.text = @"Wellcome to Shopinsk by iNsk.org!";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [gradient addSubview:label];

    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, bannerView.frame.size.height)];
    [self.tableView.tableHeaderView addSubview:bannerView];
    [self.tableView.tableHeaderView addSubview:gradient];
    
    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, bannerView.frame.size.height/2-15, 30, 30)];
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(bannerView.frame.size.width-30, bannerView.frame.size.height/2-15, 30, 30)];
    [buttonLeft addTarget:self action:@selector(bannerToLeft) forControlEvents:UIControlEventTouchUpInside];
    [buttonRight addTarget:self action:@selector(bannerToRight) forControlEvents:UIControlEventTouchUpInside];
    [buttonLeft setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [buttonRight setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self.tableView.tableHeaderView addSubview:buttonLeft];
    [self.tableView.tableHeaderView addSubview:buttonRight];
    totalPagesNumber = bannerView.contentSize.width/bannerView.frame.size.width;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, bannerView.bounds.size.width, 20)];
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    pageControl.tintColor = [UIColor whiteColor];
    CGPoint pageControllCenter = CGPointMake(bannerView.center.x, bannerView.center.y*1.9);
    pageControl.center = pageControllCenter;
    pageControl.numberOfPages = totalPagesNumber;
    [self.tableView.tableHeaderView addSubview:pageControl];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

}

- (void)changePage:(UIPageControl*)control {
    [bannerView setContentOffset:CGPointMake(currentPageNumber * bannerView.frame.size.width, 0) animated:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    NSInteger pageNumber = roundf(scrollView.contentOffset.x / (scrollView.frame.size.width));
    pageControl.currentPage = pageNumber;
    currentPageNumber = pageNumber;
}

- (void)tickTack {
    currentPageNumber++;
    if (currentPageNumber>=totalPagesNumber) {
        currentPageNumber = 0;
    }
    pageControl.currentPage = currentPageNumber;
    [self changePage:nil];
}


-(void)bannerToLeft {
    currentPageNumber -=1;
    if (currentPageNumber<0) {
        currentPageNumber = 0;
    }
    [bannerView setContentOffset:CGPointMake(bannerView.frame.size.width*currentPageNumber, 0.0f) animated:YES];
}

- (void)bannerToRight {
    currentPageNumber +=1;
    if (currentPageNumber>totalPagesNumber-1) {
        currentPageNumber = totalPagesNumber-1;
    }
    [bannerView setContentOffset:CGPointMake(bannerView.frame.size.width*currentPageNumber, 0.0f) animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _categories.count;
    }
    if (section == 1) {
        return _products.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        switch (indexPath.section) {
            case 0:
                return 75;
                break;
                
            case 1:
                return 95;
                break;
                
            default:
                break;
        }

    }
    else{
        switch (indexPath.section) {
            case 0:
                return 55;
                break;
                
            case 1:
                return 87;
                break;
                
            default:
                break;
        }

    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [Configurator getStyleColor];
        cell.lableName.textColor = [Configurator getContrastedColor];
        UIView *separator = [[UIView alloc] initWithFrame: CGRectMake(0, cell.frame.size.height-3, cell.frame.size.width, 3)];
        [cell addSubview:separator];
        separator.backgroundColor = [Configurator getBorderLightColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tintColor = [Configurator getBorderLightColor];
        
        CategoryEntity *category = _categories[indexPath.row];
        [cell.lableName setText:category.name];
        if (![category.image isKindOfClass:[NSNull class]]) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:category.image]
                       placeholderImage:[UIImage imageNamed:@"folder.png"]];
        } else {
            [cell.image setImage:[UIImage imageNamed:@"folder.png"]];
            if ([category.name rangeOfString:@"Phone"].location != NSNotFound ||
                [category.name rangeOfString:@"телефон"].location != NSNotFound) {
                [cell.image setImage:[UIImage imageNamed:@"iphone"]];
            }
            if ([[category.name lowercaseString] rangeOfString:@"ipad"].location != NSNotFound ||
                [[category.name lowercaseString] rangeOfString:@"tablet"].location != NSNotFound ||
                [[category.name lowercaseString] rangeOfString:@"планшет"].location != NSNotFound) {
                [cell.image setImage:[UIImage imageNamed:@"ipad"]];
            }
            if ([[category.name lowercaseString] rangeOfString:@"ipad mini"].location != NSNotFound) {
                [cell.image setImage:[UIImage imageNamed:@"ipadMini"]];
            }
            if ([[category.name lowercaseString] rangeOfString:NSLocalizedString(@"ccessor", @"Search keyword for Accessory")].location != NSNotFound ||
                [[category.name lowercaseString] rangeOfString:@"аксессуар"].location != NSNotFound ||
                [[category.name lowercaseString] rangeOfString:@"mp3"].location != NSNotFound) {
                [cell.image setImage:[UIImage imageNamed:@"ibattery"]];
            }
            [cell.image setContentMode:UIViewContentModeCenter];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        ProductEntity *product = _products[indexPath.row];
        cell.lableName.text = product.name;
        if (product.special) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:product.price];
            [attributedString addAttribute: NSStrikethroughStyleAttributeName
                                     value: [NSNumber numberWithInt:2]
                                     range: NSMakeRange(0,[product.price length])];
            NSString *special = [NSString stringWithFormat:@"\n%@", product.special];
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:special]];
            cell.lablePrice.attributedText = attributedString;

        } else {
            cell.lablePrice.text = product.price;
        }
        
        if (![product.image isKindOfClass:[NSNull class]]) {
            [cell.image sd_setImageWithURL:product.image];

        } else {
            [cell.image setImage:[UIImage imageNamed:@"noImage.png"]];
            [cell.image setContentMode:UIViewContentModeScaleAspectFit];
        }
        
        return cell;
    }
    UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
    return emptyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRowIndex = indexPath;
    if ((indexPath.row <= _categories.count - 1) && (indexPath.section == 0)) {
        //Seems that the category in this row (because we use first section for categories only)
        CategoryEntity *selectedCategory = [_categories objectAtIndex:selectedRowIndex.row];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        CatalogViewController *nextCategoryVC = [storyboard instantiateViewControllerWithIdentifier:@"catalog"];
        nextCategoryVC.parentId = selectedCategory.category_id;
        nextCategoryVC.title = selectedCategory.name;
        [self.navigationController pushViewController:nextCategoryVC animated:YES];

    }
    if ((indexPath.section == 1) && (indexPath.row <= _products.count - 1)) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"OpenProduct" sender:self];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OpenCategory"]) {
        if ([[segue destinationViewController] isKindOfClass:[self class]]) {
            CategoryEntity *selectedCategory = [_categories objectAtIndex:selectedRowIndex.row];
            CatalogViewController *nextCategoryVC = [segue destinationViewController];
            nextCategoryVC.parentId = selectedCategory.parent_id;
        }
    }
    if ([segue.identifier isEqualToString:@"OpenProduct"]) {
        if ([[segue destinationViewController] isKindOfClass:[ProductViewController class]]) {
            ProductEntity *selectedProduct = [_products objectAtIndex:selectedRowIndex.row];
            ProductViewController *productVC = [segue destinationViewController];
            productVC.product = selectedProduct;
        }
    }
    
    //Slide menu unwinf segue
    if ([segue.identifier isEqualToString:@"unwind"]) {
        NSLog(@"UNWIIIIIIND");
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
