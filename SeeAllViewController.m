//
//  SeeAllViewController.m
//  Yumi
//
//  Created by tech sam on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SeeAllViewController.h"


@implementation SeeAllViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(UIImage*) imageFromNumber:(int) n{
	NSString* strBundle = [[NSBundle mainBundle] bundlePath];
	NSString* str = [NSString stringWithFormat:@"/s%d.jpg",  n];
	NSString* strPath = [strBundle stringByAppendingString:str];
	UIImage* img = [UIImage imageWithContentsOfFile:strPath];
	return img;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	m_navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered 
																   target:self action:@selector(onDone:)];
	m_navItem.title = @"Yumi Moments";
	
	m_scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.view addSubview:m_scrollView];
	[self.view sendSubviewToBack:m_scrollView];

	m_contentView = [[SeeAllView alloc] init];
	[m_scrollView addSubview:m_contentView];
	m_scrollView.contentSize = m_contentView.frame.size;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
												 name:UIDeviceOrientationDidChangeNotification object:nil];
	[self orientationChanged:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    // We must add a delay here, otherwise we'll swap in the new view
	// too quickly and we'll get an animation glitch
    //[self performSelector:@selector(layoutSubviews) withObject:nil afterDelay:0];
	UIInterfaceOrientation ori = [UIApplication sharedApplication].statusBarOrientation; 
	if (ori == UIInterfaceOrientationPortrait || ori == UIInterfaceOrientationPortraitUpsideDown){ 
		m_scrollView.frame = CGRectMake(0, 0, 320, 480);
		CGFloat h = ((73 / 4) + 1) * (CELL_H + 4) + 24;
		m_contentView.frame = CGRectMake(0, 0, 320, h);
	}else {
		m_scrollView.frame = CGRectMake(0, 0, 480, 320);
		CGFloat h = ((73 / 6) + 1) * (CELL_H + 4);
		m_contentView.frame = CGRectMake(0, 0, 480, h);
	}
	m_scrollView.contentSize = m_contentView.frame.size;

	[m_contentView setNeedsDisplay];
}

- (void) onDone:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[m_contentView release];
	[m_scrollView release];
	
    [super dealloc];
}


@end
