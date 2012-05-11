//
//  Black.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/06.
//  Copyright 2012年 2dgames.jp. All rights reserved.
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
    
    if (self.visible) {
        // ゲームオーバー時の帯描画
        glColor4f(0, 0, 0, 0.5f);
       
        float cx = System_CenterX();
        float cy = System_CenterY();
        float w = System_Width();
        float h = 64;
        
        [self fillRect:cx cy:cy w:w h:h rot:0 scale:1];
        
    }
}

@end
