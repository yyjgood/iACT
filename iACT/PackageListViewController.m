//
//  PackageListViewController.m
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "PackageListViewController.h"
#import "AreaListTableViewController.h"
#import "BizNavigationController.h"
#import "GDataXMLNode.h"


@interface PackageListViewController ()

@end

@implementation PackageListViewController

@synthesize subtitle;
@synthesize image;
@synthesize areaID;
@synthesize uid;


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
    //self.(((BizNavigationController *)self.parentViewController).nameImage) = [[NSMutableArray alloc] init];
    //self.subtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).nameImage = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).IDImage = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).playNumberImage = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).beginTimeImage = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).endTimeImage = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).spotTypeImage= [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).priceImage = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).descriptionImage = [[NSMutableArray alloc] init];
    
    ((BizNavigationController *)self.parentViewController).nameSubtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).IDSubtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).playNumberSubtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).beginTimeSubtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).endTimeSubtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).spotTypeSubtitle= [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).priceSubtitle = [[NSMutableArray alloc] init];
    ((BizNavigationController *)self.parentViewController).descriptionSubtitle= [[NSMutableArray alloc] init];
    
    
    ((BizNavigationController *)self.parentViewController).packageBeginTime = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packageEndTime = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packageID = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packageName = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packagePlayNumber = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packagePrice = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packageSpotType = [[NSString alloc] init];
    ((BizNavigationController *)self.parentViewController).packageDescription = [[NSString alloc] init];
    
    
    [self parseXML];
    
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [self setSubtitle:nil];
    [self setAreaID:nil];
    [self setUid:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [(((BizNavigationController *)self.parentViewController).nameSubtitle) count];
        case 1:
            return [((BizNavigationController *)self.parentViewController).nameImage count];
            
        default:
            return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"字幕";
        case 1:
            return @"挂角";
            
            
        default:
            return @"Unknown";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"packageCell"];
    NSString *broadcastTime;
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [(((BizNavigationController *)self.parentViewController).nameSubtitle) objectAtIndex:indexPath.row];
            
            broadcastTime = [[NSString alloc] initWithFormat:@"%@ %@-%@ 播放%@次 ¥%@",
                             ((BizNavigationController *)self.parentViewController).areaName_,
                             [((BizNavigationController *)self.parentViewController).beginTimeSubtitle objectAtIndex:indexPath.row], [((BizNavigationController *)self.parentViewController).endTimeSubtitle objectAtIndex:indexPath.row],[((BizNavigationController *)self.parentViewController).playNumberSubtitle objectAtIndex:indexPath.row], [((BizNavigationController *)self.parentViewController).priceSubtitle objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = broadcastTime;
            break;
            
        case 1:
            cell.textLabel.text = [((BizNavigationController *)self.parentViewController).nameImage objectAtIndex:indexPath.row];
            broadcastTime = [[NSString alloc] initWithFormat:@"%@ %@-%@ 播放%@次 ¥%@",
                             ((BizNavigationController *)self.parentViewController).areaName_,
                             [((BizNavigationController *)self.parentViewController).beginTimeImage objectAtIndex:indexPath.row], [((BizNavigationController *)self.parentViewController).endTimeImage objectAtIndex:indexPath.row],[((BizNavigationController *)self.parentViewController).playNumberImage objectAtIndex:indexPath.row], [((BizNavigationController *)self.parentViewController).priceImage objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = broadcastTime;
            break;
            
            
        default:
            cell.textLabel.text = @"Unknown";
    }
    return cell;
}

-(void)parseXML
{
    NSData *xmlData = [self getPackageXML];
    UIAlertView *showError;
    if(xmlData)
    {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        NSDictionary *myNS = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"http://schemas.xmlsoap.org/soap/envelope/",@"ns",
                              @"http://tempuri.org/", @"ns2",nil];
        NSArray *tranStatus = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetBizPackageResponse/ns2:GetBizPackageResult/ns2:TranStatus" namespaces:myNS error:nil];
        if (tranStatus.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [tranStatus objectAtIndex:0];
            int flag = [[firstName stringValue] intValue];
            if ( flag > 0)
            {
                NSArray *packages = [doc nodesForXPath:@"/ns:Envelope/ns:Body/ns2:GetBizPackageResponse/ns2:GetBizPackageResult/ns2:BizPackageList/ns2:BizPackage" namespaces:myNS error:nil];
                // NSLog(@"%d", area.count);
                for(GDataXMLElement *package in packages)
                {
                    GDataXMLElement *spottype = [[package elementsForName:@"SpotType"] objectAtIndex:0];
                    GDataXMLElement *names = [[package elementsForName:@"Name"] objectAtIndex:0];
                    GDataXMLElement *beginTimes = [[package elementsForName:@"BeginTime"] objectAtIndex:0];
                    GDataXMLElement *endTimes = [[package elementsForName:@"EndTime"] objectAtIndex:0];
                    GDataXMLElement *playNumbers = [[package elementsForName:@"PlayNumber"] objectAtIndex:0];
                    GDataXMLElement *prices = [[package elementsForName:@"Price"] objectAtIndex:0];
                    GDataXMLElement *IDs = [[package elementsForName:@"ID"] objectAtIndex:0];
                    GDataXMLElement *descriptions = [[package elementsForName:@"Description"] objectAtIndex:0];
                    
                    
                    
                    NSString *flagString = [spottype stringValue];
                    if ([flagString isEqualToString: @"文字"])
                    {
                        [((BizNavigationController *)self.parentViewController).nameSubtitle addObject:[names stringValue]];
                        [((BizNavigationController *)self.parentViewController).beginTimeSubtitle addObject:[beginTimes stringValue]];
                        [((BizNavigationController *)self.parentViewController).endTimeSubtitle addObject:[endTimes stringValue]];
                        [((BizNavigationController *)self.parentViewController).playNumberSubtitle addObject:[playNumbers stringValue]];
                        [((BizNavigationController *)self.parentViewController).priceSubtitle addObject:[prices stringValue]];
                        [((BizNavigationController *)self.parentViewController).IDSubtitle addObject:[IDs stringValue]];
                        [((BizNavigationController *)self.parentViewController).descriptionSubtitle addObject:[descriptions stringValue]];
                        
                        
                    }
                    
                    if ([flagString isEqualToString: @"挂角"] )
                    {
                        [((BizNavigationController *)self.parentViewController).nameImage addObject:[names stringValue]];
                        [((BizNavigationController *)self.parentViewController).beginTimeImage addObject:[beginTimes stringValue]];
                        [((BizNavigationController *)self.parentViewController).endTimeImage addObject:[endTimes stringValue]];
                        [((BizNavigationController *)self.parentViewController).playNumberImage addObject:[playNumbers stringValue]];
                        [((BizNavigationController *)self.parentViewController).priceImage addObject:[prices stringValue]];
                        [((BizNavigationController *)self.parentViewController).IDImage addObject:[IDs stringValue]];
                        [((BizNavigationController *)self.parentViewController).descriptionImage addObject:[descriptions stringValue]];
                        
                        
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
        showError = [[UIAlertView alloc] initWithTitle:@"请检查网络连接" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }
}


-(NSData *)getPackageXML
{
    
    NSString *str_soap_test = [self makeSoap];
    NSURL *url_server = [NSURL URLWithString:@"http://116.55.226.14:9018/iACTMobileInf.asmx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url_server];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"http://tempuri.org/GetBizPackage" forHTTPHeaderField:@"SOAPAction"];
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
    [str_soap appendFormat:@"<GetBizPackage xmlns=\"http://tempuri.org/\">"];
    [str_soap appendFormat:@"<uid>%d</uid>",[((BizNavigationController *)self.parentViewController).uid intValue]];
    [str_soap appendFormat:@"<bizarea>%d</bizarea>",[((BizNavigationController *)self.parentViewController).areaID_ intValue]];
    [str_soap appendFormat:@"</GetBizPackage>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    
    //NSLog(@"%@",str_soap);
    return str_soap;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            ((BizNavigationController *)self.parentViewController).packageName = [(((BizNavigationController *)self.parentViewController).nameSubtitle) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageID = [(((BizNavigationController *)self.parentViewController).IDSubtitle) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageBeginTime = [(((BizNavigationController *)self.parentViewController).beginTimeSubtitle) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageEndTime = [(((BizNavigationController *)self.parentViewController).endTimeSubtitle) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packagePlayNumber = [(((BizNavigationController *)self.parentViewController).playNumberSubtitle) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packagePrice = [(((BizNavigationController *)self.parentViewController).priceSubtitle) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageSpotType = [[NSString alloc] initWithFormat:@"文字"];
            
            ((BizNavigationController *)self.parentViewController).packageDescription= [(((BizNavigationController *)self.parentViewController).descriptionSubtitle ) objectAtIndex:indexPath.row];
            
            [self performSegueWithIdentifier:@"toOrder" sender:self ];
            break;
            
        case 1:
            ((BizNavigationController *)self.parentViewController).packageName = [(((BizNavigationController *)self.parentViewController).nameImage) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageID = [(((BizNavigationController *)self.parentViewController).IDImage) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageBeginTime = [(((BizNavigationController *)self.parentViewController).beginTimeImage) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageEndTime = [(((BizNavigationController *)self.parentViewController).endTimeImage) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packagePlayNumber = [(((BizNavigationController *)self.parentViewController).playNumberImage) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packagePrice = [(((BizNavigationController *)self.parentViewController).priceImage) objectAtIndex:indexPath.row];
            
            ((BizNavigationController *)self.parentViewController).packageSpotType = [[NSString alloc] initWithFormat:@"挂角"];
            
            ((BizNavigationController *)self.parentViewController).packageDescription= [(((BizNavigationController *)self.parentViewController).descriptionImage ) objectAtIndex:indexPath.row];
            
            [self performSegueWithIdentifier:@"toOrder" sender:self ];
            
            break;
        default: break;
    }
}



@end
