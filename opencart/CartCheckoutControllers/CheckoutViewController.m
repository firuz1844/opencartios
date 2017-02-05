//
//  CheckoutViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 12.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "CheckoutViewController.h"
#import "EditAddressViewController.h"

#import "Configurator.h"
#import "UserInstance.h"
#import "RestClient.h"
#import "SVProgressHUD.h"

#import "ShippingMethodEntity.h"
#import "PaymentMethodEntity.h"

#import "ReactiveCocoa.h"

NSString *const kLoginButton = @"button";
NSString *const kBillingAddr = @"billing";
NSString *const kAddBillingAddr = @"addBilling";
NSString *const kShippingAddr = @"shipping";
NSString *const kAddShippingAddr = @"addShipping";
NSString *const kDeliveryMethod = @"deliveryMethod";
NSString *const kPayment = @"payment";
NSString *const kConfirm = @"confirm";

@interface CheckoutViewController ()

@property (nonatomic, assign) NSUInteger *currentStep;

@property (nonatomic, strong) NSArray *billingAddresses;
@property (nonatomic, strong) NSArray *shippingAddresses;
@property (nonatomic, strong) NSArray *deliveryMethods;
@property (nonatomic, strong) NSArray *paymentMethods;


@end

@implementation CheckoutViewController


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        XLFormDescriptor *formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Checkout"];
        XLFormSectionDescriptor *section;
        XLFormRowDescriptor *row;
        
        if (![UserInstance sharedInstance].loggedIn) {
            section = [XLFormSectionDescriptor formSectionWithTitle:@"Sign in or continue as guest"];
            section.footerTitle = @"By creating an account you will be able to shop faster, be up to date on an order's status, and keep track of the orders you have previously made";
            [formDescriptor addFormSection:section];
            
            row = [XLFormRowDescriptor formRowDescriptorWithTag:kLoginButton rowType:XLFormRowDescriptorTypeButton title:@"Sign in"];
            row.action.formSelector = @selector(signIn:);
            row.required = YES;
            [section addFormRow:row];
        }
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Billing address"];
        [formDescriptor addFormSection:section];
        
        // Selector Push
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kBillingAddr rowType:XLFormRowDescriptorTypeSelectorPush title:@"Select:"];
//        row.valueTransformer = [AddressItemTransformer class];
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kAddBillingAddr rowType:XLFormRowDescriptorTypeButton title:@"Add new address"];
        row.action.formSelector = @selector(addNewAddress:);
        row.required = YES;
        [section addFormRow:row];

        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Shipping address"];
        [formDescriptor addFormSection:section];
        
        
        // Selector Push
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kShippingAddr rowType:XLFormRowDescriptorTypeSelectorPush title:@"Select:"];
//        row.valueTransformer = [AddressItemTransformer class];
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kAddShippingAddr rowType:XLFormRowDescriptorTypeButton title:@"Add new address"];
        row.action.formSelector = @selector(addNewAddress:);
        row.required = YES;
        [section addFormRow:row];

        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Delivery method"];
        [formDescriptor addFormSection:section];
        
        // Selector Push
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDeliveryMethod rowType:XLFormRowDescriptorTypeSelectorPush title:@"Select:"];
//        row.valueTransformer = [AddressItemTransformer class];
        [section addFormRow:row];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Payment method"];
        [formDescriptor addFormSection:section];
        
        
        // Selector Push
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kPayment rowType:XLFormRowDescriptorTypeSelectorPush title:@"Select:"];
//        row.valueTransformer = [AddressItemTransformer class];
        [section addFormRow:row];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Confirmation"];
        [formDescriptor addFormSection:section];
        
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kLoginButton rowType:XLFormRowDescriptorTypeButton title:@"Confirm order"];
        row.action.formSelector = @selector(confirmOrder:);
        row.required = YES;
        [section addFormRow:row];
        
        self.form = formDescriptor;
    }
    
    return self;
    
}

- (void)loadBillingAddresses {
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:[AddressEntity new] atPath:@"/api/rest/paymentaddress" keyPath:@"data.addresses" withParameters:nil success:^(id result) {
        __strong CheckoutViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if ([result isKindOfClass:[NSArray class]]) {
                strongSelf.billingAddresses = (NSArray*)result;
                [strongSelf loadShippingAddresses];
            }
        }
    } failure:^(NSError *error) {
        __strong CheckoutViewController *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.billingAddresses = nil;
        }
        NSLog(@"%@", error);
    }];
}

