//
//  DTAppDelegate.m
//  TosTool
//
//  Created by DanielTien on 2014/4/3.
//  Copyright (c) 2014年 DanielTien. All rights reserved.
//

#import "DTAppDelegate.h"
#import "DTTosDataManager.h"
#import "DTDataCell.h"
@interface  DTAppDelegate () <DTTosDataManagerDelegate>
{
    DTTosDataManager *manager;
    NSTableView *tableView;
    NSArray *waves;
}
@property (nonatomic,weak) IBOutlet NSView *view;
@property (nonatomic,weak) IBOutlet NSTextField *deviceTextField;
@property (nonatomic,weak) IBOutlet NSTextField *infoTextField;
@end

@implementation DTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //View
    NSRect rect = NSMakeRect(0, 0, self.view.bounds.size.width, 600);
    
    tableView = [[NSTableView alloc] initWithFrame:rect];
    [tableView setDelegate:(id)self];
    [tableView setDataSource:(id)self];
    [tableView setBackgroundColor:[NSColor clearColor]];
    [tableView setGridStyleMask:NSTableViewGridNone];
    [tableView setGridColor:[NSColor clearColor]];
    [tableView setIntercellSpacing:NSMakeSize(0.0, 0.0)];
    NSTableColumn *column = [[NSTableColumn alloc] init];
    [tableView addTableColumn:column];
    [column setHidden:YES];
    
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:rect];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setDocumentView:tableView];
    [self.view addSubview:scrollView];

    // Manager
    manager  = [[DTTosDataManager alloc] init];
    manager.delegate = self;
    [manager startListen];
}


- (IBAction)refrech:(id)sender
{
    [manager refrech];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return waves.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return waves[row];
}


#pragma mark - TableView Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 140.0;
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    DTDataCell *cell = [[DTDataCell alloc] init];
    return cell;
}

#pragma mark - DTTosDatamanager Delegate
- (void)tosDataManager:(DTTosDataManager *)inManager deviceDConnected:(NSString *)inDeviceName
{
    self.deviceTextField.stringValue = inDeviceName;
}

- (void)tosDataManager:(DTTosDataManager *)inManager deviceDisconnected:(NSString *)inDeveceName
{
    self.deviceTextField.stringValue = @"device name";
}

- (void)tosDataManager:(DTTosDataManager *)inmManager didFetchData:(NSArray *)inWavesInfo
{
    waves = inWavesInfo;
    [tableView reloadData];
}

@end
