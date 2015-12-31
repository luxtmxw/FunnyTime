//
//  UINavigationController+InterfaceOrientation.m
//  FunnyTime
//
//  Created by luxt on 15/10/8.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "UINavigationController+InterfaceOrientation.h"

@implementation UINavigationController (InterfaceOrientation)


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return 0;
}
- (BOOL)shouldAutorotate {
    return NO;
}



@end
