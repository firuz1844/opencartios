//
//  ProductViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/22/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

enum alertType {
    AlertUnknown,
    AlertProductAddedSuccessfully,
};

enum alertCartSuccessButton {
    ButtonCancel,
    ButtonGoToCart
};

#import "ProductViewController.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>
#import "PropertyUtil.h"

#import "Configurator.h"
#import "MoneyHelper.h"
#import "ImageTableViewCell.h"
#import "OptionTableViewCell.h"


#import "DiscountEntity.h"
#import "OptionEntity.h"
#import "OptionValueEntity.h"
#import "AttributeGroupEntity.h"
#import "AttributeEntity.h"

#import "ProductDescriptionViewController.h"
#import "ProductOptionSelectorViewController.h"
#import "ProductAttributesViewController.h"

#import "CartViewController.h"

#import "SVProgressHUD.h"
#import "BuyTableViewCell.h"
#import "RatingView.h"

#import "MWPhotoBrowser.h"
#import "MWPhoto.h"


#import "RestClient.h"

@interface ProductViewController () <ProductOptionSelectorDelegate, MWPhotoBrowserDelegate, UIAlertViewDelegate> {

    NSDictionary *allProductKeys; //all property names of Product class
    NSMutableArray *allNotEmptyKeys; //only property names of product whish are not nil or NSNULL
    NSMutableDictionary *shownOnScreenNotEmptyKeys; //key-value style property names - where value is sort descriptor
    NSArray *sortedShownNotEmptyKeys;
    
    NSMutableDictionary *shownOnScreenNotEmptyArrayKeys; //Array style property names - where value is sort descriptor
    NSArray *sortedShownNotEmptyArrayKeys;
    NSMutableArray *arrayOfAttributesForTableView;
    
    OptionEntity *selectedOption;
    NSInteger optionsSection;
    
    ProductQuantitySelectorViewController *quantityController;
    
    NSDate *dateBegin;
    NSDate *dateEnd;
    
    BOOL haveSpecial;
    
    NSMutableArray *photos;
}

@property (nonatomic, strong) UILabel *priceLabelOverTheImage;
@property (nonatomic, strong) UITableViewCell *priceCell;

@end

@implementation ProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    optionsSection = 9999999;
    
    self.tableView.tableFooterView = [UIView new];
    dateBegin = [NSDate date];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];

    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", nil)];

    
    //By default quantity selector is hidden on load
    _quantitySelectorView.hidden = YES;
    _quantitySelectorView.layer.cornerRadius = 7;
    _quantitySelectorView.layer.masksToBounds = YES;
    _quantitySelectorView.layer.borderWidth = 2;
    _quantitySelectorView.layer.borderColor = [Configurator getBorderColor].CGColor;
    _quantitySelectorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    
    self.title = _product.name;
    
    quantityController = [[ProductQuantitySelectorViewController alloc] init];
    quantityController.delegate = self;
    
    _quantitySelectorTableView.dataSource = quantityController;
    _quantitySelectorTableView.delegate = quantityController;
    
    [self prepareDataForUix];
    
    NSString *productId = self.product.uid;
    if (!productId || [productId isEqualToString:@"(null)"] || [productId isEqualToString:@""]) {
        productId = self.product.key;
    }
//    [_manager fetchProductByUid:productId];
    
    
    NSString *path = [NSString stringWithFormat:@"/api/rest/products/%@", productId];
    
    __weak typeof(self) wealSelf = self;
    
    [[RestClient sharedInstance] loadEntities:[ProductEntity new] atPath:path keyPath:@"data" withParameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            wealSelf.product = [(NSArray*)result firstObject];
        }
        
        NSMutableArray *defaultOptions = [NSMutableArray new];
        for (OptionEntity *opt in wealSelf.product.options) {
            if ([opt.required integerValue] == 1) {
                if ([opt.option_value isKindOfClass:[NSArray class]]) {
                    [defaultOptions addObject:[opt.option_value firstObject]];
                }
            }
        }
        [wealSelf didSelectedOptions:defaultOptions];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wealSelf prepareDataForUix];
            [wealSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        });

    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    NSLog(@"ViewDidLoaded in:%f msec", [dateBegin timeIntervalSinceNow] * -1000.0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);

}

