//
//  BizNavigationController.h
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BizNavigationController : UINavigationController
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic)NSString *areaID_;
@property (strong, nonatomic)NSString *areaName_;

@property (strong, nonatomic)NSString *broadcastTime;
@property (strong, nonatomic)NSString *packageID;
@property (strong, nonatomic)NSString *packageName;
@property (strong, nonatomic)NSString *packagePrice;
@property (strong, nonatomic)NSString *packageSpotType;
@property (strong, nonatomic)NSString *packagePlayNumber;
@property (strong, nonatomic)NSString *packageBeginTime;
@property (strong, nonatomic)NSString *packageEndTime;
@property (strong, nonatomic)NSString *packageDescription;


@property (nonatomic, strong) NSMutableArray *IDSubtitle;
@property (nonatomic, strong) NSMutableArray *nameSubtitle;
@property (nonatomic, strong) NSMutableArray *priceSubtitle;
@property (nonatomic, strong) NSMutableArray *spotTypeSubtitle;
@property (nonatomic, strong) NSMutableArray *playNumberSubtitle;
@property (nonatomic, strong) NSMutableArray *beginTimeSubtitle;
@property (nonatomic, strong) NSMutableArray *endTimeSubtitle;
@property (nonatomic, strong) NSMutableArray *descriptionSubtitle;


@property (nonatomic, strong) NSMutableArray *IDImage;
@property (nonatomic, strong) NSMutableArray *nameImage;
@property (nonatomic, strong) NSMutableArray *priceImage;
@property (nonatomic, strong) NSMutableArray *spotTypeImage;
@property (nonatomic, strong) NSMutableArray *playNumberImage;
@property (nonatomic, strong) NSMutableArray *beginTimeImage;
@property (nonatomic, strong) NSMutableArray *endTimeImage;
@property (nonatomic, strong) NSMutableArray *descriptionImage;

@property (strong, nonatomic) NSString *balance;


@end
