//
//  CountDownView.h
//  countdown
//
//  Created by KWAME on 15/8/10.
//  Copyright (c) 2015年 autohome. All rights reserved.
//

#import "CountDownView.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

static const CGFloat SCROLL_WIDTH = 176;
static const CGFloat IMG_WIDTH = 36;
static const CGFloat LABEL_WIDTH = IMG_WIDTH/2;
static const CGFloat ALL_HEIGHT = 20;
static const CGFloat FONT_SIZE = 12;

@interface CountDownView ()
{
    NSString *sec2;
    NSString *sec1;
    NSString *min2;
    NSString *min1;
    NSString *hour2;
    NSString *hour1;
    NSString *day2;
    NSString *day1;
    NSString *todate;
    NSTimer *timer;
    BOOL timeStart;
}
//个位数label
@property (nonatomic, strong) UILabel *secondLabel1;
//十位数label
@property (nonatomic, strong) UILabel *secondLabel2;

@property (nonatomic, strong) UILabel *minuteLabel1;
@property (nonatomic, strong) UILabel *minuteLabel2;

@property (nonatomic, strong) UILabel *hourLabel1;
@property (nonatomic, strong) UILabel *hourLabel2;

@property (nonatomic, strong) UILabel *dayLabel1;
@property (nonatomic, strong) UILabel *dayLabel2;

@property (nonatomic, strong) UILabel *surplusDay;
@property (nonatomic, strong) UILabel *symbol1;
@property (nonatomic, strong) UILabel *symbol2;


@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIView *backView;

@end
@implementation CountDownView


- (id)initWithFrame:(CGRect)frame shutDownTime:(NSString *)dateString {
    
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
         todate = dateString;
        [self setInitTimes];
        [self initKitViews];
    }
    return self;
}

- (void)setInitTimes {
    [self addSubview:self.backView];
    timeStart = YES;
    [self setBackgroundColor:[UIColor clearColor]];
   
    NSDate *date = [NSDate date];
    //设置的时间小于当天时间
    if ([self timeIntervalFromDate:nil stringDate:todate] <=
        [self timeIntervalFromDate:date stringDate:nil])
    {
        NSLog(@"倒计时结束");
    }
    else
    {
        [self timerFireMethod:nil];
        //每一秒执行一次
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timerFireMethod:)
                                               userInfo:nil
                                                repeats:YES];
        //设置计时器的优先级，否则放在tableView中，计时器将会停止。
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)initKitViews {
    [self initImgBackView];
    [self.backView addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.secondLabel1];
    [self.backScrollView addSubview:self.secondLabel2];
    [self.backScrollView addSubview:self.minuteLabel1];
    [self.backScrollView addSubview:self.minuteLabel2];
    [self.backScrollView addSubview:self.hourLabel1];
    [self.backScrollView addSubview:self.hourLabel2];
    [self.backScrollView addSubview:self.dayLabel1];
    [self.backScrollView addSubview:self.dayLabel2];
    [self.backScrollView addSubview:self.surplusDay];
    [self.backScrollView addSubview:self.symbol1];
    [self.backScrollView addSubview:self.symbol2];
}

//计时器
- (void)timerFireMethod:(NSTimer *)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *endTime = [[NSDateComponents alloc] init];
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [dateFormatter dateFromString:todate];
    NSString *overdate = [dateFormatter stringFromDate:dateString];
    static int year;
    static int month;
    static int day;
    static int hour;
    static int minute;
    static int second;
    if(timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[overdate substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[overdate substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[overdate substringWithRange:NSMakeRange(8, 2)] intValue];
        hour = [[overdate substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[overdate substringWithRange:NSMakeRange(14, 2)] intValue];
        second = [[overdate substringWithRange:NSMakeRange(17, 2)] intValue];
        timeStart= NO;
    }
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setHour:hour];
    [endTime setMinute:minute];
    [endTime setSecond:second];
    
    NSDate *overTime = [cal dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差，是为了统一成北京时间
    unsigned int unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSDateComponents *dateComponets = [cal components:unitFlags fromDate:today toDate:overTime options:0];
    
    if([dateComponets second] <= 0 &&
       [dateComponets hour] <= 0 &&
       [dateComponets minute] <= 0 &&
       [dateComponets day] <= 0) {
        [self setTimeLabelText];
        [self setAnimationSecond:@"00"];
        //计时器失效
        [theTimer invalidate];
        //计时结束 do_something
        
    } else{
        //计时尚未结束，do_something.
        [self changeScrollViewAnimationWithDateComponets:dateComponets];
    }
}

- (void) setTimeLabelText {
    [self.secondLabel1 setText:@"0"];
    [self.secondLabel2 setText:@"0"];
    [self.minuteLabel1 setText:@"0"];
    [self.minuteLabel2 setText:@"0"];
    [self.hourLabel1 setText:@"0"];
    [self.hourLabel2 setText:@"0"];
    [self.dayLabel1 setText:@"0"];
    [self.dayLabel2 setText:@"0"];
    
}
- (void) removeTimer {
    [timer invalidate];
    //    NSLog(@"计时器终结");
}
- (void) initImgBackView {
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *backImgView = [[UIImageView alloc]init];
        [backImgView setImage:[UIImage imageNamed:@"home_time_day"]];
        if (i == 0)
        {
            backImgView.frame = CGRectMake(0, 0, IMG_WIDTH, ALL_HEIGHT);
        }
        else if (i == 1)
        {
            backImgView.frame = CGRectMake(IMG_WIDTH+12, 0, IMG_WIDTH, ALL_HEIGHT);
        }
        else if (i == 2)
        {
            backImgView.frame = CGRectMake((IMG_WIDTH*2)+22, 0, IMG_WIDTH, ALL_HEIGHT);
        }
        else if (i == 3)
        {
            backImgView.frame = CGRectMake((IMG_WIDTH*3)+32, 0, IMG_WIDTH, ALL_HEIGHT);
        }
        
        [self.backView addSubview:backImgView];
    }
    
}
#pragma mark - 设置动画效果
- (void) changeScrollViewAnimationWithDateComponets:(NSDateComponents *)dateComponets {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [dateFormatter dateFromString:todate];
    NSString *s_day = [NSString stringWithFormat:@"%02zd", [self intervalSinceNow:dateString]];
    NSString *s_hour = [NSString stringWithFormat:@"%02zd", [dateComponets hour]];
    NSString *s_minute = [NSString stringWithFormat:@"%02zd", [dateComponets minute]];
    NSString *s_second = [NSString stringWithFormat:@"%02zd", [dateComponets second]];
    //设置秒数和动画
    [self setAnimationSecond:s_second];
    //设置分钟和动画
    [self setAnimationMinute:s_minute];
    //设置小时和动画
    [self setAnimationHour:s_hour];
    //设置天数和动画
    [self setAnimationDay:s_day];
}