- (void)prepareDataForUix {
    //here only image and keyValue type properties
    
    allProductKeys = [PropertyUtil classPropsFor:[_product class]];
    
    NSDictionary *possibleShownKeys = [Configurator getArrayOfProductPropertiesToShowInProductView];
    
    //Finding joins of keys
    allNotEmptyKeys = [[NSMutableArray alloc] init];
    shownOnScreenNotEmptyKeys = [[NSMutableDictionary alloc] init];
    for (NSString *key in [allProductKeys allKeys]) {
        id value = [_product valueForKey:key];
        if (value && ![value isKindOfClass:[NSNull class]]) {
            [allNotEmptyKeys addObject:key];
            if ([[possibleShownKeys allKeys] containsObject:key]) {
                [shownOnScreenNotEmptyKeys setObject:[possibleShownKeys objectForKey:key] forKey:key];
            }
        }
    }
    
    //Sorted array of property names that not empty and should be shown on screen
    sortedShownNotEmptyKeys = [shownOnScreenNotEmptyKeys keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    /////////////////////////ARRAY KEYS////////////////////
    NSDictionary *possibleShownArrayKeys = [Configurator getArrayOfProductArrayPropertiesToShowInProductView];

    
    shownOnScreenNotEmptyArrayKeys = [[NSMutableDictionary alloc] init];
    for (NSString *key in allNotEmptyKeys) {
        id value = [_product valueForKey:key];
        if (value && ![value isKindOfClass:[NSNull class]]) {
            if ([[possibleShownArrayKeys allKeys] containsObject:key]) {
                [shownOnScreenNotEmptyArrayKeys setObject:[possibleShownArrayKeys objectForKey:key] forKey:key];
            }
        }
    }
    
    //Sorted array of property names that not empty and should be shown on screen
    sortedShownNotEmptyArrayKeys = [shownOnScreenNotEmptyArrayKeys keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];


}

#pragma mark TableView Delegate
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 50;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _product.name;
    } else {
        return NSLocalizedString(sortedShownNotEmptyArrayKeys[section - 1], nil);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
            
        default:
            if ([sortedShownNotEmptyArrayKeys[section-1] isEqualToString:@"attribute_groups"]) {
                return 0;
            }
            return 30;
            break;
    }
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    UILabel *label = [[UILabel alloc] initWithFrame:header.frame];
//    label.text = @"Test cart text header view";
//    [header addSubview:label];
//    return header;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if (_product.uid == nil || [_product.uid isEqual:@"(null)"]) {
                    return 70;
                }
                return 250;
                break;
            case 1:
                return 120;
                break;
                
            default:
                break;
        }
        /*
        if (_product.images.count > 0) {
            NSDictionary *imageProperties = [PropertyUtil getPropertiesForRemoteImageWithUrlString:_product.images[0]];
            return [[imageProperties valueForKey:@"PixelHeight"] floatValue] / 2;
        } else if (_product.image) {
            NSDictionary *imageProperties = [PropertyUtil getPropertiesForRemoteImageWithUrlString:_product.image];
            return [[imageProperties valueForKey:@"PixelHeight"] floatValue] / 2;
        }
        //if no image on server - return default NoImage height (suppose 250); */
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int numberOfSections = 0;
    //at least we have one section with image
    numberOfSections += 1;
    
    //but may be we have any other section - each section (except first one) are means Array-styled key of product like Options, Discount or Attributes
    if (shownOnScreenNotEmptyArrayKeys && shownOnScreenNotEmptyArrayKeys.count > 0) {
        numberOfSections += [shownOnScreenNotEmptyArrayKeys count];
    }

    
    return numberOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    if (section == 0) {

        //Expected imageCell in first row and buyCell in second row and Description cell in last row of this section
        numberOfRows += 2;
        if (_product.descriptions && _product.descriptions.length > 0) {
            numberOfRows += 1;
        }


        if (shownOnScreenNotEmptyKeys && shownOnScreenNotEmptyKeys.count > 0) {
            numberOfRows += [shownOnScreenNotEmptyKeys count];
        }
                                             
        return numberOfRows;
    } else {
        if (sortedShownNotEmptyArrayKeys && sortedShownNotEmptyArrayKeys.count > 0) {
            
            NSString *currentSectionName = sortedShownNotEmptyArrayKeys[section - 1];
            if ([currentSectionName isEqualToString:@"attribute_groups"]) {
                //Description cell is in Attributes section
                /*
                NSArray *attrGroups = [_product valueForKey:currentSectionName];
                arrayOfAttributesForTableView = [[NSMutableArray alloc] init];
                for (AttributeGroupEntity *attrGroup in attrGroups) {

                    //Adding AttrGroup in TableView
                    [arrayOfAttributesForTableView addObject:attrGroup];
                    
                    if ([attrGroup.attribute isKindOfClass:[NSArray class]]) {
                        //Count of attributes inside attribute group
                        [arrayOfAttributesForTableView addObjectsFromArray:attrGroup.attribute];
                    }
                }
                //Return AttrArray section number of rows
                numberOfRows += [arrayOfAttributesForTableView count];
                 */
                numberOfRows += 1;
                return numberOfRows;
            }
            
            //Here we are counting number of Array-style properties (except Attributes Array)
            numberOfRows += [[_product valueForKey:currentSectionName] count];
            return numberOfRows;
            }
        }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@": "];
    if (indexPath.section == 0) {
        //Image cell always first
        if (indexPath.row == 0) {
            ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"images" forIndexPath:indexPath];
            if (_product.image && ![_product.image isKindOfClass:[NSNull class]]) {
                [cell.customImageView sd_setImageWithURL:_product.image placeholderImage:[UIImage imageNamed:@"noImage"]];
            } else if (_product.images) {
                NSString *imageUrlString = [_product.images[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [cell.customImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"noImage"]];
            } else if (_product.thumb && ![_product.thumb isKindOfClass:[NSNull class]]) {
                    [cell.customImageView sd_setImageWithURL:_product.thumb placeholderImage:[UIImage imageNamed:@"noImage"]];
            } else {
                [cell.customImageView setImage:[UIImage imageNamed:@"noImage"]];
                [cell.customImageView setContentMode:UIViewContentModeScaleAspectFit];
            }
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotos)];
            [cell.customImageView addGestureRecognizer:tapGR];
            
            cell.customImageView.layer.masksToBounds = YES;
            cell.priceView.hidden = !_product.special;
            cell.backgroundColor = [UIColor whiteColor];
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            return cell;
        } else if (indexPath.row == 1){
            BuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyCell" forIndexPath:indexPath];
            
            if (_product.uid == nil || [_product.uid isEqual:@"(null)"]) {
                self.navigationItem.rightBarButtonItem = nil;
                cell.btnAdd.hidden = YES;
                cell.btnBuyNow.hidden = YES;
            }

            cell.btnAdd.layer.cornerRadius = 3.0f;
            cell.btnAdd.layer.masksToBounds = YES;
            cell.btnBuyNow.layer.cornerRadius = 3.0f;
            cell.btnBuyNow.layer.masksToBounds = YES;
            cell.btnCall.layer.cornerRadius = 3.0f;
            cell.btnCall.layer.masksToBounds = YES;
            _priceLabelOverTheImage = cell.priceLabel;
            cell.backgroundColor = [UIColor whiteColor];
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            
            RatingView* starRating = [cell viewWithTag:1844];
            if (!starRating) {
                starRating = [[RatingView alloc] initWithFrame:cell.starRatingFrameView.bounds
                                             selectedImageName:@"selectedStar"
                                               unSelectedImage:@"unSelectedStar"
                                                      minValue:0
                                                      maxValue:5
                                                 intervalValue:0.5
                                                    stepByStep:NO];
                starRating.tag = 1844;
                [cell.starRatingFrameView addSubview:starRating];
            }
            int quantity = [_product.quantity intValue];
            starRating.value = quantity > 5 ? 5 : quantity;
            starRating.userInteractionEnabled = NO;

            return cell;
        } else if (indexPath.row < sortedShownNotEmptyKeys.count + 2){
            //key-value style cells
            //rows from 1..
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyValue" forIndexPath:indexPath];
            NSString *key = sortedShownNotEmptyKeys[indexPath.row - 2];
            id value;
            NSAttributedString *attributedKey = [[NSAttributedString alloc] initWithString:@""];
            NSAttributedString *attributedValue = [[NSAttributedString alloc] initWithString:@""];
            NSMutableAttributedString *cellText = [NSMutableAttributedString new];
            if ([key isKindOfClass:[NSString class]]) {
                value = [_product valueForKey:key];
                attributedKey = [[NSAttributedString alloc] initWithString: NSLocalizedString(key, @"keyValue parameter name") attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
                if ([key isEqualToString:@"price"]) {
                    if (!haveSpecial) {
                        _priceLabelOverTheImage.text = [_product valueForKey:key];
                    }
                    _priceCell = cell;
                }
                if ([key isEqualToString:@"special"]) {
                    haveSpecial = YES;
                    _priceLabelOverTheImage.text = [_product valueForKey:key];

                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[_product valueForKey:@"price"]];
                    [attributedString addAttribute: NSStrikethroughStyleAttributeName
                                             value: [NSNumber numberWithInt:2]
                                             range: NSMakeRange(0,[_priceLabelOverTheImage.text length])];
                    attributedValue = attributedString;
                }
            }
            if ([value isKindOfClass:[NSString class]]) {
                attributedValue = [[NSAttributedString alloc] initWithString:value];
            } else {
                attributedValue = [[NSAttributedString alloc] initWithString:value];
            }
            [cellText appendAttributedString:attributedKey];
            [cellText appendAttributedString:separator];
            [cellText appendAttributedString:attributedValue];
            cell.textLabel.attributedText = cellText;
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            return cell;

        } else if (indexPath.row == sortedShownNotEmptyKeys.count + 2) {
            //first cell in this section is Description
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"description" forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"description", nil);
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            return cell;
        }
    } else {
        //Show arrayKeys
        NSArray *currentArrayKey = [_product valueForKey: sortedShownNotEmptyArrayKeys[indexPath.section - 1]];
        NSAttributedString *attributedKey = [[NSAttributedString alloc] initWithString:@""];
        NSAttributedString *attributedValue = [[NSAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *cellText = [NSMutableAttributedString new];

        if ([[currentArrayKey firstObject] isKindOfClass:[DiscountEntity class]]) {
            //Cell discount
            DiscountEntity *discount = currentArrayKey[indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyValue" forIndexPath:indexPath];
            [cell setIndentationLevel:0];
            attributedKey = [[NSAttributedString alloc] initWithString:discount.quantity];
;
            attributedValue = [[NSAttributedString alloc] initWithString:discount.price];
            cell.textLabel.attributedText = cellText;
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            return cell;

        }
        //Options section
        if ([[currentArrayKey firstObject] isKindOfClass:[OptionEntity class]]) {
            //Cell option
            optionsSection = indexPath.section;
            OptionEntity *optionToDisplay = currentArrayKey[indexPath.row];
            OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"option" forIndexPath:indexPath];
            [cell setIndentationLevel:0];
            attributedKey = [[NSAttributedString alloc] initWithString:optionToDisplay.name attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];

            NSString *allValues = @"";
            if (_product.option && _product.option.count > 0) {
                for (int i = 0; i<_product.option.count; i++) {
                    OptionValueEntity *optionValue = _product.option[i];
                    if ([optionValue.parent isEqual:optionToDisplay]) {
                        if (optionValue.parent == optionToDisplay) {
                            NSString *value = [NSString stringWithFormat:@"%@ (%@%@)", optionValue.name, optionValue.price_prefix, optionValue.price];
                            if (i != _product.option.count - 1) {
                                value = [NSString stringWithFormat:@"%@\n", value];
                            }
                            allValues = [allValues stringByAppendingString:value];
                        }
                    }
                }
            }
            if (allValues.length > 3) allValues = [allValues substringToIndex:[allValues length] - 2];
            cell.optionNameLabel.attributedText = attributedKey;
            cell.optionValueLabel.text = allValues;
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            return cell;
        }
        //Attributes section
        /*
        if ([[currentArrayKey firstObject] isKindOfClass:[AttributeGroupEntity class]]) {
            //Cell attribute object (Attribute Group or Attribute self)
            id attributeCellObect = arrayOfAttributesForTableView[indexPath.row];
            
            if ([attributeCellObect isKindOfClass:[AttributeGroupEntity class]]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                [cell setIndentationLevel:0];
                attributedValue = [[NSAttributedString alloc] initWithString:[(AttributeGroupEntity *)attributeCellObect name]];
                cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
                cell.textLabel.attributedText = attributedValue;
                return cell;

            } else if ([attributeCellObect isKindOfClass:[AttributeEntity class]]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyValue" forIndexPath:indexPath];
                [cell setIndentationLevel:1];
                attributedKey = [[NSAttributedString alloc] initWithString:[(AttributeEntity *)attributeCellObect name]];
                attributedValue = [[NSAttributedString alloc] initWithString:[(AttributeEntity *)attributeCellObect text]];
                [cellText appendAttributedString:attributedKey];
                [cellText appendAttributedString:separator];
                [cellText appendAttributedString:attributedValue];
                cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
                cell.textLabel.attributedText = cellText;
                return cell;

            } else {
                //Insurance that are no other type objects in array
                UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
                emptyCell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
                return emptyCell;
            }

        }
         */
        if ([[currentArrayKey firstObject] isKindOfClass:[AttributeGroupEntity class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attributes" forIndexPath:indexPath];
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Attributes", nil)];
            return cell;

        }
    }

    UITableViewCell *emptyCell = [[UITableViewCell alloc] init];

    emptyCell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);

    return emptyCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == optionsSection) {
        selectedOption = _product.options[indexPath.row];
    }
    if (!_quantitySelectorView.hidden) {
        [self hideQuantitySelector];
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showPhotos];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OptionSelector Delegate
- (void)didSelectedOptions:(NSMutableArray *)options {

    _product.option = options;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
}

#pragma mark - alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertProductAddedSuccessfully) {
        if (buttonIndex == ButtonGoToCart) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToBasket" object:nil];
        }
    }
}

