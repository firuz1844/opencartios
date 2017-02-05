//
//  ShippingViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "GuestCheckoutViewController.h"
#import "ShippingTableViewCell.h"
#import "Configurator.h"
#import "SVProgressHUD.h"

#import "RESideMenu.h"

@interface GuestCheckoutViewController () {
    UIRefreshControl *refreshControl;
    NSDictionary *shippingData;
}

@end

@implementation GuestCheckoutViewController

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
    
    [Configurator applyDesignStyleForViewController:self];
    
    _firstName.delegate = self;
    _lastName.delegate = self;
    _email.delegate = self;
    _phone.delegate = self;
    _country.delegate = self;
    _region.delegate = self;
    _city.delegate = self;
    _address1.delegate = self;
    _address2.delegate = self;
    _postcode.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self                                                                                action:@selector(dismiss)];


}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.tableView viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    if (textField.tag == 10) {
        [self confirmOrder:textField];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


- (void) didSimpleConfirmCart:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        NSLog(@"Cart order confirmed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                        message:message delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

//errors
- (void) registeringGuestUserError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    NSLog(@"Cannot register guest user: %@", error.userInfo);
    NSString *message = @"";
    if ([error.userInfo isKindOfClass:[NSString class]]) {
        message = (NSString *) error.userInfo;
    } else if ([error.userInfo isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [error.userInfo allKeys]) {
            message = [message stringByAppendingString:[error.userInfo objectForKey:key]];
            message = [message stringByAppendingString:@"\n"];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
        [alert show];
    });
}

-(void) didSetGuestShippingAddressWithError:(NSError *)error {
    NSLog(@"Error set guest shipping address: %@", error.localizedDescription);
}
- (void) didSimpleSaveCartWithError:(NSError *)error {
    NSLog(@"Error save cart: %@", error.localizedDescription);
}

- (void) didSimpleConfirmCartWithError:(NSError *)error {
    NSLog(@"Error confirm cart: %@", error.localizedDescription);
}

#pragma mark TableView Delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    ShippingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShippingCell" forIndexPath:indexPath];
//    return cell;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
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

- (IBAction)confirmOrder:(id)sender {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Confirming your order", nil)];

    NSDictionary *guestDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             _address1.text, @"address_1",
                              _address2.text, @"address_2",
                              _city.text, @"city",
                              @"", @"company_id",
                              @"", @"company",
                              @"176", @"country_id",
                              _email.text, @"email",
                              @"", @"fax",
                              _firstName.text, @"firstname",
                              _lastName.text, @"lastname",
                              _postcode.text, @"postcode",
                              @"", @"tax_id",
                              _phone.text, @"telephone",
                              @"2768", @"zone_id",
                              nil];
//    [_manager registerGuestUser:guestDic];
    shippingData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              _address1.text, @"address_1",
                              _address2.text, @"address_2",
                              _city.text, @"city",
                              @"", @"company_id",
                              @"", @"company",
                              @"176", @"country_id",
                              _firstName.text, @"firstname",
                              _lastName.text, @"lastname",
                              _postcode.text, @"postcode",
                              @"2768", @"zone_id",
                              nil];

}

@end