- (void) setAnimationSecond:(NSString *)s_second {
    sec2 = [s_second substringToIndex:1];
    sec1 = [self firstStrForString:s_second];
    
    [self.secondLabel1 setText:sec1];
    [self startAnimationWithLayer:self.secondLabel1.layer];
    [self.secondLabel2 setText:sec2];
    if ([sec1 integerValue] == 9) {
        [self startAnimationWithLayer:self.secondLabel2.layer];
    }
}

- (void) setAnimationMinute:(NSString *)s_minute {
    min2 = [s_minute substringToIndex:1];
    min1 = [self firstStrForString:s_minute];
    [self.minuteLabel1 setText:min1];
    //满足秒数为59时才执行一次
    if ([sec2 integerValue] == 5 &&
        [sec1 integerValue] == 9) {
        [self startAnimationWithLayer:self.minuteLabel1.layer];
    }
    [self.minuteLabel2 setText:min2];
    //满足秒数为59 分钟个位数为9时才执行
    if ([min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.minuteLabel2.layer];
    }
}
- (void) setAnimationHour:(NSString *)s_hour {
    hour2 = [s_hour substringToIndex:1];
    hour1 = [self firstStrForString:s_hour];
    [self.hourLabel1 setText:hour1];
    if ([min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.hourLabel1.layer];
    }
    [self.hourLabel2 setText:hour2];
    if ([hour1 integerValue] == 9 &&
        [min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
    }
}
- (void) setAnimationDay:(NSString *)s_day {
    
    day2 = [s_day substringToIndex:1];
    day1 = [self firstStrForString:s_day];
    [self.dayLabel1 setText:day1];
    if ([hour2 integerValue] == 2 &&
        [hour1 integerValue] == 9 &&
        [min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.dayLabel1.layer];
    }
    [self.dayLabel2 setText:day2];
    if ([day1 integerValue] == 9 &&
        [hour2 integerValue] == 2 &&
        [hour1 integerValue] == 9 &&
        [min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.dayLabel2.layer];
    }
}
- (NSString *) firstStrForString:(NSString *)string {
    unichar sub1 = [string characterAtIndex:1];
    NSString *sec =[NSString stringWithCharacters:&sub1 length:1];
    return sec;
}
//时间向上滑动的效果
- (void) startAnimationWithLayer:(CALayer *)layer {
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //先慢后快
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [layer addAnimation:animation forKey:@"pageCurl"];
}
- (NSInteger)intervalSinceNow: (NSDate *) theDate
{
    NSCalendar *s_calendar = [NSCalendar currentCalendar];
    NSDate *fromDate;
    NSDate *toDate;
    [s_calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[NSDate date]];
    [s_calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:theDate];
    NSDateComponents *dayComponents = [s_calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    NSInteger dayCount = dayComponents.day;
    if (dayCount > 99) {
        dayCount = 99;
    }
    return dayCount;
}

- (NSTimeInterval) timeIntervalFromDate:(NSDate *)date stringDate:(NSString *)strDate {
    NSTimeInterval fitstDate;
    if (date == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        fitstDate = [dateString timeIntervalSince1970];
    }else{
        fitstDate = [date timeIntervalSince1970];
    }
    return fitstDate;
}
#pragma mark - 时间控件初始化
//时间控件总宽度为54 高度为30
- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCROLL_WIDTH, ALL_HEIGHT)];
        _backScrollView.backgroundColor = [UIColor clearColor];
    }
    return _backScrollView;
}

