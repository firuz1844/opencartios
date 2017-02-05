//
//  ProductDescriptionViewController.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/27/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ProductDescriptionViewController.h"
#import "Configurator.h"

@interface ProductDescriptionViewController ()

@end

@implementation ProductDescriptionViewController

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

    NSLog(@"Description: %@", _descriptionProduct);
    self.title = NSLocalizedString(@"Description", nil);
    [_webView loadHTMLString:_descriptionProduct baseURL:[NSURL URLWithString:[Configurator getStoreBaseUrl]]];
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
