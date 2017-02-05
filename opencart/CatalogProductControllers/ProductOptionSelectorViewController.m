//
//  ProductOptionSelectorViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/27/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ProductOptionSelectorViewController.h"
#import "OptionValueEntity.h"
#import "Configurator.h"

@interface ProductOptionSelectorViewController () {
}

@end

@implementation ProductOptionSelectorViewController

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

    self.title = _currentOption.name;
    NSLog(@"Option type: %@", _currentOption.type);

}

- (NSMutableArray*)choosedByUserOptions {
    if (!_choosedByUserOptions) {
        _choosedByUserOptions = [[NSMutableArray alloc] initWithCapacity:[_currentOption.option_value count]];
    }
    return _choosedByUserOptions;
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_currentOption.option_value isKindOfClass:[NSArray class]]) {
        return [_currentOption.option_value count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentOption.option_value isKindOfClass:[NSArray class]]) {
        OptionValueEntity *optionValue = _currentOption.option_value[indexPath.row];
        
        if ([_currentOption.type isEqualToString:@"select"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
//            [cell setIndentationLevel:5];
            cell.textLabel.text = optionValue.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", optionValue.price_prefix, optionValue.price];
            
            if ([self.choosedByUserOptions containsObject:optionValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            return cell;
        }
        if ([_currentOption.type isEqualToString:@"radio"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radio" forIndexPath:indexPath];
//            [cell setIndentationLevel:0];
            cell.textLabel.text = optionValue.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", optionValue.price_prefix, optionValue.price];
            
            if ([self.choosedByUserOptions containsObject:optionValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            return cell;
        }
        if ([_currentOption.type isEqualToString:@"checkbox"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkbox" forIndexPath:indexPath];
//            [cell setIndentationLevel:0];
            cell.textLabel.text = optionValue.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", optionValue.price_prefix, optionValue.price];
            
            if ([self.choosedByUserOptions containsObject:optionValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            return cell;
        }
    }
    UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
    return emptyCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentOption.option_value isKindOfClass:[NSArray class]]) {
        OptionValueEntity *optionValue = _currentOption.option_value[indexPath.row];

        if ([_currentOption.type isEqualToString:@"select"]) {
            for (OptionValueEntity *obj in [self.choosedByUserOptions mutableCopy]) {
                if ([obj.parent.type isEqualToString:@"select"] && [obj.parent.product_option_id isEqualToString:self.currentOption.product_option_id]) {
                    [self.choosedByUserOptions removeObject:obj];
                }
            }
            [self.choosedByUserOptions addObject:optionValue];
            [self.delegate didSelectedOptions:self.choosedByUserOptions];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([_currentOption.type isEqualToString:@"radio"]) {
            for (OptionValueEntity *obj in [self.choosedByUserOptions mutableCopy]) {
                if ([obj.parent.type isEqualToString:@"radio"]) {
                    [self.choosedByUserOptions removeObject:obj];
                }
            }
            [self.choosedByUserOptions addObject:optionValue];
            [self.delegate didSelectedOptions:self.choosedByUserOptions];
        }
        
        if ([_currentOption.type isEqualToString:@"checkbox"]) {
            if ([self.choosedByUserOptions containsObject:optionValue]) {
                [self.choosedByUserOptions removeObject:optionValue];
            } else {
                [self.choosedByUserOptions addObject:optionValue];
            }
            [self.delegate didSelectedOptions:self.choosedByUserOptions];
        }
        [tableView reloadData];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