- (UILabel *)secondLabel1 {
    if (_secondLabel1 == nil) {
        _secondLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_secondLabel1 setBackgroundColor:[UIColor clearColor]];
        [_secondLabel1 setTextAlignment:NSTextAlignmentCenter];
        [_secondLabel1 setTextColor:[UIColor whiteColor]];
        [_secondLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _secondLabel1;
}

- (UILabel *)secondLabel2 {
    if (_secondLabel2 == nil) {
        _secondLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-IMG_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_secondLabel2 setBackgroundColor:[UIColor clearColor]];
        [_secondLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_secondLabel2 setTextColor:[UIColor whiteColor]];
        [_secondLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _secondLabel2;
}

- (UILabel *)minuteLabel1 {
    if (_minuteLabel1 == nil) {
        _minuteLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-IMG_WIDTH-LABEL_WIDTH-10, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_minuteLabel1 setBackgroundColor:[UIColor clearColor]];
        [_minuteLabel1 setTextAlignment:NSTextAlignmentCenter];
        [_minuteLabel1 setTextColor:[UIColor whiteColor]];
        [_minuteLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _minuteLabel1;
}

- (UILabel *)minuteLabel2 {
    if (_minuteLabel2 == nil) {
        _minuteLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-IMG_WIDTH-IMG_WIDTH-10, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_minuteLabel2 setBackgroundColor:[UIColor clearColor]];
        [_minuteLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_minuteLabel2 setTextColor:[UIColor whiteColor]];
        [_minuteLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _minuteLabel2;
}
- (UILabel *)hourLabel1 {
    if (_hourLabel1 == nil) {
        _hourLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-(IMG_WIDTH*2)-20-LABEL_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_hourLabel1 setBackgroundColor:[UIColor clearColor]];
        [_hourLabel1 setTextAlignment:NSTextAlignmentCenter];
        [_hourLabel1 setTextColor:[UIColor whiteColor]];
        [_hourLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _hourLabel1;
}

- (UILabel *)hourLabel2 {
    if (_hourLabel2 == nil) {
        _hourLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-(IMG_WIDTH*3)-20, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_hourLabel2 setBackgroundColor:[UIColor clearColor]];
        [_hourLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_hourLabel2 setTextColor:[UIColor whiteColor]];
        [_hourLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _hourLabel2;
}
- (UILabel *)dayLabel1 {
    if (_dayLabel1 == nil) {
        _dayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-(IMG_WIDTH*3)-32-LABEL_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_dayLabel1 setBackgroundColor:[UIColor clearColor]];
        [_dayLabel1 setTextAlignment:NSTextAlignmentCenter];
        [_dayLabel1 setTextColor:[UIColor whiteColor]];
        [_dayLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _dayLabel1;
}

- (UILabel *)dayLabel2 {
    if (_dayLabel2 == nil) {
        _dayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-(IMG_WIDTH*4)-32, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_dayLabel2 setBackgroundColor:[UIColor clearColor]];
        [_dayLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_dayLabel2 setTextColor:[UIColor whiteColor]];
        [_dayLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _dayLabel2;
}

- (UILabel *)surplusDay {
    if (_surplusDay == nil) {
        _surplusDay = [[UILabel alloc]initWithFrame:CGRectMake(IMG_WIDTH, 5, 12, 20)];
        [_surplusDay setBackgroundColor:[UIColor clearColor]];
        [_surplusDay setTextAlignment:NSTextAlignmentCenter];
        [_surplusDay setTextColor:[UIColor blackColor]];
        [_surplusDay setFont:[UIFont systemFontOfSize:10]];
        [_surplusDay setText:@"天"];
    }
    return _surplusDay;
}
- (UILabel *)symbol1 {
    if (_symbol1 == nil) {
        _symbol1 = [[UILabel alloc]initWithFrame:CGRectMake((IMG_WIDTH*2)+12, 5, 12, 20)];
        [_symbol1 setBackgroundColor:[UIColor clearColor]];
        [_symbol1 setTextAlignment:NSTextAlignmentCenter];
        [_symbol1 setTextColor:[UIColor blackColor]];
        [_symbol1 setFont:[UIFont systemFontOfSize:10]];
        [_symbol1 setText:@":"];
    }
    return _symbol1;
}
- (UILabel *)symbol2 {
    if (_symbol2 == nil) {
        _symbol2 = [[UILabel alloc]initWithFrame:CGRectMake((IMG_WIDTH*3)+22, 5, 12, 20)];
        [_symbol2 setBackgroundColor:[UIColor clearColor]];
        [_symbol2 setTextAlignment:NSTextAlignmentCenter];
        [_symbol2 setTextColor:[UIColor blackColor]];
        [_symbol2 setFont:[UIFont systemFontOfSize:10]];
        [_symbol2 setText:@":"];
    }
    return _symbol2;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_backView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _backView;
}
#pragma mark -
@end
