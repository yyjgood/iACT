//
//  imageViewController.h
//  iACT
//
//  Created by yyj on 1/27/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateViewController.h"

@interface imageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{

IBOutlet UIImageView* imgView;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *imageString;
@property(nonatomic) Boolean dateStatus;
@property (nonatomic) Boolean imageStatus;
@property (nonatomic) Boolean dateVisible;

@property (weak, nonatomic) IBOutlet UITextField *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *price;




- (IBAction)sendImage:(id)sender;
- (IBAction)showDateImage:(id)sender;
-(void)showChosenDate:(NSDate *)chosenDate;


@end