#pragma mark - QuantitySelector Delegate
- (void) didSelectNumberToAdd:(NSInteger)quantity {
    [self hideQuantitySelector];
    [SVProgressHUD show];
    [[RestClient sharedInstance] postEntity:[ProductEntity new]
                                     atPath:@"/api/rest/cart"
                                    keyPath:@"product"
                             withParameters:@{@"product_id": self.product.uid,
                                              @"quantity" : @(quantity),
                                              @"option" : [self.product optionsDict]}
                                    success:^(id result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [SVProgressHUD dismiss];
                                            if ([result isKindOfClass:[NSArray class]]) {
                                                ProductEntity *prod = [(NSArray*)result firstObject];
                                                NSString *string = [NSString stringWithFormat:@"%@ %@", prod.name, NSLocalizedString(@"added to cart", nil)];
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cart", nil)
                                                                                                message:string
                                                                                               delegate:self
                                                                                      cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                                                      otherButtonTitles:NSLocalizedString(@"Go to cart", nil), nil];
                                                alert.tag = AlertProductAddedSuccessfully;
                                                [alert show];
                                            }
                                        });

                                    } failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [SVProgressHUD dismiss];
                                            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                        });
                                    }];
}

- (void) showQuantitySelector {
//    [_quantitySelectorView removeConstraints:[_quantitySelectorView constraints]];
    _quantitySelectorView.hidden = NO;
    _quantitySelectorView.alpha = 0;
//    _quantitySelectorView.frame = nullFrame;
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         _quantitySelectorView.frame = fullFrame;
                         _quantitySelectorView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];

}

