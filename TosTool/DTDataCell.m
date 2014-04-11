//
//  DTDataCell.m
//  TosTool
//
//  Created by DanielTien on 2014/4/5.
//  Copyright (c) 2014年 DanielTien. All rights reserved.
//

#import "DTDataCell.h"

@implementation DTDataCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSDictionary *waveInfo = (NSDictionary *)[self objectValue];
    NSArray *enemies = waveInfo[@"enemies"];
    NSString *title = @"關卡資訊：";

    CGFloat x = cellFrame.origin.x;
    CGFloat y = cellFrame.origin.y;
    
    [title drawAtPoint:NSMakePoint(x,y) withAttributes:nil];
    
    CGFloat i = 40.0;
    NSDictionary *lootItem = nil;
    for (NSDictionary *enemie in enemies) {
        CGPoint point = NSMakePoint(x + i, y + 20.0);
        i+= 64.0;
        NSString *monsterId = enemie[@"monsterId"];
        NSString *mosterImageName = [NSString stringWithFormat:@"60px-%03di.png",[monsterId intValue]];
        NSImage *mosterImage = [NSImage imageNamed:mosterImageName];
        [mosterImage drawInRect:NSMakeRect(point.x,point.y,60.0, 60.0)];
        
        if ([enemie[@"lootItem"] respondsToSelector:@selector(objectForKey:)]) {
            lootItem = enemie[@"lootItem"];
        }
    }
    
    if (lootItem) {
        i += 20.0;
        CGFloat x = cellFrame.origin.x + i;
        CGFloat y = cellFrame.origin.y;
        NSString *lootItemTitle = @"掉落物品";
        [lootItemTitle drawAtPoint:NSMakePoint(x, y) withAttributes:nil];
        
        NSString *type = lootItem[@"type"];
        if ([type isEqualToString:@"money"]) {
            NSString *money = [NSString stringWithFormat:@"金幣 %5d",[lootItem[@"amount"] intValue]];
            [money drawAtPoint:NSMakePoint(x, y + 20.0) withAttributes:nil];
        }
        else if ([type isEqualToString:@"monster"]) {
            NSDictionary *card = lootItem[@"card"];
            NSString *monsterId = card[@"monsterId"];
            NSString *monsterImageName = [NSString stringWithFormat:@"60px-%03di.png",[monsterId intValue]];
            NSImage *mosterImage = [NSImage imageNamed:monsterImageName];
            [mosterImage drawInRect:NSMakeRect(x,y + 20.0,60.0, 60.0)];
        }
        else if([type isEqualToString:@"item"]) {
            NSString *money = @"碎片等其他東西";
            [money drawAtPoint:NSMakePoint(x, y + 20.0) withAttributes:nil];
        }
    }
}
@end
