//
//  DTTosDataManager.h
//  TosTool
//
//  Created by DanielTien on 2014/4/4.
//  Copyright (c) 2014年 DanielTien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTTosDataManager;

@protocol DTTosDataManagerDelegate <NSObject>
- (void)tosDataManager:(DTTosDataManager *)inManager deviceDConnected:(NSString *)inDeviceName;
- (void)tosDataManager:(DTTosDataManager *)inManager deviceDisconnected:(NSString *)inDeveceName;
- (void)tosDataManager:(DTTosDataManager *)inManager didFetchData:(NSArray *)inWavesInfo;

@end

@interface DTTosDataManager : NSObject

- (void)startListen;
- (void)refrech;

@property (nonatomic,assign) id<DTTosDataManagerDelegate> delegate;
@end
