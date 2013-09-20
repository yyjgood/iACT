//
//  MyNavigationController.m
//  iACT
//
//  Created by hongyang on 13-2-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "MyNavigationController.h"
#import "HomepageTabBarController.h"
#import "GdataXMLNode.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController
@synthesize uid;
@synthesize mobileNumber;

@synthesize balance;
@synthesize level;
@synthesize credit;
@synthesize phoneVerify;
@synthesize prepaidAmounts;
@synthesize orderCount;



@synthesize orderChoose;
@synthesize dataStatus;
@synthesize orderID;
@synthesize addTime;
@synthesize paidStatus;
@synthesize prepaidTime;
@synthesize prepaidAmount;
@synthesize finalpaidAmount;
@synthesize finalpaidTime;

@synthesize orderIDPay;
@synthesize addFee;
@synthesize addTimePay;
@synthesize payAmount;
@synthesize payMode;
@synthesize productID;
@synthesize serialNumber;

@synthesize bizArea;
@synthesize orderID_;
@synthesize orderType;
@synthesize spotType;
@synthesize packageInfo;
@synthesize createTime;
@synthesize planDate;
@synthesize planBeginTime;
@synthesize verifyStatus;
@synthesize handleStatus;



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
	
    self.dataStatus = 1;

    
    self.uid = [[NSString alloc] init];
    self.mobileNumber = [[NSString alloc] init];
    self.balance = [[NSString alloc] init];
    self.level = [[NSString alloc] init];
    self.credit = [[NSString alloc] init];
    self.phoneVerify = [[NSString alloc] init];
    self.orderCount = [[NSString alloc] init];
    self.prepaidAmounts = [[NSString alloc] init];
    self.uid = ((HomepageTabBarController *)self.parentViewController).uid;
    self.mobileNumber = ((HomepageTabBarController *)self.parentViewController).mobileNumber;
    
    self.orderID = [[NSMutableArray alloc] init];
    self.addTime = [[NSMutableArray alloc] init];
    self.paidStatus = [[NSMutableArray alloc] init];
    self.prepaidTime = [[NSMutableArray alloc] init];
    self.prepaidAmount = [[NSMutableArray alloc] init];
    self.finalpaidAmount = [[NSMutableArray alloc] init];
    self.finalpaidTime = [[NSMutableArray alloc] init];
    
    self.orderIDPay = [[NSMutableArray alloc] init];
    self.serialNumber = [[NSMutableArray alloc] init];
    self.payMode = [[NSMutableArray alloc] init];
    self.payAmount = [[NSMutableArray alloc] init];
    self.productID = [[NSMutableArray alloc] init];
    self.addTimePay = [[NSMutableArray alloc] init];
    self.addFee = [[NSMutableArray alloc] init];
    
    
    self.bizArea = [[NSMutableArray alloc] init];
    self.orderID_ = [[NSMutableArray alloc] init];
    self.orderType = [[NSMutableArray alloc] init];
    self.spotType = [[NSMutableArray alloc] init];
    self.packageInfo = [[NSMutableArray alloc] init];
    self.createTime = [[NSMutableArray alloc] init];
    self.planBeginTime = [[NSMutableArray alloc] init];
    self.planDate = [[NSMutableArray alloc] init];
    self.verifyStatus = [[NSMutableArray alloc] init];
    self.handleStatus = [[NSMutableArray alloc] init];
    [self parseXML];


}

- (void)viewDidUnload
{
    [self setUid:nil];
    [self setBalance:nil];
    [self setLevel:nil];
    [self setCredit:nil];
    [self setPhoneVerify:nil];
    [self setOrderCount:nil];
    [self setPrepaidAmounts:nil];
    [self setMobileNumber:nil];

    
    [self setOrderID:nil];
    [self setAddTime:nil];
    [self setPaidStatus:nil];
    [self setPrepaidAmount:nil];
    [self setPrepaidTime:nil];
    [self setFinalpaidAmount:nil];
    [self setFinalpaidTime:nil];

    [self setOrderIDPay:nil];
    [self setAddTimePay:nil];
    [self setPayAmount:nil];
    [self setPayMode:nil];
    [self setProductID:nil];
    [self setSerialNumber:nil];
    [self setAddFee:nil];
    
    [self setHandleStatus:nil];
    [self setVerifyStatus:nil];
    [self setPlanBeginTime:nil];
    [self setPlanDate:nil];
    [self setCreateTime:nil];
    [self setPackageInfo:nil];
    [self setSpotType:nil];
    [self setOrderID_:nil];
    [self setOrderType:nil];
    [self setBizArea:nil];
    
    
    
    
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        NSArray *tranStatus = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetUserInfoResponse/ns2:GetUserInfoResult/ns2:TranStatus" namespaces:myNS error:nil];
        if (tranStatus.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [tranStatus objectAtIndex:0];
            int flag = [[firstName stringValue] intValue];
            if ( flag == 0)
            {
                NSArray *userInfos = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetUserInfoResponse/ns2:GetUserInfoResult" namespaces:myNS error:nil];
                // NSLog(@"%d", area.count);
                for(GDataXMLElement *userInfo in userInfos)
                {
                    GDataXMLElement *balance_ = [[userInfo elementsForName:@"Balance"] objectAtIndex:0];
                    self.balance = [balance_ stringValue];
                    ((HomepageTabBarController *)self.parentViewController).balance = [balance_ stringValue];
                    
                    GDataXMLElement *level_ = [[userInfo elementsForName:@"Level"] objectAtIndex:0];
                    self.level = [level_ stringValue];
                    
                    GDataXMLElement *credit_ = [[userInfo elementsForName:@"Credit"] objectAtIndex:0];
                    self.credit = [credit_ stringValue];
                    
                    GDataXMLElement *phoneVerify_ = [[userInfo elementsForName:@"PhoneVerify"] objectAtIndex:0];
                    self.phoneVerify = [phoneVerify_ stringValue];
                    
                    GDataXMLElement *orderCount_ = [[userInfo elementsForName:@"OrderCount"] objectAtIndex:0];
                    self.orderCount = [orderCount_ stringValue];
                    
                    GDataXMLElement *prepaidAmount_ = [[userInfo elementsForName:@"PrepaidAmount"] objectAtIndex:0];
                    self.prepaidAmounts = [prepaidAmount_ stringValue];
                    
                }
                
            }
            else
            {
                switch (flag)
                {
                       
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
                                     initWithTitle:@"用户基础信息系统错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    case -4:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"用户基础信息查询错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    case -5:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"用户不存在" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    case -6:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"用户订单信息系统错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    case -7:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"用户订单信息查询错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    case -8:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"没有订单信息" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        
                        break;
                    default: break;
                }
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
        [request addValue:@"http://tempuri.org/GetUserInfo" forHTTPHeaderField:@"SOAPAction"];
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
        [str_soap appendFormat:@"<GetUserInfo xmlns=\"http://tempuri.org/\">"];
        [str_soap appendFormat:@"<uid>%d</uid>",[self.uid intValue]];
        [str_soap appendFormat:@"</GetUserInfo>"];
        [str_soap appendFormat:@"</soap:Body>"];
        [str_soap appendFormat:@"</soap:Envelope>"];
        //NSLog(@"   %@", str_soap);
        return str_soap;
    }
    return nil;
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((AccountViewController *)segue.destinationViewController).delegate = self;
}*/

@end
