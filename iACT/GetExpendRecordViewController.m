//
//  GetExpendRecordViewController.m
//  iACT
//
//  Created by hongyang on 13-2-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "GetExpendRecordViewController.h"
#import "MyNavigationController.h"
#import "GdataXMLNode.h"

@interface GetExpendRecordViewController ()

@end
 
@implementation GetExpendRecordViewController
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
    if ([segue.identifier isEqualToString:@"toExpendDate"]) {
            ((ExpendDateViewController *)segue.destinationViewController).delegate = self;
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
            [self performSegueWithIdentifier:@"toShowExpend" sender:self];

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
        [self performSegueWithIdentifier:@"toExpendDate" sender:sender];
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
        NSArray *statuss = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetExpendRecordResponse/ns2:GetExpendRecordResult" namespaces:myNS error:nil];

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
                    i = [((MyNavigationController *)self.parentViewController).orderID count];
                    if (i > 0)
                    {
                        [((MyNavigationController *)self.parentViewController).orderID  removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).addTime removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).prepaidTime removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).prepaidAmount removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).finalpaidTime removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).finalpaidAmount removeAllObjects];
                        [((MyNavigationController *)self.parentViewController).paidStatus  removeAllObjects];
                        
                    }
                    
                }
    
                
                NSArray *expendRecords = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetExpendRecordResponse/ns2:GetExpendRecordResult/ns2:RecordList/ns2:ExpendRecord" namespaces:myNS error:nil];
                for(GDataXMLElement *expendRecord in expendRecords)
                {
                    GDataXMLElement *addTimes = [[expendRecord elementsForName:@"AddTime"] objectAtIndex:0];
                    GDataXMLElement *orderIDs = [[expendRecord elementsForName:@"OrderID"] objectAtIndex:0];
                    GDataXMLElement *prepaidTimes = [[expendRecord elementsForName:@"PrepaidTime"] objectAtIndex:0];
                    GDataXMLElement *prepaidAmounts = [[expendRecord elementsForName:@"PrepaidAmount"] objectAtIndex:0];
                    GDataXMLElement *finalpaidTimes = [[expendRecord elementsForName:@"FinalpaidTime"] objectAtIndex:0];
                    GDataXMLElement *finalpaidAmounts = [[expendRecord elementsForName:@"FinalpaidAmount"] objectAtIndex:0];
                    GDataXMLElement *paidStatuss = [[expendRecord elementsForName:@"PaidStatus"] objectAtIndex:0];
 
                    [((MyNavigationController *)self.parentViewController).addTime addObject:[addTimes stringValue]];
                    [((MyNavigationController *)self.parentViewController).orderID addObject:[orderIDs stringValue]];
                    [((MyNavigationController *)self.parentViewController).prepaidTime addObject:[prepaidTimes stringValue]];
                    [((MyNavigationController *)self.parentViewController).prepaidAmount addObject:[prepaidAmounts stringValue]];
                    [((MyNavigationController *)self.parentViewController).finalpaidTime addObject:[finalpaidTimes stringValue]];
                    [((MyNavigationController *)self.parentViewController).finalpaidAmount addObject:[finalpaidAmounts stringValue]];
                    [((MyNavigationController *)self.parentViewController).paidStatus addObject:[paidStatuss stringValue]];
                        
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
    [request addValue:@"http://tempuri.org/GetExpendRecord" forHTTPHeaderField:@"SOAPAction"];
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
    [str_soap appendFormat:@"<GetExpendRecord xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<uid>%d</uid>",[((MyNavigationController *)self.parentViewController).uid intValue]];

    [str_soap appendFormat:@"<month>%@</month>", self.date.text ];
    [str_soap appendFormat:@"<group>%d</group>", group];
    
    [str_soap appendFormat:@"</GetExpendRecord>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    
    //NSLog(@"%@",str_soap);
    return str_soap;
}










@end