- (void)setBillingAddresses:(NSArray *)billingAddresses {
    
    _billingAddresses = billingAddresses;
    
    NSMutableArray *selectorOptions = [NSMutableArray new];
    AddressEntity *defaultAddress = nil;
    for (AddressEntity *addr in billingAddresses) {
        [selectorOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:addr displayText:[addr screenName]]];
        if ([addr.address_id isEqualToString:[UserInstance sharedInstance].address_id]) {
            defaultAddress = addr;
        }
    }
    [self.form formRowWithTag:kBillingAddr].value = defaultAddress;
    [self.form formRowWithTag:kBillingAddr].selectorOptions = selectorOptions;
    
    [self.form formRowWithTag:kBillingAddr].disabled = @(billingAddresses.count == 0);
    
    [self.tableView reloadRowsAtIndexPaths:@[[self.form indexPathOfFormRow:[self.form formRowWithTag:kBillingAddr]]] withRowAnimation:UITableViewRowAnimationNone];


}

- (void)loadShippingAddresses {
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:[AddressEntity new] atPath:@"/api/rest/shippingaddress" keyPath:@"data.addresses" withParameters:nil success:^(id result) {
        __strong CheckoutViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if ([result isKindOfClass:[NSArray class]]) {
                strongSelf.shippingAddresses = (NSArray*)result;
                [strongSelf loadDeliveryMethods];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setShippingAddresses:(NSArray *)shippingAddresses {
    
    _shippingAddresses = shippingAddresses;
    
    NSMutableArray *selectorOptions = [NSMutableArray new];
    AddressEntity *defaultAddress = nil;
    for (AddressEntity *addr in shippingAddresses) {
        [selectorOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:addr displayText:[addr screenName]]];
        if ([addr.address_id isEqualToString:[UserInstance sharedInstance].address_id]) {
            defaultAddress = addr;
        }
    }
    [self.form formRowWithTag:kShippingAddr].value = defaultAddress;
    [self.form formRowWithTag:kShippingAddr].selectorOptions = selectorOptions;
    
    [self.form formRowWithTag:kShippingAddr].disabled = @(shippingAddresses.count == 0);
    
    [self.tableView reloadRowsAtIndexPaths:@[[self.form indexPathOfFormRow:[self.form formRowWithTag:kShippingAddr]]] withRowAnimation:UITableViewRowAnimationNone];
    
    
}


- (void)loadDeliveryMethods {
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:[ShippingMethodEntity new] atPath:@"/api/rest/shippingmethods" keyPath:@"data.shipping_methods" withParameters:nil success:^(id result) {
        __strong CheckoutViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if ([result isKindOfClass:[NSArray class]]) {
                strongSelf.deliveryMethods = (NSArray*)result;
                [strongSelf loadPaymentMethods];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setDeliveryMethods:(NSArray *)deliveryMethods {
    
    _deliveryMethods = deliveryMethods;
    
    NSMutableArray *selectorOptions = [NSMutableArray new];

    for (ShippingMethodEntity *deliveryMethod in deliveryMethods) {
        [selectorOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:deliveryMethod displayText:[deliveryMethod screenName]]];
    }
    [self.form formRowWithTag:kDeliveryMethod].selectorOptions = selectorOptions;
    
    [self.form formRowWithTag:kDeliveryMethod].hidden = @(deliveryMethods.count == 0);
    
//    [self.tableView reloadRowsAtIndexPaths:@[[self.form indexPathOfFormRow:[self.form formRowWithTag:kDeliveryMethod]]] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)loadPaymentMethods {
    __weak typeof(self) weakSelf = self;
    [[RestClient sharedInstance] loadEntities:[PaymentMethodEntity new] atPath:@"/api/rest/paymentmethods" keyPath:@"data.payment_methods" withParameters:nil success:^(id result) {
        __strong CheckoutViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if ([result isKindOfClass:[NSArray class]]) {
                strongSelf.paymentMethods = (NSArray*)result;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setPaymentMethods:(NSArray *)paymentMethods {
    
    _paymentMethods = paymentMethods;
    
    NSMutableArray *selectorOptions = [NSMutableArray new];
    
    for (PaymentMethodEntity *paymentMethod in paymentMethods) {
        [selectorOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:paymentMethod displayText:[paymentMethod screenName]]];
    }
    [self.form formRowWithTag:kPayment].selectorOptions = selectorOptions;
    
    [self.form formRowWithTag:kPayment].hidden = @(paymentMethods.count == 0);
    
    //    [self.tableView reloadRowsAtIndexPaths:@[[self.form indexPathOfFormRow:[self.form formRowWithTag:kDeliveryMethod]]] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)confirmOrder:(XLFormRowDescriptor*)sender {
    NSLog(@"%@", sender);
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([newValue isKindOfClass:[XLFormOptionsObject class]]) {
        newValue = [(XLFormOptionsObject*)newValue formValue];
    }
    if (([formRow.tag isEqualToString:kBillingAddr]) && ![newValue isEqual:[NSNull null]] && [newValue isKindOfClass:[AddressEntity class]]) {
    // POST new billing address
        if ([newValue isKindOfClass:[AddressEntity class]]) {
            [[RestClient sharedInstance] postEntity:newValue atPath:@"api/rest/paymentaddress" keyPath:nil withParameters:[newValue jsonForCheckoutBillingAddress] success:^(id result) {
                NSLog(@"%@", result);
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
    }
    if (([formRow.tag isEqualToString:kShippingAddr]) && ![newValue isEqual:[NSNull null]] && [newValue isKindOfClass:[AddressEntity class]]) {
        // POST new shipping address
        [[RestClient sharedInstance] postEntity:newValue atPath:@"api/rest/shippingaddress" keyPath:nil withParameters:[newValue jsonForCheckoutShippingAddress] success:^(id result) {
            NSLog(@"%@", result);
            [self loadDeliveryMethods];
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    
//    if ([self.form formRowWithTag:kBillingAddr].value && [self.form formRowWithTag:kShippingAddr].value) {
//        [self loadDeliveryMethods];
//    }
}



NSArray *steps() {
    return @[kLoginButton,
             kBillingAddr,
             kShippingAddr,
             kDeliveryMethod,
             kPayment,
             kConfirm];
}

- (void)signIn:(XLFormRowDescriptor*)sender {
    if (![[UserInstance sharedInstance] isLoggedIn]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        UINavigationController *nlvc = [sb instantiateViewControllerWithIdentifier:@"login"];
        
        UITableViewCell *view = [sender cellForFormController:self];
        if ([view isKindOfClass:[UIView class]]) {
            nlvc.modalPresentationStyle = UIModalPresentationPopover;
            nlvc.popoverPresentationController.sourceView = view;
            nlvc.popoverPresentationController.sourceRect = view.frame;
        }
        LoginViewController *lvc = [[nlvc viewControllers] firstObject];
        lvc.delegate = self;
        [self.navigationController presentViewController:nlvc animated:YES completion:nil];
    } else {
        [[UserInstance sharedInstance] logout];
    }
}

- (void)addNewAddress:(XLFormRowDescriptor*)sender {
    NSLog(@"%@", sender);
    AddressEntity *entity = [AddressEntity new];
    EditAddressViewController *vc = [EditAddressViewController new];
    vc.address = (AddressEntity*)entity;
    [self.navigationController pushViewController:vc animated:YES];
//    
//    
//    UITableViewCell *view = [sender cellForFormController:self];
//    if ([view isKindOfClass:[UIView class]]) {
//        nlvc.modalPresentationStyle = UIModalPresentationPopover;
//        nlvc.popoverPresentationController.sourceView = view;
//        nlvc.popoverPresentationController.sourceRect = view.frame;
//    }
//    LoginViewController *lvc = [[nlvc viewControllers] firstObject];
//    lvc.delegate = self;
//    [self.navigationController presentViewController:nlvc animated:YES completion:nil];
}

- (void)canceledLoginVC {
    NSLog(@"Canceled login");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Configurator getBackgroundPatternName]]];
    [Configurator applyDesignStyleForViewController:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
    [self loadBillingAddresses];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self loadBillingAddresses];
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
