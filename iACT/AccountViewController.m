//
//  AccountViewController.m
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "AccountViewController.h"
#import "GdataXMLNode.h"


@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize showUserInfo;
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
    [self showUserDetail]; 
  
}

- (void)viewDidUnload
{
    [self setShowUserInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showUserDetail
{
    NSString *showString;
    showString = [[NSString alloc] initWithFormat:
                   @"%@      等级: %@\n预付金额: ¥%@ 元    \n帐户余额: ¥%@ 元\n订单数目: %@      信用额度: %@",
                   ((MyNavigationController *)self.parentViewController).mobileNumber,
                   ((MyNavigationController *)self.parentViewController).level,
                   ((MyNavigationController *)self.parentViewController).prepaidAmounts,
                   ((MyNavigationController *)self.parentViewController).balance,
                   ((MyNavigationController *)self.parentViewController).orderCount,
                   ((MyNavigationController *)self.parentViewController).credit];
    self.showUserInfo.text = showString;
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
        NSArray *tranStatus = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:UserPhoneBindResponse/ns2:UserPhoneBindResult" namespaces:myNS error:nil];
        if (tranStatus.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [tranStatus objectAtIndex:0];
            int flag = [[firstName stringValue] intValue];
                switch (flag)
                {
                        
                    case 0:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"绑定成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
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
                                     initWithTitle:@"绑定失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    case -5:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"没有更新数据" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                        default: break;
                }
        }else
        {
            showError = [[UIAlertView alloc] initWithTitle:@"网络连接错误或数据丢失" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [showError show];
            
        }
    }
}

-(NSData *)getXML
{
    NSString *str_soap_test = [self makeSoap];
    if (str_soap_test) {
        
        NSURL *url_server = [NSURL URLWithString:@"http://116.55.226.14:9018/iACTMobileInf.asmx"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url_server];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"http://tempuri.org/UserPhoneBind" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[NSString stringWithFormat:@"%d", [str_soap_test length]] forHTTPHeaderField:@"Content-Length"];
        NSMutableData *data_soap_test = [NSMutableData data];
        [data_soap_test appendData:[str_soap_test dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:data_soap_test];
        NSURLResponse *response;
        NSError *err;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        //NSLog(@"    %@", returnString);
        if(returnData)
        {
            return returnData;
        }
        return nil;
        
    }
    return nil;
}
-(NSString *)makeSoap
{
    if([((MyNavigationController *)self.parentViewController).uid intValue] > 0)
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
        [str_soap appendFormat:@"<UserPhoneBind xmlns=\"http://tempuri.org/\">"];
        [str_soap appendFormat:@"<uid>%d</uid>",[((MyNavigationController *)self.parentViewController).uid intValue]];
        [str_soap appendFormat:@"</UserPhoneBind>"];
        [str_soap appendFormat:@"</soap:Body>"];
        [str_soap appendFormat:@"</soap:Envelope>"];
        //NSLog(@"   %@", str_soap);
        return str_soap;
    }
    return nil;
}




                 
- (IBAction)getExpendRecord:(id)sender
{
    [self performSegueWithIdentifier:@"Expend" sender:sender];
}

- (IBAction)getPayRecord:(id)sender {
    [self performSegueWithIdentifier:@"Pay" sender:sender];

}

- (IBAction)getUserOrder:(id)sender {
    
    ((MyNavigationController *)self.parentViewController).orderChoose = 1;
    [self performSegueWithIdentifier:@"UserOrder" sender:sender];

}

- (IBAction)userPhoneBind:(id)sender {
    
    [self parseXML];
}

- (IBAction)secondOrder:(id)sender {
    ((MyNavigationController *)self.parentViewController).orderChoose = 2;
    [self performSegueWithIdentifier:@"UserOrder" sender:sender];
}

- (IBAction)thirdOrder:(id)sender {
    ((MyNavigationController *)self.parentViewController).orderChoose = 3;
    [self performSegueWithIdentifier:@"UserOrder" sender:sender];
}

- (IBAction)resetPassword:(id)sender {
}






@end

