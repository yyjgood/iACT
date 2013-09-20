//
//  DateChooserViewController.h
//  iACT
//
//  Created by hongyang on 13-1-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateChooserViewController : UIViewController

@property (strong, nonatomic) id delegate;

- (IBAction)setDate:(id)sender;
- (IBAction)dismissDateChooser:(id)sender;

@end
