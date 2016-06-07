//
//  CircularGestureRecognizer.m
//

#include <math.h>
#import <UIKit/UIKit.h>

#import "OneFingerRotationGestureRecognizer.h"

@implementation OneFingerRotationGestureRecognizer
{
    
   // CGPoint prevPoint;
}
// private helper functions
CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2);
CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB);

- (id) initWithMidPoint: (CGPoint) _midPoint
            innerRadius: (CGFloat) _innerRadius
            outerRadius: (CGFloat) _outerRadius
                 target: (id <OneFingerRotationGestureRecognizerDelegate>) _target
{
    if ((self = [super initWithTarget: _target action: nil]))
    {
        midPoint    = _midPoint;
        innerRadius = _innerRadius;
        outerRadius = _outerRadius;
        target      = _target;
    }
    return self;
}

/** Calculates the distance between point1 and point 2. */
CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB)
{
    CGFloat a = endLineA.x - beginLineA.x;
    CGFloat b = endLineA.y - beginLineA.y;
    CGFloat c = endLineB.x - beginLineB.x;
    CGFloat d = endLineB.y - beginLineB.y;

    CGFloat atanA = atan2(a, b);
    CGFloat atanB = atan2(c, d);

    // convert radiants to degrees
    return (atanA - atanB) * 180 / M_PI;
}

#pragma mark - UIGestureRecognizer implementation

- (void)reset
{
    [super reset];
    cumulatedAngle = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    NSLog(@"suman 11111");
    
    if ([touches count] != 1)
    {
        self.state = UIGestureRecognizerStateFailed;

        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
   // NSLog(@"suman 111112222222222   %@", self.view);

    if (self.state == UIGestureRecognizerStateFailed) return;

    CGPoint nowPoint  = [[touches anyObject] locationInView: [self.view superview]];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:[self.view superview]];
    

    // make sure the new point is within the area
    CGFloat distance = distanceBetweenPoints(midPoint, nowPoint);
    
    
   // NSLog(@"dist  %f   innerRadius   %f", distance, innerRadius);
    
    if (   innerRadius <= distance
        && distance    <= outerRadius)
    {
        // calculate rotation angle between two points
        CGFloat angle = angleBetweenLinesInDegrees(midPoint, prevPoint, midPoint, nowPoint);

        // fix value, if the 12 o'clock position is between prevPoint and nowPoint
        if (angle > 180)
        {
            angle -= 360;
        }
        else if (angle < -180)
        {
            angle += 360;
        }

        // sum up single steps
        cumulatedAngle += angle;

        // call delegate
        if ([target respondsToSelector: @selector(rotation:)])
        {
            [target rotation:angle];
        }
    }
    else
    {
       // NSLog(@"suman failed");
        // finger moved outside the area
        self.state = UIGestureRecognizerStateFailed;
    }
    
    //prevPoint = [[touches anyObject] locationInView: self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesEnded:touches withEvent:event];

    if (self.state == UIGestureRecognizerStatePossible)
    {
        self.state = UIGestureRecognizerStateRecognized;

        if ([target respondsToSelector: @selector(finalAngle:)])
        {
            [target finalAngle:cumulatedAngle];
        }
    }
    else
    {
        self.state = UIGestureRecognizerStateFailed;
    }

    cumulatedAngle = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];

    self.state = UIGestureRecognizerStateFailed;
    cumulatedAngle = 0;
}

@end