//
//  AccountViewController.h
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"


@interface AccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *showUserInfo;
- (IBAction)getExpendRecord:(id)sender;
- (IBAction)getPayRecord:(id)sender;
- (IBAction)getUserOrder:(id)sender;
- (IBAction)userPhoneBind:(id)sender;
- (IBAction)secondOrder:(id)sender;
- (IBAction)thirdOrder:(id)sender;
- (IBAction)resetPassword:(id)sender;

@end
