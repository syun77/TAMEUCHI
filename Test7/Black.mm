//
//  Black.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Black.h"

#import "GameScene.h"
#import "Exerinya.h"

@implementation Black

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    [self load:@"all.png"];
    
    [super create];
    CGRect r = Exerinya_GetRect(eExerinyaRect_Black);
    [self setTexRect:r];
    
    [self setVisible:NO];
    
    self._x = System_CenterX();
    self._y = System_CenterY();
    [self move:0];
    self.m_pSprite.scaleX = System_Width();
    self.m_pSprite.scaleY = System_Height();
    [self setAlpha:0x20];
    [self setBlend:eBlend_Normal];
    
    return self;
}
- (void)update:(ccTime)dt {
    
//    GameScene* scene = [GameScene sharedInstance];
//    
//    if ([scene isLevelUp]) {
//        [self setVisible:YES];
//    }
//    else {
//        
//        [self setVisible:NO];
//    }
}

- (void)visit {
    [super visit];
}

@end
