//
//  MyNavigationController.h
//  iACT
//
//  Created by hongyang on 13-2-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewController.h"

@interface MyNavigationController : UINavigationController


@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *mobileNumber;

@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *phoneVerify;
@property (strong, nonatomic) NSString *orderCount;
@property (strong, nonatomic) NSString *prepaidAmounts;


@property (nonatomic) int dataStatus;
@property (nonatomic) int orderChoose;


@property (strong, nonatomic) NSMutableArray *orderID;
@property (strong, nonatomic) NSMutableArray *addTime;
@property (strong, nonatomic) NSMutableArray *prepaidTime;
@property (strong, nonatomic) NSMutableArray *prepaidAmount;
@property (strong, nonatomic) NSMutableArray *finalpaidTime;
@property (strong, nonatomic) NSMutableArray *finalpaidAmount;
@property (strong, nonatomic) NSMutableArray *paidStatus;


@property (strong, nonatomic) NSMutableArray *orderIDPay;
@property (strong, nonatomic) NSMutableArray *addTimePay;
@property (strong, nonatomic) NSMutableArray *productID;
@property (strong, nonatomic) NSMutableArray *payMode;
@property (strong, nonatomic) NSMutableArray *payAmount;
@property (strong, nonatomic) NSMutableArray *addFee;
@property (strong, nonatomic) NSMutableArray *serialNumber;

@property (strong, nonatomic) NSMutableArray *bizArea;
@property (strong, nonatomic) NSMutableArray *orderID_;
@property (strong, nonatomic) NSMutableArray *orderType;
@property (strong, nonatomic) NSMutableArray *spotType;
@property (strong, nonatomic) NSMutableArray *packageInfo;
//@property (strong, nonatomic) NSMutableArray *subtitle;
//@property (strong, nonatomic) NSMutableArray *logoData;
@property (strong, nonatomic) NSMutableArray *createTime;
@property (strong, nonatomic) NSMutableArray *planDate;
@property (strong, nonatomic) NSMutableArray *planBeginTime;
@property (strong, nonatomic) NSMutableArray *verifyStatus;
@property (strong, nonatomic) NSMutableArray *handleStatus;

-(void)parseXML;
@end
