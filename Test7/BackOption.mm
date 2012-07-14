//
//  BackOption.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackOption.h"
#import "Exerinya.h"

@implementation BackOption

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self create];
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_Back);
    [self setTexRect:r];
    
    self._x = System_CenterX();
    self._y = System_CenterY();
    [self move:0];
    
    return self;
}

- (void)update:(ccTime)dt {
    
}

- (void)visit {
    [super visit];
    
    System_SetBlend(eBlend_Normal);
    glColor4f(0, 0, 0, 0.2);
    [self fillRect:System_CenterX() cy:System_CenterY() w:240 h:160 rot:0 scale:1];
}

@end
