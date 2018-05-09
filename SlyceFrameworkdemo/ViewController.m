//
//  ViewController.m
//  SlyceFrameworkdemo
//
//  Created by chris on 03/02/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import "ViewController.h"
#import <SlycePay/SlycePay.h>
#import "ResultViewController.h"
#import "FileControl+Recorder.h"
#define CCSALE @"CCSALE"
#define CCRETURN @"CCRETURN"
//cardflight
#define CFSALE @"CFSALE"
#define CFRETURN @"CFRETURN"
#define CFAUTH @"CFAUTH"
#define CFCAPTURE @"CFCAPTURE"
//usaepay
#define UPSALE    @"UPSALE"
#define UPRETURN  @"UPRETURN"
#define UPAUTH    @"UPAUTH"
@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,retain) SlycePay * slycepay;
@property (nonatomic,retain) NSArray * PinPads;
@property (nonatomic,retain)FileControl * file;
@property NSInteger selectedIndex;
@property (nonatomic,retain) IBOutlet UIButton * voidBtn;
@end

@implementation ViewController
@synthesize slycepay;
@synthesize initialLibbtn;
@synthesize salebtn;
@synthesize returnbtn;
@synthesize amountField;
@synthesize tokenField;
@synthesize connetPinBtn;
@synthesize messageLabel;
@synthesize authBtn;
@synthesize capBtn;
@synthesize cancelBtn;
@synthesize resultView;
@synthesize file;
@synthesize selectedIndex;
@synthesize voidBtn;

#pragma mark view operations
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
    self.title = @"CMS demo";
    [self initFiles];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delgates functions

/**
 get init result, if error is not nil, then display error
 @param ready indicate the init result
 @param error indicate the errors
 */
-(void)initialisCompleted:(BOOL)ready withError:(NSError*)error {
    NSLog(@"APP Completed %@",error.description);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code != 0)//if error is rather than 0 then the init if failed
        {
            [self ErrorAlert:@"init failed"];
            [self updateInformationLabel:[NSString stringWithFormat:@"init Error %lld",(long long)error.code]];
            return;
        }
        [self updateInformationLabel:@"Initialzation Completed"];
        if ([error isEqual:nil]||error.code==0)
        {
            [self enableDevice];
            
        }
    });
    
}

/**
 Triggered when pinpad connectiong is finished

 @param error pinpad connection errors, if no error it is nil
 */
-(void)deviceconnectionComplete:(NSError*)error
{
    if(error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self updateInformationLabel:[NSString stringWithFormat:@" deviceconnectionComplete %lld",(long long)error.code]];
        });
        [slycepay APPLog:@" deviceconnectionComplete %lld",(long long)error.code];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    [self enableTransaction];
    [self updateInformationLabel:@"device connected"];
    });

}

/**
 Transaction authorization is finished

 @param resultDict result Dictionary of result
 */
-(void)transAuthorizationCompleted:(NSDictionary *)resultDict
{
    [slycepay APPLog:@"%@",resultDict.description];
    // if no error store the transaction and show it
    if([resultDict objectForKey:@"error"] == nil) {
        resultView = [[ResultViewController alloc]init];
        resultView.result = @"APPROVED";
        NSString *cardinfostr = [resultDict objectForKey:@"Cardinfo"];
        NSDictionary *carddict = [self dictionaryWithJsonString:cardinfostr];
        
        resultView.card = [NSString stringWithFormat:@"**************%@",[carddict objectForKey:@"Last4"]];
        resultView.reference = [resultDict objectForKey:@"Reference"];
        NSString * amountv = [NSString stringWithFormat:@"%@", [resultDict objectForKey:@"AuthorizedAmount"]];
        NSString * amountstr = [self formatAmount:amountv];
        resultView.amount = amountstr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:self -> resultView animated:YES];
            if([self -> slycepay.currentModule isEqualToString:@"B200"]) {
                [self -> file addRecord:resultDict fromFile:CFAUTH];
            }
            else {
                 [self->file addRecord:resultDict fromFile:UPAUTH];
            }
           
        });
    }
    else {
        // display Declined message
        resultView = [[ResultViewController alloc]init];
        resultView.result = @"Decliend";
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:self->resultView animated:YES];
        });
    }

    
    
}
/**
 Transaction Sale is finished
 
 @param resultDict result Dictionary of result
 */
