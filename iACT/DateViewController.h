//
//  DateViewController.h
//  iACT
//
//  Created by hongyang on 13-1-30.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageViewController.h"

@interface DateViewController : UIViewController

@property (strong, nonatomic) id delegate;
- (IBAction)setDateImage:(id)sender;
- (IBAction)dismissDateImage:(id)sender;

@end
