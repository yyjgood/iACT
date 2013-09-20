//
//  IACTViewController.m
//  iACT
//
//  Created by yyj on 1/9/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "IACTViewController.h"
#import "HomepageTabBarController.h"
#import <CommonCrypto/CommonDigest.h>
#import"GDataXMLNode.h"


@interface IACTViewController ()

@end

@implementation IACTViewController
@synthesize UID;
@synthesize userMobileNumber;
@synthesize mobileNumber;
@synthesize passWord;




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self readNSUserDefaults];
    
}

- (void)viewDidUnload
{
    [self setUID:nil];
    [self setUserMobileNumber:nil];
    [self setMobileNumber:nil];
    [self setPassWord:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (BOOL)checkMobileNumber
{
    UIAlertView *showError;
    //NSString *inputError;
    if (mobileNumber.text.length==0||passWord.text.length==0)
    {
        //inputError = [[NSString alloc] initWithFormat:@"请输入正确的手机号码和密码"];
        showError = [[UIAlertView alloc]
                     initWithTitle:@"手机号码或密码不能为空" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
        return EXIT_FAILURE;
    }
    else if (mobileNumber.text.length != 11)
    {
        //inputError = [[NSString alloc] initWithFormat:@"输入的手机号码不是11位"];
        showError = [[UIAlertView alloc]
                     initWithTitle:@"输入的手机号码不是11位" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
        return EXIT_FAILURE;
    }
    else if(![mobileNumber.text hasPrefix:@"1"])
    {
        //inputError = [[NSString alloc] initWithFormat:@"输入的手机号码首位不是1"];
        showError = [[UIAlertView alloc]
                     initWithTitle:@"输入的手机号码首位不是1" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
    
}

- (NSString *)md5Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ] lowercaseString];
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
    NSArray *loginResult = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:UserLoginResponse/ns2:UserLoginResult" namespaces:myNS error:nil];
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
    [request addValue:@"http://tempuri.org/UserLogin" forHTTPHeaderField:@"SOAPAction"];
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
    [str_soap appendFormat:@"<UserLogin xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<phonenumber>%@</phonenumber>",mobileNumber.text];
    [str_soap appendFormat:@"<password>%@</password>",[self md5Digest:passWord.text]];
    [str_soap appendFormat:@"</UserLogin>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    return str_soap;
}

- (IBAction)login:(id)sender
{
    if (![self checkMobileNumber])
    {
       
        NSString *userLoginResult = [self parseXML];
        UIAlertView *showError;
        if(userLoginResult)
        {
        
        int flag = [userLoginResult intValue];

        
        if (flag > 0)
        {
            self.UID = userLoginResult;
            self.userMobileNumber = [[NSString alloc] init];
            self.userMobileNumber = mobileNumber.text;
            [self saveNSUserDefaults];
            [self performSegueWithIdentifier:@"toHomepage" sender:self];
  
        }
        else
        {
            
            switch (flag)
            {
                    
                case 0:
                    showError = [[UIAlertView alloc]
                                 initWithTitle:@"请检查手机号，无此用户" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
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
                                 initWithTitle:@"登录错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [showError show];
                    break;
                case -5:
                    showError = [[UIAlertView alloc]
                                 initWithTitle:@"密码错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [showError show];
                    break;
                default: break;                 
            }
        }
        }else
        {
            showError = [[UIAlertView alloc] initWithTitle:@"请检查网络连接" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [showError show];
        }
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.passWord resignFirstResponder];
    [self.mobileNumber resignFirstResponder];
}



-(void)saveNSUserDefaults
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = self.switchStatus.isOn;
    
    if(flag)
    {
        //NSLog(@"  YES");
    [userDefaults setObject:mobileNumber.text forKey:@"mobileNumberSaved"];
    [userDefaults setObject:passWord.text forKey:@"passWordSaved"];


    }else
    {
        // NSLog(@"  NO");
        [userDefaults setObject:nil forKey:@"mobileNumberSaved"];
        [userDefaults setObject:nil forKey:@"passWordSaved"];
    }
}


-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];

    self.mobileNumber.text = [userDefaultes stringForKey:@"mobileNumberSaved"];
    self.passWord.text = [userDefaultes stringForKey:@"passWordSaved"];

}




@end
