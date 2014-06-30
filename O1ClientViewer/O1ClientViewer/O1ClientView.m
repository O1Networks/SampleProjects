//
//  O1ClientView.m
//  O1ClientViewer
//
//  Created by Fish on 6/29/14.
//
//

#import "O1ClientView.h"
#import "O1Datasource.h"

@implementation O1ClientView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	if (self.datasource.bitmapContext)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGImageRef cgImage = CGBitmapContextCreateImage(self.datasource.bitmapContext);
		
        CGContextTranslateCTM(context, 0, [self bounds].size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToRect(context,
							CGRectMake(rect.origin.x,
									   [self bounds].size.height - rect.origin.y - rect.size.height,
									   rect.size.width,
									   rect.size.height));
        CGContextDrawImage(context,
						   CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height),
						   cgImage);
		
        CGImageRelease(cgImage);
	}
	else
	{
        // just clear the screen with black
        [[UIColor blackColor] set];
        UIRectFill([self bounds]);
    }
}

@end
