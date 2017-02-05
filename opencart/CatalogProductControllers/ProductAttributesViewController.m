//
//  ProductAttributesViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 19/12/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ProductAttributesViewController.h"
#import "AttributeEntity.h"
#import "AttributeGroupEntity.h"

@interface ProductAttributesViewController () {
    NSMutableArray *arrayOfAttributesForTableView;
}

@end

@implementation ProductAttributesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRows = 0;
    //Description cell is in Attributes section
    NSArray *attrGroups = [_product valueForKey:@"attribute_groups"];
    arrayOfAttributesForTableView = [[NSMutableArray alloc] init];
    for (AttributeGroupEntity *attrGroup in attrGroups) {
        
        //Adding AttrGroup in TableView
        [arrayOfAttributesForTableView addObject:attrGroup];
        
        if ([attrGroup.attribute isKindOfClass:[NSArray class]]) {
            //Count of attributes inside attribute group
            //                        NSLog(@"In AttGr: %@ %d attribures", attrGroup.name, [attrGroup.attribute count]);
            [arrayOfAttributesForTableView addObjectsFromArray:attrGroup.attribute];
        }
    }
    //Return AttrArray section number of rows
    numberOfRows += [arrayOfAttributesForTableView count];
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyValue" forIndexPath:indexPath];
    
    //Show arrayKeys
    NSArray *currentArrayKey = [_product valueForKey:@"attribute_groups"];
    NSAttributedString *attributedKey = [[NSAttributedString alloc] initWithString:@""];
    NSAttributedString *attributedValue = [[NSAttributedString alloc] initWithString:@""];
    NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@": "];
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    
    //Attributes section
    if ([[currentArrayKey firstObject] isKindOfClass:[AttributeGroupEntity class]]) {
        //Cell attribute object (Attribute Group or Attribute self)
        id attributeCellObect = arrayOfAttributesForTableView[indexPath.row];
        
        if ([attributeCellObect isKindOfClass:[AttributeGroupEntity class]]) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
            [cell setIndentationLevel:0];
            attributedValue = [[NSAttributedString alloc] initWithString:[(AttributeGroupEntity *)attributeCellObect name] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
            cell.textLabel.attributedText = attributedValue;
            return cell;
            
        } else if ([attributeCellObect isKindOfClass:[AttributeEntity class]]) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyValue" forIndexPath:indexPath];
            [cell setIndentationLevel:1];
            attributedKey = [[NSAttributedString alloc] initWithString:[(AttributeEntity *)attributeCellObect name] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
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
    
    UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
    
    emptyCell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 0);
    
    return emptyCell;
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
