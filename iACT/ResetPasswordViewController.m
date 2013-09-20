//
//  ResetPasswordViewController.m
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "GdataXMLNode.h"
#import "MyNavigationController.h"
@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

@synthesize phoneNum;

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
}

- (void)viewDidUnload
{
    [self setPhoneNum:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)resetPassword:(id)sender
{
    if (![self checkMobileNumber])
    {
        
        NSString *userLoginResult = [self parseXML];
        UIAlertView *showError;
        if(userLoginResult)
        {
            
            int flag = [userLoginResult intValue];
            switch (flag)
                {
                        
                    case 0:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"重置成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
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
                                     initWithTitle:@"重置失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -5:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"没有更新数据" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -6:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"重置短信发送失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -7:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"重置短信未发送" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    default: break;
                }
            
    }else{
        
    
            showError = [[UIAlertView alloc] initWithTitle:@"请检查网络连接" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [showError show];
    }
}
}

- (IBAction)hideKeyboard:(id)sender {
    [self.phoneNum resignFirstResponder];
    
}

- (BOOL)checkMobileNumber
{
    UIAlertView *showError;
    //NSString *inputError;
    if (phoneNum.text.length==0)
    {
        //inputError = [[NSString alloc] initWithFormat:@"请输入正确的手机号码和密码"];
        showError = [[UIAlertView alloc]
                     initWithTitle:@"手机号码不能为空" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
        return EXIT_FAILURE;
    }
    else if (phoneNum.text.length != 11)
    {
        //inputError = [[NSString alloc] initWithFormat:@"输入的手机号码不是11位"];
        showError = [[UIAlertView alloc]
                     initWithTitle:@"输入的手机号码不是11位" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
        return EXIT_FAILURE;
    }
    else if(![phoneNum.text hasPrefix:@"1"])
    {
        //inputError = [[NSString alloc] initWithFormat:@"输入的手机号码首位不是1"];
        showError = [[UIAlertView alloc]
                     initWithTitle:@"输入的手机号码首位不是1" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
-(NSString *)parseXML
{
    
    NSData *xmlData = [self getXML];
    if(xmlData)
    {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        NSDictionary *myNS = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"http://schemas.xmlsoap.org/soap/envelope/",@"ns",
                              @"http://tempuri.org/", @"ns2",nil];
        NSArray *loginResult = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:ResetUserPasswordResponse/ns2:ResetUserPasswordResult" namespaces:myNS error:nil];
        if (loginResult.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [loginResult objectAtIndex:0];
            return [firstName stringValue];
        }
        
    }
    return nil;
}


-(NSData *)getXML
{
    NSString *str_soap_test = [self makeSoap];
    NSURL *url_server = [NSURL URLWithString:@"http://116.55.226.14:9018/iACTMobileInf.asmx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url_server];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"http://tempuri.org/ResetUserPassword" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [str_soap_test length]] forHTTPHeaderField:@"Content-Length"];
    NSMutableData *data_soap_test = [NSMutableData data];
    [data_soap_test appendData:[str_soap_test dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:data_soap_test];
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
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
    [str_soap appendFormat:@"<ResetUserPassword xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<uid>%@</uid>",((MyNavigationController *)self.parentViewController).uid];
    [str_soap appendFormat:@"<phonenumber>%@</phonenumber>",phoneNum.text];
    [str_soap appendFormat:@"</ResetUserPassword>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    return str_soap;
}
@end