-(void)transactionSaleCompleted:( NSDictionary *)resultDict
{
    [slycepay APPLog:@"APP sale completed %@",resultDict.description];
    @try {
        NSString *jsonString = [file dictionaryToString:resultDict];
        [slycepay APPLog:@"APP sale JSON %@",jsonString];
    } @catch (NSException *exception) {
          [slycepay APPLog:@"APP sale exception %@",exception.description];
    }
    // if no error show approved and store the transaction
    if([resultDict objectForKey:@"error"] ==nil)
    {
        resultView = [[ResultViewController alloc]init];
        resultView.result = @"APPROVED";
        if([resultDict objectForKey:@"Cardinfo"]!=nil) {
            NSString *cardinfostr = [resultDict objectForKey:@"Cardinfo"];
            NSDictionary *carddict = [self dictionaryWithJsonString:cardinfostr];
            resultView.card = [NSString stringWithFormat:@"**********%@",[carddict objectForKey:@"Last4"]];
        }
        else {
            resultView.card = [resultDict objectForKey:@"MaskPan"];
        }
        resultView.reference = [resultDict objectForKey:@"Reference"];
        NSString * amountv = [NSString stringWithFormat:@"%@", [resultDict objectForKey:@"AuthorizedAmount"]];
        NSString * amountstr =  [self formatAmount:amountv];
        resultView.amount = amountstr;
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:self->resultView animated:YES];
        });
        if([[resultDict objectForKey:@"Module"] isEqualToString:@"M-10"])
        {
            [file addRecord:resultDict fromFile:CCSALE];
        }
        else if([[resultDict objectForKey:@"Module"] isEqualToString:@"B200"])
        {
             [file addRecord:resultDict fromFile:CFSALE];
        }else if([[resultDict objectForKey:@"Module"] isEqualToString:@"MP200"])
        {
            [file addRecord:resultDict fromFile:UPSALE];
        }
        
        
    }
    else{ // show Declined
        resultView=[[ResultViewController alloc]init];
        resultView.result=@"Declined";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:self->resultView animated:YES];
        });
    }
}

/**
 library request signature verification

 @param notifyflg YES need notify library, NO no need notify library
 */
-(void)verifySignature:(BOOL) notifyflg
{
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing Sale"
                                                                        message:@"Please Verify Signature" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self->slycepay signatureVerified:YES];

                                                         
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             [self->slycepay signatureVerified:NO];

                                                             
                                                         }];
    [inforAlert addAction:okAction];
    [inforAlert addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
          [self presentViewController:inforAlert animated:YES completion:nil];
    });
  
}

/**
 Return transaction is completed

 @param resultDict transaction result
 */
-(void)transactionReturnCompleted:(NSDictionary *)resultDict
{
 [slycepay APPLog:@"return APP %@",resultDict];
    [slycepay APPLog:@"%@",[resultDict objectForKey:@"Transtype"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([resultDict objectForKey:@"Error"] ==nil)
        {
            if([self->slycepay.currentModule isEqualToString:@"B200"])
            {
                [self->file removedRecord:self->selectedIndex fromFile:CFSALE];
                [self->file addRecord:resultDict fromFile:CFRETURN];
            }else if([self->slycepay.currentModule isEqualToString:@"MP200"])
            {
                [self->file removedRecord:self->selectedIndex fromFile:UPSALE];
                [self->file addRecord:resultDict fromFile:UPRETURN];
            }else
            {
                [self->file removedRecord:self->selectedIndex fromFile:CCSALE];
                [self->file addRecord:resultDict fromFile:CCRETURN];
            }
            [self showResult:@"Return SUCCESS"];
        }
        else
        {
              [self showResult:@"Retun FAILED"];
        }
     
    });
    
}

