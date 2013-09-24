//
//  APTextView.m
//  Anyplan
//
//  Created by Ken Tsutsumi on 2013/09/24.
//  Copyright (c) 2013年 Ken Tsutsumi. All rights reserved.
//

#import "APTextView.h"

@implementation APTextView

//下記を参照
//https://devforums.apple.com/message/889840#889840


//行末にカーソルが合わない問題、を解決
- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    point.y -= self.textContainerInset.top;
    point.x -= self.textContainerInset.left;
    
    NSUInteger glyphIndex = [self.layoutManager glyphIndexForPoint:point inTextContainer:self.textContainer];
    NSUInteger characterIndex = [self.layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    UITextPosition *pos = [self positionFromPosition:self.beginningOfDocument offset:characterIndex];
    
    return pos;
}

//最後の行がキーボードに隠れる問題、を解決
- (void)scrollRangeToVisible:(NSRange)range
{
    [super scrollRangeToVisible:range];
    
    if (self.layoutManager.extraLineFragmentTextContainer != nil && self.selectedRange.location == range.location)
    {
        CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.start];
        [self scrollRectToVisible:caretRect animated:YES];
    }
}

@end
