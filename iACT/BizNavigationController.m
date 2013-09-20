//
//  BizNavigationController.m
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "BizNavigationController.h"
#import "HomepageTabBarController.h"
#import "AreaListTableViewController.h"
#import "IACTViewController.h"

@interface BizNavigationController ()

@end

@implementation BizNavigationController

@synthesize uid;
@synthesize areaID_;
@synthesize areaName_;

@synthesize broadcastTime;
@synthesize packageID;
@synthesize packageName;
@synthesize packagePrice;
@synthesize packageSpotType;
@synthesize packagePlayNumber;
@synthesize packageBeginTime;
@synthesize packageEndTime;
@synthesize packageDescription;

@synthesize IDSubtitle;
@synthesize nameSubtitle;
@synthesize priceSubtitle;
@synthesize spotTypeSubtitle;
@synthesize playNumberSubtitle;
@synthesize beginTimeSubtitle;
@synthesize endTimeSubtitle;
@synthesize descriptionSubtitle;

@synthesize IDImage;
@synthesize nameImage;
@synthesize priceImage;
@synthesize spotTypeImage;
@synthesize playNumberImage;
@synthesize beginTimeImage;
@synthesize endTimeImage;
@synthesize descriptionImage;

@synthesize balance;

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
    self.uid = ((HomepageTabBarController  *)self.parentViewController).uid;
    // NSLog(@"NAV %@", UID);
    self.balance = [[NSString alloc] init];
    self.balance = ((HomepageTabBarController  *)self.parentViewController).balance;
    self.areaID_ = [[NSString alloc] init];
    self.areaName_ =  [[NSString alloc] init];
    
}

- (void)viewDidUnload
{
    [self setUid:nil];
    [self setAreaID_:nil];
    [self setAreaName_:nil];
    
    [self setBroadcastTime:nil];
    [self setPackageID:nil];
    [self setPackageName:nil];
    [self setPackagePrice:nil];
    [self setPackageSpotType:nil];
    [self setPackagePlayNumber:nil];
    [self setPackageBeginTime:nil];
    [self setPackageEndTime:nil];
    [self setPackageDescription:nil];
    
    [self setIDImage:nil];
    [self setNameImage:nil];
    [self setPriceImage:nil];
    [self setSpotTypeImage:nil];
    [self setPlayNumberImage:nil];
    [self setPlayNumberImage:nil];
    [self setBeginTimeImage:nil];
    [self setEndTimeImage:nil];
    [self setDescriptionImage:nil];
    
    [self setIDSubtitle:nil];
    [self setNameSubtitle:nil];
    [self setPriceSubtitle:nil];
    [self setSpotTypeSubtitle:nil];
    [self setPlayNumberSubtitle:nil];
    [self setPlayNumberSubtitle:nil];
    [self setBeginTimeSubtitle:nil];
    [self setEndTimeSubtitle:nil];
    [self setDescriptionSubtitle:nil];
    
    [self setBalance:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
