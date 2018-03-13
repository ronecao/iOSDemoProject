//
//  Record.m
//  filetest
//
//  Created by Chris on 28/06/2017.
//  Copyright © 2017 Chris. All rights reserved.
//

#import "FileControl+Recorder.h"

@implementation FileControl(Recorder)

-(BOOL) createRecordFile:(NSString *)recordname
{
   NSArray * array= [self getfileList:@"Records"];
    BOOL res=NO;
    if (array==nil|| [array count]==0)
    {
        res = [self createDir:@"Records"];
        res = [self createFile:@"Records" withFilename:recordname];
        return res;
    }
    
    for (NSString *file in array)
    {
        if ([file isEqual:recordname])
        {
            return YES;
        }
    }
    
    res=[self createFile:@"Records" withFilename:recordname];
    
    return res;
}
-(BOOL)addRecord:(NSDictionary *)record fromFile:(NSString*) filename
{
    BOOL res = NO;
    NSString * recordstr= [self readFile:@"Records" atFile:filename];
    NSError *error;
    if (recordstr ==nil|| recordstr.length==0)//new Recordfile
    {
         NSNumber * i= [[NSNumber alloc]initWithInt:1];
        NSMutableDictionary * filedic=[[NSMutableDictionary alloc]init];
        NSMutableArray * arrayv= [[NSMutableArray alloc]init];
        NSMutableDictionary * valuerecord= [[NSMutableDictionary alloc]initWithDictionary:record];
        [valuerecord setValue:i forKey:@"Index"];
        [arrayv addObject:valuerecord];
        [filedic setObject:arrayv forKey:@"data"];
       
         [filedic setValue:i forKey:@"NumberOfRecrods"];
        
        NSString *jsonString = [self dictionaryToString:filedic];

       res= [self writeFile:jsonString inDir:@"Records" atFile:filename];
        return res;
    }
    
    if(error)//error return
    {
        return NO;
    }
    
    NSMutableDictionary * dic= [self StringToDictionary:recordstr];
    NSNumber * i = [dic objectForKey:@"NumberOfRecrods"];
    
    NSInteger newi= [i integerValue];
    newi++;
    NSMutableArray * newvaluearray= [dic objectForKey:@"data"];
    
    NSMutableDictionary * valuerecord= [[NSMutableDictionary alloc]initWithDictionary:record];
    [valuerecord setValue:[[NSNumber alloc] initWithInt:(int)newi] forKey:@"Index"];
    [newvaluearray addObject:valuerecord];
    [dic setObject:newvaluearray forKey:@"data"];
    
    
    [dic setObject:[[NSNumber alloc] initWithInt:(int)newi]  forKey:@"NumberOfRecrods"];
    
    
    
    NSString *jsonString = [self dictionaryToString:dic];
    res= [self writeFile:jsonString inDir:@"Records" atFile:filename];
    return res;
}
-(NSDictionary*)getRecord:(NSInteger)index fromFile:(NSString*)filename
{
    NSDictionary *d;
  NSString * filestr=  [self readFile:@"Records" atFile:filename];
    d = [self StringToDictionary:filestr];
    NSNumber * number= [d objectForKey:@"NumberOfRecrods"];
    
    if(index<[number integerValue])
    {
    
       
        NSArray * array= [d objectForKey:@"data"];
    
        d = [array objectAtIndex:index];
    }
    else
    {
        d=nil;
    }
    return d;
}

-(BOOL)removedRecord:(NSInteger)index fromFile:(NSString*)filename
{
    NSMutableDictionary *d;
    
    BOOL res=NO;
    NSString * filestr=  [self readFile:@"Records" atFile:filename];
    d = [self StringToDictionary:filestr];
    NSNumber * number= [d objectForKey:@"NumberOfRecrods"];
    if(index<[number integerValue])
    {
        
        NSMutableArray * array= [d objectForKey:@"data"];
        
        [array removeObjectAtIndex:index];
        NSInteger newint= [number integerValue];
        newint --;
        number = [[NSNumber alloc] initWithInt:(int)newint];
        [d removeAllObjects];
        [d setObject:array forKey:@"data"];
        [d setObject:number forKey:@"NumberOfRecrods"];
        NSString * writestr= [self dictionaryToString:d];
      res=  [self writeFile:writestr inDir:@"Records" atFile:filename];
    }
    return res;
}

-(BOOL)updateRecord:(NSDictionary *)dic atIndex:(NSInteger)index fromFile:(NSString*)filename
{
    BOOL res=NO;
    NSMutableDictionary *d;
    NSString * filestr=  [self readFile:@"Records" atFile:filename];
    d = [self StringToDictionary:filestr];
    NSNumber * number= [d objectForKey:@"NumberOfRecrods"];
    if(index<[number integerValue])
    {
        
        NSMutableArray * array= [d objectForKey:@"data"];
        
        [array replaceObjectAtIndex:index withObject:dic];
        [d setObject:array forKey:@"data"];
        NSString * writecontent= [self dictionaryToString:d];
        res=[self writeFile:writecontent inDir:@"Records" atFile:filename];
    }
    return res;
}


-(NSString *)dictionaryToString:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSMutableDictionary *)StringToDictionary:(NSString *)dicstr
{
    NSError *error;
    NSData *jsonData = [dicstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    return dic;
}
-(NSMutableDictionary *)StringToDictionary2:(NSString *)dicstr
{
    NSError *error;
    NSData *jsonData = [dicstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    return dic;
}
@end
