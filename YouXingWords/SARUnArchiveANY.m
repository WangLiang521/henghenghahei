//
//  SARUnArchiveANY.m
//  SARUnArchiveANY
//
//  Created by Saravanan V on 26/04/13.
//  Copyright (c) 2013 SARAVANAN. All rights reserved.
//

#import "SARUnArchiveANY.h"
#import "LZMAExtractor.h"
#import "SSZipArchive.h"

@implementation SARUnArchiveANY
@synthesize completionBlock;
@synthesize failureBlock;


#pragma mark - Init Methods
- (id)initWithPath:(NSString *)path {
	if ((self = [super init])) {
		_filePath = [path copy];
        _fileType = [[NSString alloc]init];
	}

    if (_filePath != nil) {
        _destinationPath = [self getDestinationPath];
    }
	return self;
}

- (id)initWithPath:(NSString *)path andPassword:(NSString*)password{
    if ((self = [super init])) {
        _filePath = [path copy];
        _password = [password copy];
        _fileType = [[NSString alloc]init];
    }
    
    if (_filePath != nil) {
        _destinationPath = [self getDestinationPath];
    }
    return self;
}

#pragma mark - Helper Methods
- (NSString *)getDestinationPath{
    NSArray *derivedPathArr = [_filePath componentsSeparatedByString:@"/"];
    NSString *lastObject = [derivedPathArr lastObject];
    _fileType = [[lastObject componentsSeparatedByString:@"."] lastObject];
    return [_filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",lastObject] withString:@""];
}


#pragma mark - Decompressing Methods
- (void)decompress{
    //    NSLog(@"_fileType : %@",_fileType);
    if ( [_fileType compare:rar options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
    }
    else if ( [_fileType compare:zip options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        [self zipDecompress];
    }
    else if ( [_fileType compare:@"7z" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        [self decompress7z];
    }
}


- (void)zipDecompress{
//    NSString *tmpDirname = @"Extract zip";
//    _destinationPath = [_destinationPath stringByAppendingPathComponent:tmpDirname];
    BOOL unzipped = [SSZipArchive unzipFileAtPath:_filePath toDestination:_destinationPath delegate:self];
    //    NSLog(@"unzipped : %d",unzipped);
    NSError *error;
    if (self.password != nil && self.password.length > 0) {
        unzipped = [SSZipArchive unzipFileAtPath:_filePath toDestination:_destinationPath overwrite:NO password:self.password error:&error delegate:self];
        NSLog(@"error: %@", error);
    }
    
    if ( !unzipped ) {
        failureBlock();
    }
}


- (void)decompress7z{
    NSString *tmpDirname = @"7z";
    _destinationPath = [_destinationPath stringByAppendingPathComponent:tmpDirname];
    
    NSArray *contents = [LZMAExtractor extract7zArchive:_filePath dirName:_destinationPath preserveDir:YES];
    
//    UnComment below lines to see the path of each file extracted    
//    for (NSString *entryPath in contents) {
//        NSLog(@"entryPath : %@", entryPath);
//    }
    
    if (![contents count]) {
        failureBlock();
    }
    else{
        completionBlock(contents);
    }
}



#pragma mark - Utility Methods
- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}





#pragma mark - Not using these methods now
//Writing this for Unrar4iOS, since it just unrar's(decompresses) the files into the compressed(rar) file's folder path
- (void)moveFilesToDestinationPathFromCompletePaths:(NSArray *)completeFilePathsArray withFilePaths:(NSArray *)filePathsArray{
    if ( _destinationPath == [self getDestinationPath] ) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    for ( NSString *filePath in completeFilePathsArray ){
        int index = [completeFilePathsArray indexOfObject:filePath];
        NSString *fileDestinationPath = [_destinationPath stringByAppendingPathComponent:[filePathsArray objectAtIndex:index]];
        if([fileManager fileExistsAtPath:fileDestinationPath]){
            [fileManager removeItemAtPath:fileDestinationPath error:&error];
        }
        else{
            NSLog(@"filePath : %@",filePath);
            if(![fileManager moveItemAtPath:filePath
                                     toPath:fileDestinationPath
                                      error:&error])
            {
                //TODO: Handle error
                NSLog(@"Error: %@", error);
            }
        }
    }
    
}

@end