/**
 Transaction Capture is finished

 @param resultDict capture transaction result
 */
-(void)transactionCaptureCompleted:(NSDictionary *)resultDict
{
   [slycepay APPLog:@"APP capture %@",resultDict];
    if ([resultDict objectForKey:@"error"] == nil)
    {
        if([slycepay.currentModule isEqualToString:@"CALLAudio"])
        {
            [file removedRecord:selectedIndex fromFile:CFAUTH];
            [file addRecord:resultDict fromFile:CFSALE];
        }else if([slycepay.currentModule isEqualToString:@"MP200"])
        {
            [file removedRecord:selectedIndex fromFile:UPAUTH];
            [file addRecord:resultDict fromFile:UPSALE];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:@"Capture SUCCESS"];
        });
    }
    else
    {   dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:@"Capture FAILED"];
    });
    }

}
-(void) transactionMessageUpdate:(NSString *)msg
{
   messageLabel.text= [NSString stringWithFormat:@"%@\r%@",messageLabel.text,msg];
}

/**
 voice Referral is requesting operator call the bank and get the authcode

 @param notifyflg YES notify library NO no need notify library
 @param phoneNumber Number of call the bank
 */
-(void) voiceReferral:(BOOL)notifyflg withphone:(NSString *)phoneNumber
{
    NSString *msgTitle=[NSString stringWithFormat:@"Please Call %@",phoneNumber];

    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:msgTitle
                                                                        message:@"Please Enter AuthCode" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         UITextField *infoTextfield= inforAlert.textFields.firstObject;
                                                             [self->slycepay phoneReferral:YES withAuthcode:infoTextfield.text];
                                                         
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [self->slycepay phoneReferral:NO withAuthcode:@""];
                                                         
                                                     }];

    [inforAlert addTextFieldWithConfigurationHandler:^(UITextField* textfield){}];
    [inforAlert addAction:okAction];
    [inforAlert addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:inforAlert animated:YES completion:nil];
    });

}

/**
 when pin pad is disconnected, all the function must be disabled
 */
-(void) Pinpaddisattached
{
    [slycepay APPLog:@" pinpad disattached"];
}

/**
 when pinpad is disconnected, it will pop up
 */
-(void)Pinpadattached
{
    [slycepay APPLog:@" pinpad attached"];
    [self enableDevice];
    //call1=[[CallOne alloc] initwith:@"cem_123" fromServer:nil Delegate:self];
    //[call1 setLogMode:YES];
}
-(void)confirmCardinfo:(NSDictionary *)cardinfo
{
    NSLog( @"LOL crad %@",cardinfo.description);
    //[call1 cardinfoConfirmed:YES];
    NSString * card=[NSString stringWithFormat:@"%@*******%@", [cardinfo objectForKey:@"First6"], [cardinfo objectForKey:@"Last4"] ];
    [self confirmcard: card];
}

- (void)transactionVoidCompleted:(NSDictionary *)resultDict {
    [slycepay APPLog:@"APP void %@",resultDict];
    if ([resultDict objectForKey:@"error"] ==nil)
    {
        
            [file removedRecord:selectedIndex fromFile:UPSALE];
            //[file addRecord:resultDict fromFile:UPSALE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showResult:@"void SUCCESS"];
        });
    }
    else
    {   dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:@"void FAILED"];
    });
    }
}

- (void)TMSupdateComplete:(NSError *)error {
    
}




#pragma mark textField delgate

/**
 hide keyboard
 
 @param textField the object texfield
 @return return YES to hide keyboard
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/**
 format the input
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * temper = textField.text;
    
    if ([string isEqualToString:@""]){
        return YES;
    }
    temper = [self formatAmountStr:temper withInput:string];//processing ammount input
    textField.text = temper;
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
}
#pragma mark View operations

/**
 upldate message on the label
 
 @param content display messages
 */
-(void)updateInformationLabel:(NSString *) content {
    messageLabel.text= [NSString stringWithFormat:@"%@\r%@",messageLabel.text,content];
}

