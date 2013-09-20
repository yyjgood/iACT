//
//  HomepageTabBarController.m
//  iACT
//
//  Created by yyj on 1/24/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "HomepageTabBarController.h"
#import "IACTViewController.h"
#import "RegisterViewController.h"

@interface HomepageTabBarController ()

@end

@implementation HomepageTabBarController
@synthesize uid;
@synthesize mobileNumber;

@synthesize balance;
@synthesize level;
@synthesize credit;
@synthesize phoneVerify;
@synthesize orderCount;
@synthesize prepaidAmount;

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
    self.uid = [[NSString alloc] init];
    self.mobileNumber = [[NSString alloc] init];
    uid = ((IACTViewController *)self.presentingViewController).UID;
    mobileNumber = ((IACTViewController *)self.presentingViewController).userMobileNumber;
    uid = ((RegisterViewController *)self.presentingViewController).UID;
    mobileNumber = ((RegisterViewController *)self.presentingViewController).userMobileNumber;
    //NSLog(@"UID %@",uid);
    //NSLog(@"mobilenum %@",mobileNumber);
    
    self.balance = [[NSString alloc] init];
    self.level = [[NSString alloc] init];
    self.credit = [[NSString alloc] init];
    self.phoneVerify = [[NSString alloc] init];
    self.orderCount = [[NSString alloc] init];
    self.prepaidAmount = [[NSString alloc] init];
    
}

- (void)viewDidUnload
{
    [self setUid:nil];
    
    [self setBalance:nil];
    [self setLevel:nil];
    [self setCredit:nil];
    [self setPhoneVerify:nil];
    [self setOrderCount:nil];
    [self setPrepaidAmount:nil];
    [self setMobileNumber:nil];
    
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
