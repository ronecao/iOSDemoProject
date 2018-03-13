//
//  FileControl.h
//  Slyce1
//
//  Created by Chris on 21/06/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileControl : NSObject
-(NSString *)getDocumentDir;
-(BOOL)createDir:(NSString *) dirName;
-(void)appendContent:(NSString *)content inDir:(NSString*)dir atFile:(NSString*) filename;
-(NSString *)readFile:(NSString*)dir atFile:(NSString *)filename;
-(BOOL)createFile:(NSString*)dir withFilename:(NSString *)filename;
-(BOOL)writeFile:(NSString *)content inDir:(NSString*)dir atFile:(NSString*) filename;
-(NSArray*)getfileList:(NSString*)dir;
-(void)deleteFile:(NSString*) dir theFile:(NSString*) filename;
@end
