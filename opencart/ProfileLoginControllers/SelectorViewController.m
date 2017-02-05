//
//  SelectorViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 12.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "SelectorViewController.h"
#import "Configurator.h"
#import "RegionEntity.h"
#import "RestClient.h"

static NSString * const kAddresItemCellIdentifier = @"addressItem";

@interface SelectorViewController ()

@property (nonatomic, strong) NSArray<MappedEntity*> *items;

@end

@implementation SelectorViewController

@synthesize popoverController = __popoverController;
@synthesize rowDescriptor = _rowDescriptor;

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path;
    NSString *keyPath;
    NSDictionary *params;
    MappedEntity *entity;
    if ([self.rowDescriptor.value isKindOfClass:[CountryEntity class]]) {
        // Loading all countries
        
        keyPath = @"data";
        path = @"/api/rest/countries";
        entity = [CountryEntity new];
        
    } else if ([self.rowDescriptor.value isKindOfClass:[RegionEntity class]]) {
        // Loading zones

        RegionEntity *region = self.rowDescriptor.value;
        path = [NSString stringWithFormat:@"/api/rest/countries/%@", region.country_id];
        keyPath = @"data.zone";
        entity = [RegionEntity new];
        
    }
    
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:entity
                                       atPath:path
                                      keyPath:keyPath
                               withParameters:params
                                      success:^(id result) {
                                          if ([result isKindOfClass:[NSArray class]]) {
                                              SelectorViewController *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  strongSelf.items = result;
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [strongSelf updateViews];
                                                  });

                                              }
                                          }
                                      } failure:^(NSError *error) {
                                          NSLog(@"%@", error);
                                      }];
}

- (void)updateViews {
    [self.tableView reloadData];
    __block XLFormRowDescriptor *row= self.rowDescriptor.value;
    NSUInteger selectedRowIndex;
    if ([self.rowDescriptor.value isKindOfClass:[CountryEntity class]]) {
        selectedRowIndex = [self.items indexOfObjectPassingTest:^BOOL(MappedEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [[(CountryEntity*)obj country_id] isEqualToString:[(CountryEntity*)row country_id]];
        }];
    } else if ([self.rowDescriptor.value isKindOfClass:[RegionEntity class]]) {
        selectedRowIndex = [self.items indexOfObjectPassingTest:^BOOL(MappedEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [[(RegionEntity*)obj zone_id] isEqualToString:[(RegionEntity*)row zone_id]];
        }];
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:selectedRowIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddresItemCellIdentifier];
    
    MappedEntity *item = [self.items objectAtIndex:indexPath.row];
    BOOL selected = NO;
    if ([item isKindOfClass:[CountryEntity class]]) {
        cell.textLabel.text = [(CountryEntity*)item name];
        selected = [ [(CountryEntity*)self.rowDescriptor.value country_id] isEqual: [(CountryEntity*)item country_id]];

    } else if ([item isKindOfClass:[RegionEntity class]]) {
        cell.textLabel.text = [(RegionEntity*)item name];
        selected = [ [(RegionEntity*)self.rowDescriptor.value zone_id] isEqual: [(RegionEntity*)item zone_id]];
    }
    if (selected) {
        cell.textLabel.textColor = [Configurator getStyleColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MappedEntity *selectedItem = self.items[indexPath.row];
    self.rowDescriptor.value = selectedItem;
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
