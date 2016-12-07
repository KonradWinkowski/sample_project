//
//  WorkingSpinner.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "WorkingSpinner.h"

@implementation WorkingSpinner

{
    CAShapeLayer *outsideLine;
    CAShapeLayer *insdieLine;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        if (self)
        {
            self.outsideLineWidth = 5;
            self.insideLineWidth = 2;
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self internalInit];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)internalInit
{    
    self.backgroundColor = [UIColor clearColor];
    
    outsideLine = [CAShapeLayer layer];
    insdieLine = [CAShapeLayer layer];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat inset = 0;

    outsideLine.rasterizationScale = scale;
    insdieLine.rasterizationScale = scale;
    
    outsideLine.shouldRasterize = YES;
    insdieLine.shouldRasterize = YES;
    
    outsideLine.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - inset, self.bounds.size.height - inset);
    insdieLine.bounds = CGRectMake(self.bounds.origin.x + (self.outsideLineWidth * 2.0), self.bounds.origin.y + (self.outsideLineWidth * 2.0), self.bounds.size.width - (self.outsideLineWidth * 2.0) - inset, self.bounds.size.height - (self.outsideLineWidth * 2.0) - inset);
    
    outsideLine.position = CGPointMake(self.layer.frame.size.width / 2, self.layer.frame.size.height / 2);
    insdieLine.position = outsideLine.position;
    
    UIBezierPath *outsidePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - inset, self.bounds.size.height - inset)];
    UIBezierPath *insidePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.origin.x + (self.outsideLineWidth * 2.0), self.bounds.origin.y + (self.outsideLineWidth * 2.0), self.bounds.size.width - (self.outsideLineWidth * 2.0) - inset, self.bounds.size.height - (self.outsideLineWidth * 2.0) - inset)];
    
    outsideLine.path = outsidePath.CGPath;
    insdieLine.path = insidePath.CGPath;

    outsideLine.fillColor = [UIColor clearColor].CGColor;
    insdieLine.fillColor = [UIColor clearColor].CGColor;
    
    outsideLine.strokeColor = [UIColor colorWithRed:.565 green:.455 blue:.357 alpha:1.0].CGColor;
    insdieLine.strokeColor = [UIColor colorWithRed:.984 green:.78 blue:0.0 alpha:1.0].CGColor;
    
    outsideLine.lineWidth = self.outsideLineWidth;
    insdieLine.lineWidth = self.insideLineWidth;
    
    outsideLine.strokeEnd = 0.65;
    outsideLine.strokeStart = 0.1;
    
    insdieLine.strokeEnd = 0.8;
    insdieLine.strokeStart = 0.35;
    
    outsideLine.lineCap = kCALineCapRound;
    insdieLine.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:outsideLine];
    [self.layer addSublayer:insdieLine];
    
    outsideLine.hidden = YES;
    insdieLine.hidden = YES;
    
    [self startAnimating];
    
}

- (BOOL) isFlipped
{
    return YES;
}

-(void)setHidden:(BOOL)hidden
{
    outsideLine.hidden = hidden;
    insdieLine.hidden = hidden;
    
    if (hidden)
    {
        self.alpha = 0.0;
        [self stopAnimating];
    }
    else
    {
        self.alpha = 1.0;
        [self startAnimating];
    }
}

-(void)stopAnimating
{
    [outsideLine removeAllAnimations];
    [insdieLine removeAllAnimations];
}

-(void)startAnimating
{
    [outsideLine addAnimation:[self outsideAnimation] forKey:@"outseideanimation"];
    [insdieLine addAnimation:[self insideAnimation] forKey:@"insideanimation"];
}

-(CABasicAnimation*)outsideAnimation
{
    CABasicAnimation *rotate =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.toValue = @(M_PI*2);
    rotate.duration = 1.5; // your duration
    rotate.repeatCount = HUGE_VALF;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return rotate;
}

-(CABasicAnimation*)insideAnimation
{
    CABasicAnimation *rotate =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.toValue = @(-M_PI*2);
    rotate.duration = 1.1; // your duration
    rotate.repeatCount = HUGE_VALF;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return rotate;
}

-(void)setOutsideLineColor:(UIColor *)outsideLineColor
{
    _outsideLineColor = outsideLineColor;
    
    outsideLine.strokeColor = _outsideLineColor.CGColor;
}

-(void)setInsideLineColor:(UIColor *)insideLineColor
{
    _insideLineColor = insideLineColor;
    
    insdieLine.strokeColor = _insideLineColor.CGColor;
}


@end
