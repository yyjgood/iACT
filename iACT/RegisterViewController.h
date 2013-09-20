//
//  RegisterViewController.h
//  iACT
//
//  Created by yyj on 1/9/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IACTViewController.h"

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) NSString *UID;
@property (strong, nonatomic) NSString *userMobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberRegister;
@property (weak, nonatomic) IBOutlet UITextField *passWordRegister;
@property (weak, nonatomic) IBOutlet UITextField *passWordRegister2;

- (IBAction)userRegister:(id)sender;
- (IBAction)hideKeyboardRegister:(id)sender;
- (IBAction)backToLogin:(id)sender;
@end
