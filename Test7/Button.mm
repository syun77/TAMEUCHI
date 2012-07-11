//
//  Button.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Button.h"


@implementation Button

@synthesize m_Text;


/**
 * 選択中かどうか
 */
- (BOOL)isSelected {
    return m_bSelected;
}

@end
