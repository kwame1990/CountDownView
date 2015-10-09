//
//  CountDownView.h
//  countdown
//
//  Created by KWAME on 15/8/10.
//  Copyright (c) 2015年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CountDownView : UIView

- (id)initWithFrame:(CGRect)frame shutDownTime:(NSString *)dateString;

- (void)removeTimer;

@end
