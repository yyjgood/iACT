//
//  imageViewController.m
//  iACT
//
//  Created by yyj on 1/27/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "imageViewController.h"
#import "NSData+Base64.h"
#import "BizNavigationController.h"
#import "GDataXMLNode.h"
#import "DateViewController.h"



@interface imageViewController ()

@end



@implementation imageViewController
@synthesize imageView;
@synthesize imagePicker;
@synthesize filePath;
@synthesize imageString;

@synthesize dateVisible;
@synthesize outputLabel;
@synthesize balance;
@synthesize price;
@synthesize imageStatus;
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
    
    filePath = [[NSString alloc] init];
    if (imagePicker == nil) {
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    NSString *price_;
    price_ =[[NSString alloc] initWithFormat:@"需付金额: ¥%@ 元", ((BizNavigationController *)self.parentViewController).packagePrice];
    self.price.text = price_;
    
    NSString *balance_;
    balance_ =[[NSString alloc] initWithFormat:@"您的余额: ¥%@ 元", ((BizNavigationController *)self.parentViewController).balance];
    self.balance.text = balance_;
    self.dateStatus = NO;
    self.imageStatus = YES;
    
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setImagePicker:nil];
    [self setFilePath:nil];
    [self setImageString:nil];
    [self setPrice:nil];
    [self setBalance:nil];
    [self setOutputLabel:nil];
    [self setOutputLabel:nil];
    [self setBalance:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint coord = [touch locationInView:self.view];
    
    //if touches within image, access photo library
    if (CGRectContainsPoint(imgView.frame, coord)) {
        [self presentModalViewController:self.imagePicker animated:YES];
    }
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    //UIAlertView *showError;
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //NSLog(@"kuan %d  gao  %d",(int)image.size.width, (int)image.size.height );
                
       /* if ((120 == (int)image.size.width && 80 ==  (int)image.size.height) || (160 == (int)image.size.width && 120 ==  (int)image.size.height))
        {
            self.imageStatus = YES;
            self.imageString = [self base64:filePath];
            
        }else
        {
            self.imageStatus = NO;
            showError = [[UIAlertView alloc] initWithTitle:@"所选图片不符合要求" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [showError show];
        }
        */
      self.imageString = [self base64:filePath];
       self.imageView.image = image;
             
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        

    }
        
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
	[picker dismissModalViewControllerAnimated:YES];
}



-(NSString *)base64:(NSString *)filePath_
{
           
    NSData *imageData = [NSData dataWithContentsOfFile: filePath_];
    
    NSString *imageDataString = [imageData base64Encoding];
    if (imageDataString) {
        return imageDataString;
    }
    return nil;
    
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
        showError = [[UIAlertView alloc] initWithTitle:@"网络连接错误或无图片数据" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
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
    return nil;
   
    
}

-(NSString *)makeSoap
{
    if (self.imageString)
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
    [str_soap appendFormat:@"<subitle></subitle>"];
    [str_soap appendFormat:@"<logodata>%@</logodata>", self.imageString];
    [str_soap appendFormat:@"<plandate>%@</plandate>", self.outputLabel.text];
    [str_soap appendFormat:@"<fee>%@</fee>",((BizNavigationController *)self.parentViewController).packagePrice ];
    
    [str_soap appendFormat:@"</AddUserOrder>"];
    [str_soap appendFormat:@"</soap:Body>"];
    [str_soap appendFormat:@"</soap:Envelope>"];
    
    //NSLog(@"%@",str_soap);
        return str_soap;
    }
    
    return nil;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((DateViewController *)segue.destinationViewController).delegate = self;
}



- (IBAction)sendImage:(id)sender
{
    UIAlertView *showError;
    if (!self.dateStatus)
    {
        showError = [[UIAlertView alloc] initWithTitle:@"请输入正确的播出日期" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }else
       /* if(!self.imageStatus){
            showError = [[UIAlertView alloc] initWithTitle:@"请选择合适的图片" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [showError show];
        }else*/
        {
             [self parseXML];
        }
}

- (IBAction)showDateImage:(id)sender
{
    if (self.dateVisible != YES)
    {
        [self performSegueWithIdentifier:@"toDateImage" sender:sender];
        self.dateVisible = YES;
    }
}
@end
