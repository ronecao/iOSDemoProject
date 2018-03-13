//
//  Record.h
//  filetest
//
//  Created by Chris on 28/06/2017.
//  Copyright © 2017 Chris. All rights reserved.
//

#import <Call1/FileControl.h>

@interface FileControl(Recorder)
-(BOOL)createRecordFile:(NSString*)recordname;
-(BOOL)addRecord:(NSDictionary *)record fromFile:(NSString*) filename;
-(NSDictionary*)getRecord:(NSInteger)index fromFile:(NSString*)filename;
-(BOOL)removedRecord:(NSInteger)index fromFile:(NSString*)filename;
-(BOOL)updateRecord:(NSDictionary *)dic atIndex:(NSInteger)index fromFile:(NSString*)filename;
-(NSMutableDictionary *)StringToDictionary:(NSString *)dicstr;
-(NSString *)dictionaryToString:(NSDictionary *)dic;
-(NSMutableDictionary *)StringToDictionary2:(NSString *)dicstr;
@end
