//
//  DTTosDataManager.m
//  TosTool
//
//  Created by DanielTien on 2014/4/4.
//  Copyright (c) 2014年 DanielTien. All rights reserved.
//

#import "DTTosDataManager.h"
#import "FileSystemNode.h"
#import "MobileDeviceAccess.h"
#include "zip.h"
#include <sys/stat.h>
#include <libgen.h>
#include <stdio.h>
#import "SZJsonParser.h"

static NSString *tosBundleID = @"com.madhead.tos.zh";
static NSString *tosPlistName = @"com.madhead.tos.zh.plist";

@interface DTTosDataManager () <MobileDeviceAccessListener,AMInstallationProxyDelegate,NSTableViewDataSource>
{
    dispatch_queue_t _gcdQueue;
    AFCApplicationDirectory* _afcHander;
}
@end

@implementation DTTosDataManager

- (id)init
{
    self = [super init];
    if (self) {
        _gcdQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (void)startListen
{
    [[MobileDeviceAccess singleton] setListener:self];
}

#pragma mark - MobileDeviceAccessListener

- (void)deviceConnected:(AMDevice*)device
{
    AMInstallationProxy *instProxy = [device newAMInstallationProxyWithDelegate:self];
    AMApplication* tosApp = nil;
    for (AMApplication* app in [instProxy browse:@"User"]) {
        if ([app.bundleid isEqualToString:tosBundleID]) {
            tosApp = app;
        }
    }
    _afcHander = [device newAFCApplicationDirectory:[tosApp bundleid]];
    
    [self.delegate tosDataManager:self deviceDConnected:device.deviceName];
    [self refrech];
}

- (void)deviceDisconnected:(AMDevice*)device
{
    [self.delegate tosDataManager:self deviceDisconnected:device.deviceName];
}

#pragma mark - Action

- (IBAction)refrech
{
    dispatch_async (_gcdQueue, ^{
        FileSystemNode *fileNode;
        FileSystemNode *rootNode = [[FileSystemNode alloc] initWithPath:@"Library/Preferences" afcHander:_afcHander];
        for (FileSystemNode *node in rootNode.children) {
            if ([node.displayName isEqualToString:tosPlistName] ) {
                fileNode = node;
            }
        }
        
        AFCFileReference* afcFile = [_afcHander openForRead:fileNode.path];
        uint32_t amount = 0;
        char buf[8192];
        NSMutableData *data = [[NSMutableData alloc] init];
        do{
            amount = [afcFile readN:sizeof(buf) bytes:buf];
            [data appendBytes:buf length:amount];
        }while (amount > 0);
        
        CFPropertyListRef list = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)(data), kCFPropertyListImmutable, NULL);
        NSDictionary *dic = (__bridge id)list;
        NSString *floor_dataString = dic[@"MH_CACHE_RUNTIME_DATA_CURRENT_FLOOR_ENTER_DATA"];
        NSRange range = [floor_dataString rangeOfString:@"{"];
        NSDictionary *floor = [[floor_dataString substringFromIndex:range.location] jsonObject];
        NSArray *waves = floor[@"waves"];
        [self.delegate tosDataManager:self didFetchData:waves];
    });
}
@synthesize delegate;
@end
