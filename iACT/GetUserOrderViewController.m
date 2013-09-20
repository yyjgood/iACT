//
//  GetUserOrderViewController.m
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "GetUserOrderViewController.h"
#import "MyNavigationController.h"
#import "GdataXMLNode.h"

@interface GetUserOrderViewController ()

@end

@implementation GetUserOrderViewController


@synthesize date;
@synthesize flag;
@synthesize dateChooserVisible;

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
    date.text = nil;
}

- (void)viewDidUnload
{
    [self setDate:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
-(void)showChosenDate:(NSDate *)chosenDate
{
    NSDateFormatter *dateFormat;
    NSString *chosenDateString;
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM"];
    chosenDateString = [dateFormat stringFromDate:chosenDate];
    self.date.text = chosenDateString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toUserOrderDate"]) {
        ((UserOrderDateViewController *)segue.destinationViewController).delegate = self;
    }
    
    
}
- (IBAction)query:(id)sender
{
    if(date.text == nil)
    {
        UIAlertView *showError;
        showError = [[UIAlertView alloc] initWithTitle:@"请输入查询日期" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }else
    {
        int group = 1;
        while (1 == ((MyNavigationController *)self.parentViewController).dataStatus) {
            //NSLog(@"%d",group);
            [self parseXML:group++];
            
        }
        ((MyNavigationController *)self.parentViewController).dataStatus = 1;
        

            if (self.flag > 0) {
                if (self.flagCount <= 0) {
                    
                    UIAlertView *showError;
                    showError = [[UIAlertView alloc] initWithTitle:@"没有数据" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [showError show];
                }else
                {
                    [self performSegueWithIdentifier:@"toShowUserOrder" sender:self];}

            }
        
        /*for (NSString *orderid in finalpaidTime )
         {
         NSLog(@"%@\n", orderid);
         }*/
    }
    
    
}

- (IBAction)chooseDate:(id)sender
{
    if (self.dateChooserVisible!=YES) {
        [self performSegueWithIdentifier:@"toUserOrderDate" sender:sender];
        self.dateChooserVisible = YES;
    }
}
#pragma mark -


-(void)parseXML: (int )group
{
    NSData *xmlData = [self getXML:group];
    UIAlertView *showError;
    if(xmlData)
    {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        NSDictionary *myNS = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"http://schemas.xmlsoap.org/soap/envelope/",@"ns",
                              @"http://tempuri.org/", @"ns2",nil];
        NSArray *statuss = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetUserOrderResponse/ns2:GetUserOrderResult" namespaces:myNS error:nil];
        
        if (statuss.count > 0)
        {
            for(GDataXMLElement *status in statuss)
            {
                GDataXMLElement *tranStatus = [[status elementsForName:@"TranStatus"] objectAtIndex:0];
                GDataXMLElement *dataStatuss = [[status elementsForName:@"DataStatus"] objectAtIndex:0];
                ((MyNavigationController *)self.parentViewController).dataStatus = [[dataStatuss stringValue] intValue];
                self.flag = [[tranStatus stringValue] intValue];
            }
            if (self.flag > 0) {
                
                if (1 == group) {
                    int i;
                    i = [((MyNavigationController *)self.parentViewController).bizArea count];
                    if (i > 0)
                    {
                        [((MyNavigationController *)self.parentViewController).bizArea  removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).orderID_ removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).orderType removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).spotType removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).packageInfo removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).createTime removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).planDate  removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).planBeginTime  removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).verifyStatus  removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).handleStatus  removeAllObjects];
                        
                    }
                    
                }
                
                
                NSArray *expendRecords = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetUserOrderResponse/ns2:GetUserOrderResult/ns2:OrderList/ns2:UserOrder" namespaces:myNS error:nil];
                for(GDataXMLElement *expendRecord in expendRecords)
                {
                    GDataXMLElement *bizAreas = [[expendRecord elementsForName:@"BizArea"] objectAtIndex:0];
                    GDataXMLElement *orderID_s = [[expendRecord elementsForName:@"OrderID"] objectAtIndex:0];
                    GDataXMLElement *orderTypes = [[expendRecord elementsForName:@"OrderType"] objectAtIndex:0];
                    GDataXMLElement *spotTypes = [[expendRecord elementsForName:@"SpotType"] objectAtIndex:0];
                    GDataXMLElement *packageInfos = [[expendRecord elementsForName:@"PackageInfo"] objectAtIndex:0];
                    GDataXMLElement *createTimes = [[expendRecord elementsForName:@"CreateTime"] objectAtIndex:0];
                    GDataXMLElement *planDates = [[expendRecord elementsForName:@"PlanDate"] objectAtIndex:0];
                    GDataXMLElement *planBeginTimes = [[expendRecord elementsForName:@"PlanBeginTime"] objectAtIndex:0];
                    GDataXMLElement *verifyStatuss = [[expendRecord elementsForName:@"VerifyStatus"] objectAtIndex:0];
                    GDataXMLElement *handleStatuss = [[expendRecord elementsForName:@"HandleStatus"] objectAtIndex:0];
                    
                    
                   NSString *flagString = [handleStatuss stringValue];
                    
                   // NSLog(@" %@",flagString);
                    switch (                    ((MyNavigationController *)self.parentViewController).orderChoose ) {
                        case 1:
                            if ([flagString isEqualToString:@"新增" ] || [flagString isEqualToString:@"审核"]) {
                                
                                [((MyNavigationController *)self.parentViewController).orderID_ addObject:[orderID_s stringValue]];
                                [((MyNavigationController *)self.parentViewController).bizArea addObject:[bizAreas stringValue]];
                                [((MyNavigationController *)self.parentViewController).orderType addObject:[orderTypes stringValue]];
                                [((MyNavigationController *)self.parentViewController).spotType addObject:[spotTypes stringValue]];
                                [((MyNavigationController *)self.parentViewController).packageInfo addObject:[packageInfos stringValue]];
                                [((MyNavigationController *)self.parentViewController).createTime addObject:[createTimes stringValue]];
                                [((MyNavigationController *)self.parentViewController).planDate addObject:[planDates stringValue]];
                                [((MyNavigationController *)self.parentViewController).planBeginTime addObject:[planBeginTimes stringValue]];
                                [((MyNavigationController *)self.parentViewController).verifyStatus addObject:[verifyStatuss stringValue]];
                                [((MyNavigationController *)self.parentViewController).handleStatus addObject:[handleStatuss stringValue]];
                            }
                            self.flagCount = [((MyNavigationController *)self.parentViewController).orderID_ count];
                            break;
                        case 2:
                            if ([flagString isEqualToString:@"播出" ] || [flagString isEqualToString:@"计划"] ) {
                                
                                [((MyNavigationController *)self.parentViewController).orderID_ addObject:[orderID_s stringValue]];
                                [((MyNavigationController *)self.parentViewController).bizArea addObject:[bizAreas stringValue]];
                                [((MyNavigationController *)self.parentViewController).orderType addObject:[orderTypes stringValue]];
                                [((MyNavigationController *)self.parentViewController).spotType addObject:[spotTypes stringValue]];
                                [((MyNavigationController *)self.parentViewController).packageInfo addObject:[packageInfos stringValue]];
                                [((MyNavigationController *)self.parentViewController).createTime addObject:[createTimes stringValue]];
                                [((MyNavigationController *)self.parentViewController).planDate addObject:[planDates stringValue]];
                                [((MyNavigationController *)self.parentViewController).planBeginTime addObject:[planBeginTimes stringValue]];
                                [((MyNavigationController *)self.parentViewController).verifyStatus addObject:[verifyStatuss stringValue]];
                                [((MyNavigationController *)self.parentViewController).handleStatus addObject:[handleStatuss stringValue]];
                            }
                            self.flagCount = [((MyNavigationController *)self.parentViewController).orderID_ count];
                            break;
                        case 3:
                            if ([flagString isEqualToString:@"完成" ] || [flagString isEqualToString:@"删除"] ) {
                                
                                [((MyNavigationController *)self.parentViewController).orderID_ addObject:[orderID_s stringValue]];
                                [((MyNavigationController *)self.parentViewController).bizArea addObject:[bizAreas stringValue]];
                                [((MyNavigationController *)self.parentViewController).orderType addObject:[orderTypes stringValue]];
                                [((MyNavigationController *)self.parentViewController).spotType addObject:[spotTypes stringValue]];
                                [((MyNavigationController *)self.parentViewController).packageInfo addObject:[packageInfos stringValue]];
                                [((MyNavigationController *)self.parentViewController).createTime addObject:[createTimes stringValue]];
                                [((MyNavigationController *)self.parentViewController).planDate addObject:[planDates stringValue]];
                                [((MyNavigationController *)self.parentViewController).planBeginTime addObject:[planBeginTimes stringValue]];
                                [((MyNavigationController *)self.parentViewController).verifyStatus addObject:[verifyStatuss stringValue]];
                                [((MyNavigationController *)self.parentViewController).handleStatus addObject:[handleStatuss stringValue]];
                            }
                            self.flagCount = [((MyNavigationController *)self.parentViewController).orderID_ count];
                            break;
                           
                        default:
                            break;
                    }


                }
                
                
                
            }
            else{
                
                switch (flag)
                {
                        
                    case 0:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"没有数据" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                        
                    case -1:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"时间信息转换错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -2:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"无SOAP认证信息" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -3:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"SOAP信息错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -4:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"系统错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                    case -5:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"查询错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                        
                    default:
                        showError = [[UIAlertView alloc]
                                     initWithTitle:@"查询失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [showError show];
                        break;
                }
            }
        }
        
    }else
    {
        showError = [[UIAlertView alloc] initWithTitle:@"网络连接错误或数据丢失" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }
}


-(NSData *)getXML: (int )group
{
    
    NSString *str_soap_test = [self makeSoap:group];
    NSURL *url_server = [NSURL URLWithString:@"http://116.55.226.14:9018/iACTMobileInf.asmx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url_server];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"http://tempuri.org/GetUserOrder" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [str_soap_test length]] forHTTPHeaderField:@"Content-Length"];
    NSMutableData *data_soap_test = [NSMutableData data];
    [data_soap_test appendData:[str_soap_test dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:data_soap_test];
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    /*NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     NSLog(@"%@", returnString);*/
    if(returnData)
    {
        return returnData;
    }
    return nil;
    
}

-(NSString *)makeSoap: (int )group
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
    [str_soap appendFormat:@"<GetUserOrder xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<uid>%d</uid>",[((MyNavigationController *)self.parentViewController).uid intValue]];
    
    [str_soap appendFormat:@"<month>%@</month>", self.date.text ];
    [str_soap appendFormat:@"<group>%d</group>", group];
    
    [str_soap appendFormat:@"</GetUserOrder>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    
    //NSLog(@"%@",str_soap);
    return str_soap;
}



@end