-(void) initComponents {
    [amountField setEnabled:NO];
    [connetPinBtn setEnabled:NO];
    [salebtn setEnabled:NO];
    [returnbtn setEnabled:NO];
    [cancelBtn setEnabled:NO];
    [authBtn setEnabled:NO];
    [capBtn setEnabled:NO];
    [voidBtn setEnabled:NO];
    [amountField setDelegate:self];
}

-(void) enableDevice
{
    [connetPinBtn setEnabled:YES];
}
-(void) enableTransaction
{
    [amountField setEnabled:YES];
    [salebtn setEnabled:YES];
    [returnbtn setEnabled:YES];
    [cancelBtn setEnabled:YES];
    [authBtn setEnabled:YES];
    [capBtn setEnabled:YES];
    [voidBtn setEnabled:YES];
}
-(void) disableAll
{
    [amountField setEnabled:NO];
    [connetPinBtn setEnabled:NO];
    [salebtn setEnabled:NO];
    [returnbtn setEnabled:NO];
    [cancelBtn setEnabled:NO];
    [authBtn setEnabled:NO];
    [capBtn setEnabled:NO];
    [voidBtn setEnabled:NO];
}


#pragma mark Btn functions

/**
 Cancel the transaction, not working for all modules
 
 @param sender events
 */
-(IBAction)cnlBtnClicked:(id)sender
{
    [slycepay terminateTransaction];
}
/**
 Void the transaction, get the trans file first, then build the transaction menu.
 after user select the transaction, process the void operation
 @param sender events
 */
-(IBAction)voidBtnClicked:(id)sender {
    NSString * filestr;
    // get the transaction file name
    if([slycepay.currentModule isEqualToString:@"MP200"]){
        filestr = [file readFile:@"Records" atFile:UPSALE];
    }else if([slycepay.currentModule isEqualToString:@"Miura 865"]){
        filestr = [file readFile:@"Records" atFile:CCSALE];
    }else if([slycepay.currentModule isEqualToString:@"B200"]){
        filestr = [file readFile:@"Records" atFile:CFSALE];
    }
    else {
        return;
    }
    if([filestr isEqual:[NSNull null]] || filestr == nil){
        return;
    }
    NSDictionary *filedic = [file StringToDictionary:filestr];
    NSArray *recordsArray = [filedic objectForKey:@"data"];
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing void" message:@"please select Transaction"   preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter = 0;
    // build the list of transactions
    for (NSDictionary *res in recordsArray)
    {
        NSString * cardinfostr = [res objectForKey:@"Cardinfo"];
        if(cardinfostr==nil){
            return;
        }
        NSDictionary * cardinfo = [file StringToDictionary:cardinfostr];
        NSString * title = [NSString stringWithFormat:@"%@*******%@,%@,%@",[cardinfo objectForKey:@"First6"],[cardinfo objectForKey:@"Last4"], [res objectForKey:@"Reference"],[res objectForKey:@"AuthorizedAmount"]];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSError *error;
                                                             self->selectedIndex = counter;
                                                             //build paymentinfo dict for the transaction
                                                             NSDictionary *paymentInfo= [self buildDictforrtn:[res objectForKey:@"Reference"] withCurrency:@"USD" andAmount:[res objectForKey:@"AuthorizedAmount"] cardinfo:cardinfostr];
                                                             [self->slycepay processVoid:paymentInfo withError:&error];
                                                             self->messageLabel.text = @"Processing Void";
                                                             [self->slycepay APPLog:@"void is selected %@",paymentInfo.description ];
                                                             if (error) {
                                                                 NSString * msg = [NSString stringWithFormat:@"return error %@",error.description];
                                                                 [self showResult:msg];
                                                             }
                                                             
                                                         }];
        [inforAlert addAction:okAction];
        counter ++;
    }
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             //result=@"cancel"
                                                             
                                                         }];
    [inforAlert addAction:cancelAction];
    // show the menual
    [self presentViewController:inforAlert animated:YES completion:nil];
}
/**
 return the transaction, get the trans file first, then build the transaction list.
 after user select the transaction, process the void operation
 @param sender events
 */
