//
//  AreaListTableViewController.m
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "AreaListTableViewController.h"
#import "BizNavigationController.h"
#import"GDataXMLNode.h"

@interface AreaListTableViewController ()

@end

@implementation AreaListTableViewController

@synthesize areaName;
@synthesize areaID;
@synthesize uid;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    uid = ((BizNavigationController *)self.parentViewController).uid;
    self.areaName = [[NSMutableArray alloc] init];
    self.areaID = [[NSMutableArray alloc] init];
    [self parseXML];
 

}

- (void)viewDidUnload
{

    [self setAreaName:nil];
    [self setAreaID:nil];
    [self setUid:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      
    return [self.areaName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"areaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [self.areaName objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((BizNavigationController *)self.parentViewController).areaID_ = [self.areaID objectAtIndex:indexPath.row];
    ((BizNavigationController *)self.parentViewController).areaName_ = [self.areaName objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toPackageList" sender:self];
}

-(void)parseXML
{
    NSData *xmlData = [self getAreaXML];
    UIAlertView *showError;
    if(xmlData)
    {
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    NSDictionary *myNS = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"http://schemas.xmlsoap.org/soap/envelope/",@"ns",
                          @"http://tempuri.org/", @"ns2",nil];
    NSArray *tranStatus = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetBizAreaResponse/ns2:GetBizAreaResult/ns2:TranStatus" namespaces:myNS error:nil];
    if (tranStatus.count > 0)
    {
        GDataXMLElement *firstName = (GDataXMLElement *) [tranStatus objectAtIndex:0];
        int flag = [[firstName stringValue] intValue];
        if ( flag > 0)
        {
            NSArray *areas = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetBizAreaResponse/ns2:GetBizAreaResult/ns2:BizAreaList/ns2:BizArea" namespaces:myNS error:nil];
                            // NSLog(@"%d", area.count);
            for(GDataXMLElement *area in areas)
            {
                GDataXMLElement *bizStatus = [[area elementsForName:@"BizStatus"] objectAtIndex:0];
                if (1 == [[bizStatus stringValue] intValue])
                {
                    GDataXMLElement *areaNames = [[area elementsForName:@"Name"] objectAtIndex:0];
                    GDataXMLElement *areaIDs = [[area elementsForName:@"ID"] objectAtIndex:0];
                    [areaName addObject:[areaNames stringValue]];
                    [areaID addObject:[areaIDs stringValue]];
                }
            }
        }
        else
        {
            switch (flag)
            {
                    
                case 0:
                    showError = [[UIAlertView alloc]
                                 initWithTitle:@"没有开通服务的区域" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
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
                                 initWithTitle:@"查询错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [showError show];
                    break;
                default: break;
            }
        }
        }
    }else
    {
        showError = [[UIAlertView alloc] initWithTitle:@"网络连接错误或数据丢失" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }
}


-(NSData *)getAreaXML
{

    NSString *str_soap_test = [self makeSoap];
    if(str_soap_test)
    {
    NSURL *url_server = [NSURL URLWithString:@"http://116.55.226.14:9018/iACTMobileInf.asmx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url_server];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"http://tempuri.org/GetBizArea" forHTTPHeaderField:@"SOAPAction"];
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
    return nil;
     //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //return returnString;
}
-(NSString *)makeSoap
{
    if ([uid intValue] > 0)
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
    [str_soap appendFormat:@"<GetBizArea xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<uid>%d</uid>",[uid intValue]];
    [str_soap appendFormat:@"</GetBizArea>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    
    //NSLog(@"%@",str_soap);
    return str_soap;
    }
    return nil;
}



@end
