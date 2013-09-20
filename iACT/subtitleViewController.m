//
//  subtitleViewController.m
//  iACT
//
//  Created by yyj on 1/27/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "subtitleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DateChooserViewController.h"
#import "BizNavigationController.h"
#import"GDataXMLNode.h"
#define subtitleMax 50
@interface subtitleViewController ()

@end

@implementation subtitleViewController
@synthesize outputLabel;
@synthesize dateChooserVisible;
@synthesize price;
@synthesize balance;
@synthesize countLabel;
@synthesize textView_;
@synthesize dateStatus;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

        
	// Do any additional setup after loading the view.
    self.textView_.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.textView_.layer.borderWidth =2.0;
    
    self.textView_.layer.cornerRadius =5.0;
    
    self.textView_.delegate = self;
    
    NSString *price_;
    price_ =[[NSString alloc] initWithFormat:@"需付金额: ¥%@ 元", ((BizNavigationController *)self.parentViewController).packagePrice];
    self.price.text = price_;
    
    NSString *balance_;
    balance_ =[[NSString alloc] initWithFormat:@"您的余额: ¥%@ 元", ((BizNavigationController *)self.parentViewController).balance];
    self.balance.text = balance_;
    self.dateStatus = NO;

    
    
}

- (void)viewDidUnload
{
    [self setTextView_:nil];
    [self setOutputLabel:nil];
    [self setPrice:nil];
    [self setBalance:nil];
    [self setCountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendSubtitle:(id)sender
{
    UIAlertView *showError;
    if (self.textView_.text.length <= 0)
    {
       showError = [[UIAlertView alloc] initWithTitle:@"请输入字幕信息" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
       [showError show];
    }else
    {
       /* if (self.textView_.text.length > 50) {
            showError = [[UIAlertView alloc] initWithTitle:@"字幕信息不能超过50字哦" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [showError show];
        }else*/
        {
            if (!self.dateStatus) {
                showError = [[UIAlertView alloc] initWithTitle:@"请输入正确的播出日期" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [showError show];
            }else
            {
                [self parseXML];
            }
        }
    }
}

- (IBAction)showDateChooser:(id)sender
{
    if (self.dateChooserVisible != YES)
    {
        [self performSegueWithIdentifier:@"toDateChooser" sender:sender];
        self.dateChooserVisible = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((DateChooserViewController *)segue.destinationViewController).delegate = self;
}

-(void)showChosenDate:(NSDate *)chosenDate
{
    NSDateFormatter *dateFormat_;
    NSDate *todaysDate;
    int differenceOutput;
	NSString *todaysDateString;
    NSString *chosenDateString;
	NSDateFormatter *dateFormat;
    
	NSTimeInterval difference;
    
    dateFormat_ = [[NSDateFormatter alloc] init];
    [dateFormat_ setDateFormat:@"yyyy'-'MM'-'dd"];
    chosenDateString = [dateFormat_ stringFromDate:chosenDate];
    self.outputLabel.text = chosenDateString;
    
	todaysDate=[NSDate date];
	difference = [chosenDate timeIntervalSinceDate:todaysDate] ;
	//NSLog(@"   %d",(int)difference);
	dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMMM d, yyyy hh:mm:ssa"];
	todaysDateString = [dateFormat stringFromDate:todaysDate];
    chosenDateString = [dateFormat stringFromDate:chosenDate];
    
	differenceOutput=(int) difference;
    
    if ( differenceOutput  < 0 )
    {
        self.dateStatus = NO;
    }else
    {
        self.dateStatus = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
    
-(IBAction)dismissKeyBoard
 {
   [self.textView_ resignFirstResponder];
 }


- (void)textViewDidChange:(UITextView *)textView
{
    NSString  * nsTextContent=textView.text;
    int   existTextNum=[nsTextContent length];
    int subMax = subtitleMax;
    self.countLabel.text = [[NSString alloc] initWithFormat:@"限%d字，还可输入%d字", subMax, subtitleMax -existTextNum];
}


-(void)parseXML
{
    NSData *xmlData = [self getXML];
    UIAlertView *showError;
    if(xmlData)
    {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        NSDictionary *myNS = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"http://schemas.xmlsoap.org/soap/envelope/",@"ns",
                              @"http://tempuri.org/", @"ns2",nil];
        NSArray *tranStatus = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:AddUserOrderResponse/ns2:AddUserOrderResult" namespaces:myNS error:nil];
        if (tranStatus.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [tranStatus objectAtIndex:0];
            int flag = [[firstName stringValue] intValue];

                switch (flag)
                {
                        
                    case 0:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"订单提交成功！" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                        
                    case -1:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"无SOAP认证信息" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -2:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"SOAP认证信息错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -3:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"系统错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -4:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"创建错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -5:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"无写入数据，创建失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                        
                    default:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"创建失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                }
            }
        
    }else
    {
        showError = [[UIAlertView alloc] initWithTitle:@"网络连接错误或数据丢失" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }
}


-(NSData *)getXML
{
    
    NSString *str_soap_test = [self makeSoap];
    NSURL *url_server = [NSURL URLWithString:@"http://116.55.226.14:9018/iACTMobileInf.asmx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url_server];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"http://tempuri.org/AddUserOrder" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [str_soap_test length]] forHTTPHeaderField:@"Content-Length"];
    NSMutableData *data_soap_test = [NSMutableData data];
    [data_soap_test appendData:[str_soap_test dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:data_soap_test];
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
     //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     //NSLog(@"%@", returnString);
    if(returnData)
    {
        return returnData;
    }
    return nil;
    
}

-(NSString *)makeSoap
{
    
    NSMutableString *str_soap = [[NSMutableString alloc] init] ;
    [str_soap appendFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [str_soap appendFormat:@"<soap:Header>"];
    [str_soap appendFormat:@"<BizSoapHeader xmlns=\"http://tempuri.org/\">"];
    
    NSString *userName = @"C93F8E42150FB8A88E28DBC2FC722CF0";
    NSString *passWord_ = @"FE797A1B7E0B058151993B0EE068DC85";
    
    [str_soap appendFormat:@"<UserName>%@</UserName>",userName];
    [str_soap appendFormat:@"<Passowrd>%@</Passowrd>",passWord_];
    [str_soap appendFormat:@"</BizSoapHeader>"];
    [str_soap appendFormat:@"</soap:Header>"];
    [str_soap appendFormat:@"<soap:Body>"];
    [str_soap appendFormat:@"<AddUserOrder xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<uid>%d</uid>",[((BizNavigationController *)self.parentViewController).uid intValue]];
    [str_soap appendFormat:@"<package>%d</package>",[((BizNavigationController *)self.parentViewController).packageID intValue]];
    [str_soap appendFormat:@"<packageinfo>%@</packageinfo>",((BizNavigationController *)self.parentViewController).packageDescription ];
    [str_soap appendFormat:@"<spottype>%@</spottype>",((BizNavigationController *)self.parentViewController).packageSpotType ];
    [str_soap appendFormat:@"<subitle>%@</subitle>",self.textView_.text ];
    [str_soap appendFormat:@"<logodata></logodata>"];
    [str_soap appendFormat:@"<plandate>%@</plandate>",self.outputLabel.text ];
    [str_soap appendFormat:@"<fee>%@</fee>",((BizNavigationController *)self.parentViewController).packagePrice ];

    [str_soap appendFormat:@"</AddUserOrder>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    
    //NSLog(@"%@",str_soap);
    return str_soap;
}

@end
