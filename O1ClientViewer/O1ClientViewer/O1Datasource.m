//
//  O1Datasource.m
//  O1ClientViewer
//
//  Created by Ji Fang on 6/29/14.
//
//

#import "O1Datasource.h"

#define IMAGE_WIDTH		1024.0f
#define IMAGE_HEIGHT	768.0f

@interface O1Datasource ()

@property (nonatomic, strong) NSMutableArray	* datasource;
@property (nonatomic, strong) NSTimer			* timer;
@property (nonatomic, strong) dispatch_queue_t	  workQueue;
@property (nonatomic, assign) NSInteger			  currentIndex;

@end

@implementation O1Datasource

- (id)initWithFrequency:(NSInteger)frequency
{
	if (frequency < 1)
		frequency = 1;
	
	if ((self = [super init]) != nil)
	{
		self.currentIndex = 1013;
		self.datasource = [NSMutableArray array];
		self.workQueue = dispatch_queue_create("BitmapContextGenerator",
											   DISPATCH_QUEUE_SERIAL);
		self.frequency = frequency;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGBitmapInfo info = kCGImageAlphaFirst | kCGImageAlphaPremultipliedLast;

		self.bitmapContext = CGBitmapContextCreate(NULL,
												   IMAGE_WIDTH,
												   IMAGE_HEIGHT,
												   8,
												   IMAGE_WIDTH * sizeof(uint32_t),
												   colorSpace,
												   info);
		
		CGColorSpaceRelease(colorSpace);
	}
	
	return self;
}

- (void)dealloc
{
	[self.timer invalidate];
	
	if (self.bitmapContext)
	{
		CGContextRelease(self.bitmapContext);
		self.bitmapContext = NULL;
	}
}

- (void)setFrequency:(NSInteger)frequency
{
	if (frequency < 1)
		frequency = 1;
	
	if (frequency == self.frequency)
		return;
	
	NSTimeInterval inteval = 1.0f / frequency;
	[self.timer invalidate];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:inteval
												  target:self
												selector:@selector(onTimerFired:)
												userInfo:nil
												 repeats:YES];
	
	_frequency = frequency;
}

- (void)onTimerFired:(NSTimer *)timer
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.delegate sessionBitmapContextWillChange:self];
	});


	dispatch_async(self.workQueue, ^{
		[self generateBitmapContext];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate sessionBitmapContextDidChange:self];
		});
	});
}

- (void)generateBitmapContext
{
	if (self.currentIndex > 1090)
		self.currentIndex = 1013;
	NSString * imagename = [NSString stringWithFormat:@"IMG_%d.jpg", self.currentIndex];
	UIImage * image = [UIImage imageNamed:imagename];
	++self.currentIndex;
	
	CGRect drawRect = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
	CGContextDrawImage(self.bitmapContext, drawRect, image.CGImage);
}


@end
