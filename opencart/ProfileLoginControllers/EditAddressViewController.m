//
//  EditAddressViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "EditAddressViewController.h"
#import "Configurator.h"
#import "RestClient.h"
#import "SVProgressHUD.h"

NSString *const kFirstName = @"firstname";
NSString *const kLastName = @"lastname";
NSString *const kCompany = @"company";
NSString *const kAddress1 = @"address1";
NSString *const kAddress2 = @"address2";
NSString *const kCity = @"city";
NSString *const kZipCode = @"zip";
NSString *const kCountry = @"country";
NSString *const kRegionOrState = @"region";

NSString *const kSelectorVCStoryboardID = @"SelectorViewController";


@interface AddressItemTransformer : NSValueTransformer
@end

@implementation AddressItemTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    NSDictionary *user = (NSDictionary *) value;
    return [user valueForKeyPath:@"name"];
}

@end


@interface EditAddressViewController ()

@end

@implementation EditAddressViewController

-(id)init
{
    
    XLFormDescriptor *formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Editing address"];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
//    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Please enter your address"];
    [formDescriptor addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFirstName rowType:XLFormRowDescriptorTypeText title:@"First name:"];
    row.required = YES;
    setColorToRow(&row);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kLastName rowType:XLFormRowDescriptorTypeText title:@"Last name:"];
    row.required = YES;
    setColorToRow(&row);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCompany rowType:XLFormRowDescriptorTypeText title:@"Company:"];
    row.required = NO;
    setColorToRow(&row);
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAddress1 rowType:XLFormRowDescriptorTypeText title:@"Address 1:"];
    row.required = YES;
    setColorToRow(&row);
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAddress2 rowType:XLFormRowDescriptorTypeText title:@"Address 2:"];
    row.required = NO;
    setColorToRow(&row);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCity rowType:XLFormRowDescriptorTypeText title:@"City:"];
    row.required = YES;
    setColorToRow(&row);
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kZipCode rowType:XLFormRowDescriptorTypeZipCode title:@"Postcode(ZIP):"];
    setColorToRow(&row);
    [section addFormRow:row];
    
    // Selector Push
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCountry rowType:XLFormRowDescriptorTypeSelectorPush title:@"Country:"];
    row.action.viewControllerStoryboardId = kSelectorVCStoryboardID;
    row.valueTransformer = [AddressItemTransformer class];
    setColorToRow(&row);
    [section addFormRow:row];
    
    // Selector Push
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kRegionOrState rowType:XLFormRowDescriptorTypeSelectorPush title:@"Region/State:"];
    row.action.viewControllerStoryboardId = kSelectorVCStoryboardID;
    row.valueTransformer = [AddressItemTransformer class];
    [section addFormRow:row];
    section = [XLFormSectionDescriptor formSection];
    setColorToRow(&row);
    [formDescriptor addFormSection:section];
    
    return [super initWithForm:formDescriptor];
    
}

void setColorToRow(XLFormRowDescriptor **row) {
//    [[*row cellConfig] setObject:[UIColor grayColor] forKey:@"textLabel.textColor"];
}

- (void)saveAddress {
    
    [self updateAddresFromRowsValues];
    
    // Update address PUT /api/rest/address/{id}
    if (self.address.address_id) {
        [[RestClient sharedInstance] putEntity:[MappedEntity new]
                                        atPath:[NSString stringWithFormat:@"/api/rest/account/address/%@", self.address.address_id]
                                       keyPath:nil
                                withParameters:[self.address jsonDictionary]
                                       success:^(id result) {
                                           if ([result isKindOfClass:[NSArray class]]) {
                                               MappedEntity *ent = [(NSArray*)result firstObject];
                                               if (ent.success) {
                                                   [SVProgressHUD showSuccessWithStatus:@"Address updated"];
                                               } else {
                                                   [SVProgressHUD showErrorWithStatus:ent.errorMessage];
                                               }
                                           }
                                           
                                       } failure:^(NSError *error) {
                                           NSLog(@"%@", error);
                                       }];
    } else {
        // Create new address POST /api/rest/address
        [[RestClient sharedInstance] postEntity:[MappedEntity new]
                                        atPath:@"/api/rest/account/address"
                                       keyPath:nil
                                withParameters:[self.address jsonDictionary]
                                       success:^(id result) {
                                           if ([result isKindOfClass:[NSArray class]]) {
                                               MappedEntity *ent = [(NSArray*)result firstObject];
                                               if (ent.success) {
                                                   [SVProgressHUD showSuccessWithStatus:@"Address updated"];
                                               } else {
                                                   [SVProgressHUD showErrorWithStatus:ent.errorMessage];
                                               }
                                           }
                                           
                                       } failure:^(NSError *error) {
                                           NSLog(@"%@", error);
                                       }];

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAddress)];
    
    [self setValuesForRows];
}

- (void)setValuesForRows {
    [self.form formRowWithTag:kFirstName].value = self.address.firstname;
    [self.form formRowWithTag:kLastName].value = self.address.lastname;
    [self.form formRowWithTag:kCompany].value = self.address.company;
    [self.form formRowWithTag:kAddress1].value = self.address.address_1;
    [self.form formRowWithTag:kAddress2].value = self.address.address_2;
    [self.form formRowWithTag:kCity].value = self.address.city;
    [self.form formRowWithTag:kZipCode].value = self.address.postcode;
    [self.form formRowWithTag:kCountry].value = self.address.country?:[CountryEntity new];
    [self.form formRowWithTag:kRegionOrState].value = self.address.region?:[RegionEntity new];
}

- (void)updateAddresFromRowsValues {
    self.address.firstname = [self.form formRowWithTag:kFirstName].value ?: @"";
    self.address.lastname = [self.form formRowWithTag:kLastName].value ?: @"";
    self.address.company = [self.form formRowWithTag:kCompany].value ?: @"";
    self.address.address_1 = [self.form formRowWithTag:kAddress1].value ?: @"";
    self.address.address_2 = [self.form formRowWithTag:kAddress1].value ?: @"";
    self.address.city = [self.form formRowWithTag:kCity].value ?: @"";
    self.address.postcode = [self.form formRowWithTag:kZipCode].value ?: @"";
    self.address.country = [self.form formRowWithTag:kCountry].value ?: @"";
    self.address.region = [self.form formRowWithTag:kRegionOrState].value ?: @"";
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    
    if (![oldValue isEqual:[NSNull null]] &&
        [formRow.tag isEqualToString:kCountry] &&
        ![oldValue isEqual:newValue])
    {
        RegionEntity *emptyRegion = [RegionEntity new];
        emptyRegion.country_id = [(CountryEntity*)newValue country_id];
        XLFormRowDescriptor *regionRow = [self.form formRowWithTag:kRegionOrState];
        regionRow.value = emptyRegion;
        [self reloadFormRow:regionRow];
    }
}

-(UIStoryboard *)storyboardForRow:(XLFormRowDescriptor *)formRow
{
    return [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
