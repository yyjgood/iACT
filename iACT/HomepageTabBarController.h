//
//  HomepageTabBarController.h
//  iACT
//
//  Created by yyj on 1/24/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageTabBarController : UITabBarController

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *mobileNumber;

@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *phoneVerify;
@property (strong, nonatomic) NSString *orderCount;
@property (strong, nonatomic) NSString *prepaidAmount;

@end