-(IBAction)rtnBtnClicked:(id)sender
{
    // get the transaction file name
    NSString * filestr;
    if([slycepay.currentModule isEqualToString:@"B200"]){
        filestr = [file readFile:@"Records" atFile:CFSALE];
    }else if([slycepay.currentModule isEqualToString:@"Miura 865"]) {
        filestr = [file readFile:@"Records" atFile:CCSALE];
    }else if([slycepay.currentModule isEqualToString:@"MP200"]) {
        filestr =[file readFile:@"Records" atFile:UPSALE];
    }
    else{
        return;
    }
    if([filestr isEqual:[NSNull null]])
    {
        return;
    }
    NSDictionary *filedic = [file StringToDictionary:filestr];
    NSArray *recordsArray = [filedic objectForKey:@"data"];
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing Return" message:@"please select Transaction"   preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter=0;
    // build the list of transactions
    for (NSDictionary *res in recordsArray)
    {
        NSString * cardinfostr = [res objectForKey:@"Cardinfo"];
        NSDictionary * cardinfo = [file StringToDictionary:cardinfostr];
        NSString * title=[NSString stringWithFormat:@"%@*******%@,%@,%@",[cardinfo objectForKey:@"First6"],[cardinfo objectForKey:@"Last4"], [res objectForKey:@"Reference"],[res objectForKey:@"AuthorizedAmount"]];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSError *error;
                                                             self->selectedIndex = counter;
                                                             //build request for return transaction
                                                             NSDictionary *paymentInfo= [self buildDictforrtn:[res objectForKey:@"Reference"] withCurrency:@"USD" andAmount:[res objectForKey:@"AuthorizedAmount"] cardinfo:cardinfostr];
                                                             [self->slycepay processReturn:paymentInfo withError:&error];
                                                             self->messageLabel.text=@"Processing Return";
                                                             [self->slycepay APPLog:@"return is selected %@",paymentInfo.description ];
                                                             if (error)
                                                             {
                                                                 NSString * msg= [NSString stringWithFormat:@"return error %@",error.description];
                                                                 [self showResult:msg];
                                                             }
                                                             
                                                         }];
        [inforAlert addAction:okAction];
        counter ++;
        
    }
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [inforAlert addAction:cancelAction];
    [self presentViewController:inforAlert animated:YES completion:nil];
}
/**
 Capture the Authorization transaction, get the trans file first, then build the transaction list.
 after user select the transaction, process the void operation
 @param sender events
 */
-(IBAction)capBtnClicked:(id)sender {
    if([amountField.text isEqualToString:@"0.00"]||amountField.text.length==0)
    {
        [self ErrorAlert:@"Enter Amount First"];
        return;
    }
    // get the transaction file name
    NSString * filestr;
    if([slycepay.currentModule isEqualToString:@"B200"]) {
        filestr = [file readFile:@"Records" atFile:CFAUTH];
    }else if([slycepay.currentModule isEqualToString:@"MP200"])
    {
        filestr = [file readFile:@"Records" atFile:UPAUTH];
    }
    NSDictionary *filedic= [file StringToDictionary:filestr];
    NSArray *recordsArray= [filedic objectForKey:@"data"];
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing Capture" message:@"please select Transaction"   preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter=0;
    // build the list of transactions
    for (NSDictionary *res in recordsArray)
    {
        NSString *cardinfostr= [res objectForKey:@"Cardinfo"];
        NSLog(@"%@",cardinfostr);
        NSDictionary * cardinfo = [file StringToDictionary:cardinfostr];
        NSString * title=[NSString stringWithFormat:@"%@*******%@,%@",[cardinfo objectForKey:@"First6"],[cardinfo objectForKey:@"Last4"], [res objectForKey:@"Reference"]];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSError *error;
                                                             self->selectedIndex = counter;
                                                             NSDictionary *paymentInfo = [self buildDictforcap:[res objectForKey:@"Reference"] withAmount:self->amountField.text andCardinfo:cardinfo];
                                                             [self->slycepay processCapture:paymentInfo withError:&error];
                                                             self->messageLabel.text=@"Processing Capture";
                                                             if(error) {
                                                                 [self->slycepay APPLog:@"processCapture Error:%lld",(long long)error.code];
                                                                 return ;
                                                             }
                                                             
                                                         }];
        [inforAlert addAction:okAction];
        counter ++;
        
        
    }
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [inforAlert addAction:cancelAction];
    [self presentViewController:inforAlert animated:YES completion:nil];
}

