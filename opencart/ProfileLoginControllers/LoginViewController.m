//
//  LoginViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "Configurator.h"
#import "UserInstance.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISwitch *savePasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *savePasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgotButton;

@end

@implementation LoginViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPressed:) name:kLoginStatusChanged object:nil];
    
    self.savePasswordButton.onTintColor = [Configurator getStyleColor];
    self.savePasswordLabel.text = NSLocalizedString(@"Save pasword", nil);
    
    self.signButton.tintColor = [Configurator getBorderColor];
    self.registerButton.tintColor = [Configurator getBorderLightColor];


    self.username.text = [UserInstance sharedInstance].email;
    self.password.text = [[UserInstance sharedInstance] password];
    self.savePasswordButton.on = [UserInstance sharedInstance].savePassword;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInPressed:(id)sender {
    [[UserInstance sharedInstance] loginWithUsername:self.username.text andPassword:self.password.text];
}


- (IBAction)cancelPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(canceledLoginVC)]) {
        [self.delegate canceledLoginVC];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)forgotPasswordPressed:(id)sender {
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)savePasswordValueChanged:(UISwitch*)sender {
    [UserInstance sharedInstance].savePassword = sender.isOn;
}

- (IBAction)forgotPasswordAction:(id)sender {
    [[UserInstance sharedInstance] forgotPassword:self.username.text];
    
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