- (void) hideQuantitySelector {
//    [_quantitySelectorView removeConstraints:[_quantitySelectorView constraints]];
//    _quantitySelectorView.frame = fullFrame;
    _quantitySelectorView.alpha = 1;
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         _quantitySelectorView.frame = nullFrame;
                         _quantitySelectorView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         _quantitySelectorView.hidden = YES;
                     }];
    
}

#pragma mark - MWPhoto

-(void)showPhotos {
    if (!_product.image && _product.images.count == 0) {
        return;
    }
    photos = [NSMutableArray new];
    [photos addObject:[[MWPhoto alloc] initWithURL:_product.image]];
    for (NSString *str in _product.images) {
        NSString *imageUrlString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [photos addObject:[[MWPhoto alloc] initWithURL:[NSURL URLWithString:imageUrlString]]];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Optionally set the current visible photo before displaying
//    [browser setCurrentPhotoIndex:1];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:browser];
    navCon.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:navCon animated:YES completion:^{
        NSLog(@"Photos!!!");
    }];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDescription"]) {
        if ([[segue destinationViewController] isKindOfClass:[ProductDescriptionViewController class]]) {
            ProductDescriptionViewController *nextVC = [segue destinationViewController];
            nextVC.descriptionProduct = _product.descriptions;
        }

    }
    if ([[segue identifier] isEqualToString:@"showAttributes"]) {
        if ([[segue destinationViewController] isKindOfClass:[ProductAttributesViewController class]]) {
            ProductAttributesViewController *nextVC = [segue destinationViewController];
            nextVC.product = _product;
            nextVC.sortedShownNotEmptyArrayKeys = sortedShownNotEmptyArrayKeys;
        }
        
    }

    if ([segue.identifier isEqualToString:@"selectOption"]) {
        if ([[segue destinationViewController] isKindOfClass:[ProductOptionSelectorViewController class]]) {
            ProductOptionSelectorViewController *nextVC = [segue destinationViewController];
            nextVC.currentOption = selectedOption;
            nextVC.choosedByUserOptions = _product.option;
            nextVC.delegate = self;
            
        }
    }

}


#pragma mark Cart methods
- (IBAction)addToCart:(id)sender {
    if (_quantitySelectorView.hidden) {
        [self showQuantitySelector];
    } else {
        [self hideQuantitySelector];
    }
}

- (IBAction)addOneToCart:(UIButton *)sender {
    [self didSelectNumberToAdd:1];
}

- (IBAction)buyNow:(UIButton *)sender {
    [self didSelectNumberToAdd:1];
}

- (IBAction)callToSeller:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"88002000000"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Your device doesn't support this feature.", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

-(void)addingProductToCartWithError:(NSError *)error {
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
    NSString *message = @"";
    if ([error.userInfo isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [error.userInfo allKeys]) {
            if ([[error.userInfo objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                for (NSString *key1 in [error.userInfo objectForKey:key]) {
                    NSString *str = [NSString stringWithFormat:@"%@: %@ \n", key1, [[error.userInfo objectForKey:key] objectForKey:key1]];
                    message = [message stringByAppendingString:str];
                }
            } else {
                NSString *str = [NSString stringWithFormat:@"%@: %@ \n", key, [error.userInfo objectForKey:key]];
                message = [message stringByAppendingString:str];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:message];
    });

}
@end