/**
 Start sale transaction
 
 @param sender evnet
 */
-(IBAction)saleBtnClicked:(id)sender
{
    messageLabel.text=@"";
    NSError *error;
    [amountField resignFirstResponder];
    if([amountField.text isEqualToString:@"0.00"]||amountField.text.length==0) {
        [self ErrorAlert:@"Enter Amount First"];
    }
    else{
        [messageLabel setText:@"start Transaction:"];
        NSDictionary *saleDict = [self buildSaleDict:amountField.text withTender:@"credit"];
        [slycepay processSale:saleDict withError:&error];
        if(error){
            [slycepay APPLog:@" processSale Error:%lld",(long long)error.code];
            return ;
        }
    }
    
}
/**
 Start Auth transaction
 @param sender evnet
 */
-(IBAction)authBtnClicked:(id)sender
{
    messageLabel.text=@"";
    NSError *error;
    [amountField resignFirstResponder];
    if([amountField.text isEqualToString:@"0.00"]||amountField.text.length==0)
    {
        [self ErrorAlert:@"Enter Amount First"];
    }
    else{
        [messageLabel setText:@"start Transaction:"];
        NSDictionary *authDict=[self buildAuthDict:amountField.text withTender:@"credit"];
        [slycepay processAuthorization:authDict withError:&error];
        if(error) {
            [slycepay APPLog:@" processAuth Error:%lld",(long long)error.code];
            
            return ;
        }
    }
    
}


/**
 start connect pinpad
 
 @param sender event
 */
-(IBAction)connectPinpadClicked:(id)sender
{
    NSArray * devlise=[slycepay getDevice];
    // if no pinpad
    if ([devlise count] == 0)
    {
        [self ErrorAlert:@"No Pinpad"];
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"DeviceList"
                                                                   message:@"Please Select one"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter = 0;
    for(counter=0;counter<[devlise count];counter++){
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:[devlise objectAtIndex:counter] style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self connectPinPad:[devlise objectAtIndex:counter]];
                                                              }];
        [alert addAction:defaultAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

/**
 init the library, it just need token to
 
 @param sender event
 */
-(IBAction)initbtnClicked:(id)sender
{
    messageLabel.text = @"";
    [self updateInformationLabel:@"Start"];

    tokenField.text=@"3fyl02KZBOERy7yEd6SkWqbuYmGqHQ2T";//cardflight;
    if([tokenField.text isEqual:[NSNull null]]||tokenField.text.length==0){
        [self updateInformationLabel:@"Enter CMS Token Please"];
        return;
    }
    slycepay = [[SlycePay alloc] initwith:tokenField.text Delegate:self];
    //setting debug mode if token is production, the setting would not working
    [slycepay setfilemode:NO];
    [slycepay setLogMode:YES];
    [tokenField resignFirstResponder];
}
-(IBAction)clearlogs:(id)sender
{
    //[call1 RSAtest];
    [slycepay ClearLog];
}

/**
 when libary need confirm card
 
 @param cardinfo Cardinfo JsonString
 */
-(void)confirmcard: (NSString *) cardinfo
{
    UIAlertController* confirmAlert = [UIAlertController alertControllerWithTitle:@"Please confirm Card"
                                                                          message:cardinfo
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self->slycepay cardinfoConfirmed:YES];
                                                      }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self->slycepay cardinfoConfirmed:NO];
                                                     }];
    [confirmAlert addAction:yesAction];
    [confirmAlert addAction:noAction];
    [self presentViewController:confirmAlert animated:YES completion:nil];
}




