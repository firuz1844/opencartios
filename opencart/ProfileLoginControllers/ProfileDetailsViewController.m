//
//  ProfileDetailsViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 05.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "ProfileDetailsViewController.h"

#import "ProductEntity.h"
#import "OrderEntity.h"
#import "UserInstance.h"
#import "AddressEntity.h"

#import "RestClient.h"
#import "UIImageView+WebCache.h"


#import "EditAddressViewController.h"

static NSString *kOrderCellIdentifier = @"orderCell";
static NSString *kAccountDetailCellIdentifier = @"accountCell";
static NSString *kFavoriteCellIdentifier = @"favoriteCell";
static NSString *kAddressCellIdentifier = @"addressCell";
static NSString *kDefaultCellIdentifier = @"cell";


@interface ProfileDetailsViewController ()

@property (nonatomic, strong) NSArray<MappedEntity*>*elements;
@property (nonatomic, strong) NSDictionary *accountProperties;

@end

@implementation ProfileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    id entity = nil;
    NSMutableString *path = [[NSMutableString alloc] initWithString:@"/api/rest/"];
    NSMutableString *keyPath = [[NSMutableString alloc] initWithString:@"data"];
    
    switch (self.detailsType) {
        case ProfileDetailsTypeOrders:
            entity = [OrderEntity new];
            [path appendString:@"customerorders"];
//            [keyPath appendString:@".orders"];
            break;
        case ProfileDetailsTypeAddresses:
            entity = [AddressEntity new];
            [path appendString:@"shippingaddress"];
            [keyPath appendString:@".addresses"];
            break;
        case ProfileDetailsTypeFavorites:
            entity = [ProductEntity new];
            [path appendString:@"wishlist"];
            [keyPath appendString:@".products"];
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
            break;
        case ProfileDetailsTypeAccount:
            [self parseUser:[UserInstance sharedInstance]];
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:entity
                                       atPath:path
                                      keyPath:keyPath
                               withParameters:nil
                                      success:^(id result) {
                                          if ([result isKindOfClass:[NSArray class]]) {
                                              [weakSelf handleEntity:result];
                                          }
                                      } failure:^(NSError *error) {
                                          NSLog(@"%@", error);
                                      }];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)handleEntity:(NSArray<MappedEntity*>*)result {
    if ([result isKindOfClass:[NSArray class]]) {
        self.elements = [NSArray arrayWithArray:result];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)parseUser:(UserInstance*)user {
    
    self.accountProperties = [user propertiesAndValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.detailsType == ProfileDetailsTypeAccount) {
        return self.accountProperties.count;
    }
    return self.elements.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifier] forIndexPath:indexPath];
    
    MappedEntity *entity = [self.elements objectAtIndex:indexPath.row];
    if (self.detailsType == ProfileDetailsTypeAccount) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.accountProperties allKeys] objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.accountProperties allValues] objectAtIndex:indexPath.row]];

    } else {
        [self configureCell:&cell withEntity:entity];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.elements.count) {
        MappedEntity *entity = [self.elements objectAtIndex:indexPath.row];
        if ([entity isKindOfClass:[AddressEntity class]]) {
            EditAddressViewController *vc = [EditAddressViewController new];
            vc.address = (AddressEntity*)entity;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (NSString*)reuseIdentifier {
    switch (self.detailsType) {
        case ProfileDetailsTypeOrders:
            return kOrderCellIdentifier;
        case ProfileDetailsTypeAccount:
            return kAccountDetailCellIdentifier;
        case ProfileDetailsTypeAddresses:
            return kAddressCellIdentifier;
        case ProfileDetailsTypeFavorites:
            return kFavoriteCellIdentifier;
    }
    return kDefaultCellIdentifier;
}

- (void)configureCell:(UITableViewCell**)cell withEntity:(MappedEntity*)entity {
    switch (self.detailsType) {
        case ProfileDetailsTypeOrders:{
            OrderEntity *order = (OrderEntity*)entity;
            [[*cell textLabel] setText:[order orderText]];
            [[*cell detailTextLabel] setText:[order orderDetailText]];
            break;
        }
        case ProfileDetailsTypeAccount:{}
            
            break;
        case ProfileDetailsTypeAddresses: {
            AddressEntity *addr = (AddressEntity*)entity;
            [[*cell textLabel] setText:addr.city];
            [[*cell detailTextLabel] setText:addr.firstname];
            break;
        }
        case ProfileDetailsTypeFavorites:{
            ProductEntity *prod = (ProductEntity*)entity;
            [[*cell imageView] sd_setImageWithURL:prod.thumb placeholderImage:[UIImage imageNamed:@"menu"]];
            [[*cell textLabel] setText:prod.name];
            [[*cell detailTextLabel] setText:prod.price];
            break;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
