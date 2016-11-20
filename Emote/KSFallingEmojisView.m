//
//  KSFallingEmojisView.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSFallingEmojisView.h"

@implementation KSFallingEmojisView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupFallingEmojisView];
    }
    
    return self;
}

-(void)setupFallingEmojisView
{
    CAEmitterLayer *emitter = [[CAEmitterLayer alloc] init];
    emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, 0);
    emitter.emitterSize = self.bounds.size;
    emitter.emitterShape = kCAEmitterLayerRectangle;
    
    NSMutableArray *emitterCells = [[NSMutableArray alloc] init];
    [emitterCells addObject:[self getEmitterCellWithImageNamed:@"blush"]];
    [emitterCells addObject:[self getEmitterCellWithImageNamed:@"grimacing"]];
    [emitterCells addObject:[self getEmitterCellWithImageNamed:@"grin"]];
    [emitterCells addObject:[self getEmitterCellWithImageNamed:@"innocent"]];
    [emitterCells addObject:[self getEmitterCellWithImageNamed:@"thumbsup"]];
    [emitterCells addObject:[self getEmitterCellWithImageNamed:@"yum"]];
    
    emitter.emitterCells = emitterCells;
    
    [self.layer addSublayer:emitter];
}

-(CAEmitterCell*)getEmitterCellWithImageNamed:(NSString*)imageName
{
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc] init];
    emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
    emitterCell.birthRate = 1;
    emitterCell.lifetime = 20.0;
    emitterCell.velocity = 5;
    emitterCell.velocityRange = 350;
    emitterCell.yAcceleration = 35;
    emitterCell.xAcceleration = 5;
    emitterCell.scale = 0.5;
    
    return emitterCell;
}

@end