#pragma mark Utilis

/**
 init all files
 */
-(void) initFiles {
    file = [[FileControl alloc]init];
    [file deleteFile:@"Records" theFile:CCRETURN];
    [file deleteFile:@"Records" theFile:CFRETURN];
    [file createRecordFile:CCSALE];
    [file createRecordFile:CCRETURN];
    [file createRecordFile:CFSALE];
    [file createRecordFile:CFRETURN];
    [file createRecordFile:CFAUTH];
    [file createRecordFile:CFCAPTURE];
    [file createRecordFile:UPSALE];
    [file createRecordFile:UPRETURN];
    [file createRecordFile:UPAUTH];
    [self processTokenfile];
    
}

/**
 transfer json string to nsdictionary
 
 @param jsonString JSON
 @return NSDictionary
 */
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic;
    dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                          options:NSJSONReadingMutableContainers
                                            error:&err];
    if(err){
        NSLog(@"jsonfailure：%@",err);
        return nil;
    }
    return dic;
}

/**
 valid amount input if not number, return NO otherwise return YES
 
 @param inputstr input string
 @return YES validated NO invalid
 */
- (BOOL)validInput:(NSString*)inputstr {
    if (inputstr.length == 0)  //delete operation
        return YES;
    int asciiCode = [inputstr characterAtIndex:0];
    if (asciiCode >= 48 && asciiCode <= 57)
        return YES;
    else
        return NO;
    
}

/**
 format amount for
 
 @param basicAmt basic amount inour
 @param input input amount
 @return formated amount
 */
-(NSString *) formatAmountStr: (NSString *) basicAmt withInput:(NSString*) input
{
    NSString * temper=basicAmt;
    NSString * header;
    NSString * tail;
    if ([self validInput:input])
    {
        temper =[temper stringByAppendingString:input];
        NSRange r= [temper rangeOfString:@"."];
        NSLog(@" r %ld",(long)r.location );
        if (r.location<temper.length)
        {
            temper = [temper stringByReplacingCharactersInRange:r withString:@""];
        }
        NSInteger i= [temper intValue];
        NSLog(@" ri %ld",(long)i );
        temper = [NSString stringWithFormat:@"%ld",(long)i];
        switch (temper.length) {
            case 0:
                return temper;
                break;
            case 1:
                temper = [NSString stringWithFormat:@"0.0%@",temper];
                
                break;
            case 2:
                temper = [NSString stringWithFormat:@"0.%@",temper];
                break;
            default:
                header = [temper substringToIndex:temper.length-2];
                tail = [temper substringFromIndex:temper.length-2];
                temper = [NSString stringWithFormat:@"%@.%@",header,tail];
                break;
        }
        
        return temper;
        
    }
    return temper;
}

/**
 Build Sale Dictionary
 @param amount Amount String
 @param tender Tender information credit debit
 @return NSDictionary for sale transaction
 */
