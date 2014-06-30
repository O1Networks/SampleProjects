//
//  O1ViewController.m
//  O1ClientViewer
//
//  Created by Ji Fang on 6/29/14.
//
//

#import "O1ViewController.h"
#import "O1ClientView.h"
#import "O1Datasource.h"

@interface O1ViewController () <O1DatasourceDelegate>

@property (nonatomic, weak) IBOutlet O1ClientView * clientView;
@property (nonatomic, weak) IBOutlet UILabel	  *	frequencyLabel;
@property (nonatomic, weak) IBOutlet UISlider	  *	slider;

@property (nonatomic, strong) O1Datasource * datasource;

@end

@implementation O1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
	self.datasource = [[O1Datasource alloc] initWithFrequency:24];
	self.datasource.delegate = self;
	self.clientView.context = self.datasource.bitmapContext;
}

- (IBAction)onSliderChanged:(id)sender
{
	self.frequencyLabel.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
	self.datasource.frequency = (int)self.slider.value;
}

- (void)sessionBitmapContextWillChange:(O1Datasource *)session
{
	
}

- (void)sessionBitmapContextDidChange:(O1Datasource *)session
{
	[self.clientView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
