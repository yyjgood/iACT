//
//  GetUserOrderViewController.h
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserOrderDateViewController.h"
@interface GetUserOrderViewController : UIViewController

@property (nonatomic) Boolean dateChooserVisible;

@property (nonatomic) int flag;
@property (nonatomic) int flagCount;


@property (weak, nonatomic) IBOutlet UITextField *date;
- (IBAction)query:(id)sender;

- (IBAction)chooseDate:(id)sender;
-(void)showChosenDate:(NSDate *)chosenDate;

@end