-(NSDictionary*) buildSaleDict:(NSString*) amount withTender:(NSString*) tender
{
    NSString* amountValue = [amount stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSArray *key = [[NSArray alloc] initWithObjects:@"Amount",@"Tender", nil];
    NSArray *value = [[NSArray alloc] initWithObjects:amountValue,tender,nil];
    NSDictionary *t = [[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    return t;
}
/**
 Build Auth Dictionary
 @param amount Amount String
 @param tender Tender information credit
 @return NSDictionary for void transaction
 */
-(NSDictionary*) buildAuthDict:(NSString*) amount withTender:(NSString*) tender
{
    NSString* amountValue= [amount stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSArray *key=[[NSArray alloc] initWithObjects:@"Amount",@"Tender", nil];
    NSArray *value= [[NSArray alloc] initWithObjects:amountValue,tender,nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    return t;
}

/**
 Build return Dictionary
 
 @param referencestr reference of origional transaction
 @param currency "USD"
 @param amount Formated amount value
 @param card cardinformation if no present, the value will be all '0's as defalut
 @return NSDictionary for return transaction
 */
-(NSDictionary*) buildDictforrtn:(NSString*) referencestr withCurrency:(NSString*)currency andAmount:(NSString*)amount cardinfo:(NSString*) card
{
    
    
    NSArray *key=[[NSArray alloc] initWithObjects:@"Reference",@"currency",@"description", @"Tender",@"Amount",@"Cardinfo",nil];
    NSArray *value= [[NSArray alloc] initWithObjects:referencestr,currency,@"",@"credit",amount,card,nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    return t;
}

/**
 Build Capture Dictionary
 
 @param referencestr referencestr reference of origional transaction
 @param amount Amount String 100 as 1.00
 @param dic cardinfo if not present, the value will be all '0's as default
 @return capture Dictionray
 */
-(NSDictionary*) buildDictforcap:(NSString*) referencestr withAmount:(NSString*)amount andCardinfo:(NSDictionary*)dic
{
    NSString* amountValue= [amount stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSArray *key=[[NSArray alloc] initWithObjects:@"Reference",@"Amount",@"description",@"Cardinfo", nil];
    NSArray *value= [[NSArray alloc] initWithObjects:referencestr,amountValue,@"",[file dictionaryToString:dic],nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    // t =  @{@"Amount":@"",@"Reference":@""};
    return t;
}

/**
 Show result for transactions
 
 @param message transaction result JSON string
 */
-(void) showResult:(NSString *) message
{
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Result"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                     }];
    [errorAlert addAction:okAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

/**
 show errors such as no amount etc
 
 @param message error message
 */
-(void)ErrorAlert: (NSString *) message
{
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                     }];
    
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}
/**
 start pinpad connection to library, if TMS is required, it will proceed the TMS update
 */
-(void)connectPinPad:(NSString*)name {
    NSError * error;
    [slycepay connectDevice:name configerror:&error];
    // check error, if tms error, then start tem, otherwise show error
    if (error) {
        
        [self ErrorAlert:error.description];
    }
}

/**
 if token file CMSTokens.txt is exist, then it will pop up the select menu and asking user to selecte
 */
-(void) processTokenfile{
    @try {
        NSString * res = [file readFile:@"" atFile:@"CMSTokens.txt"];
        NSDictionary *tokendic = [file StringToDictionary2:res];
        NSArray *tokenarray = [tokendic objectForKey:@"CMSTokens"];
        UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"CMS Token List"
                                                                            message:@"Please Select Token" preferredStyle:UIAlertControllerStyleAlert];
        for (NSDictionary *token in tokenarray){
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:[token objectForKey:@"Token"] style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self -> tokenField setText:[token objectForKey:@"Token"]];
                                                                 [self initbtnClicked:nil];
                                                             }];
            [inforAlert addAction:okAction];
        }
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        [inforAlert addAction:cancelAction];
        [self presentViewController:inforAlert animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"no token");
    }
}


-(NSString*)formatAmount:(NSString*)amountstr
{
    NSString * res;
    NSRange range;
    NSString * header;
    NSString * tail;
    @try
    {
        range = [amountstr rangeOfString:@"."];
        
        res = [amountstr stringByReplacingOccurrencesOfString:@"$"withString:@""];
        if (range.location==NSNotFound)
        {
            switch (res.length) {
                case 0:
                    return @"0.00";
                    break;
                case 1:
                    res =[NSString stringWithFormat:@"0.0%@",res];
                    
                    break;
                case 2:
                    res =[NSString stringWithFormat:@"0.%@",res];
                    break;
                default:
                    header= [res substringToIndex:res.length-2];
                    tail =[res substringFromIndex:res.length-2];
                    res=[NSString stringWithFormat:@"%@.%@",header,tail];
                    break;
            }
        }else {
            NSLog(@"rang.location %ld, %ld", range.location, res.length);
            if(range.location+2 == res.length)
            {
                return [NSString stringWithFormat:@"%@0",res];
            }
        }
    }
    @catch(NSException *e)
    {
        return @"0.00";
    }
    if([res isEqual:[NSNull null]]||res==nil)
    {
        res=@"0.00";
    }
    return res;
}




@end
