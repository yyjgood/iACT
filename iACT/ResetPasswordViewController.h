//
//  ResetPasswordViewController.h
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

- (IBAction)resetPassword:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
