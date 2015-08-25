//
//  YumiViewController.m
//  Yumi
//
//  Created by tech sam on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YumiViewController.h"
#import "SeeAllViewController.h"
#import "ImageScrollView.h"

@implementation YumiViewController

@synthesize adView;

@synthesize m_pAllViewController;

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * MAX_IMG, bounds.size.height);
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	m_navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"See All" style:UIBarButtonItemStyleBordered 
																   target:self action:@selector(onSeeAll:)];

    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.delegate = self;
    [self.view addSubview:pagingScrollView];
	[self.view sendSubviewToBack:pagingScrollView];
	
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    [self tilePages];

	m_bPlay = NO;
	m_bToolbarShow = YES;
	// add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [pagingScrollView addGestureRecognizer:singleTap];
    [singleTap release];
	
	self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 390.0f, 320.0f, 50.0f)] autorelease]; 
	[self.view addSubview:self.adView];

}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.7];
	
	if (m_bToolbarShow == YES) {
		m_toolbar.alpha = 0.0;
		m_navBar.alpha = 0.0;
		m_bToolbarShow = NO;
		adView.alpha = 0.0;
	}
	else {
		m_toolbar.alpha = 1.0;
		m_navBar.alpha = 1.0;
		adView.alpha = 1.0;
		m_bToolbarShow = YES;
	}

	//[UIView setAnimationDidStopSelector:@selector(notifyStopAnimationView)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}

- (void) onSeeAll:(id)sender{
	if(m_bPlay == YES) {
		m_bPlay = NO;
		[m_playTimer invalidate];
		m_btnPlay.image = [UIImage imageNamed:@"Play.png"];
	}
	
	if (m_pAllViewController == nil) {
		m_pAllViewController = [[SeeAllViewController alloc] initWithNibName:@"SeeAllViewController" bundle:nil];
		m_pAllViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	}
	[self presentModalViewController:m_pAllViewController animated:YES];
}

- (void) setImage:(int) n{
	m_nCurImg = n;
	
	[m_btnPrev setEnabled:YES];
	[m_btnNext setEnabled:YES];
	
	if (m_nCurImg == 0)
		[m_btnPrev setEnabled:NO];
	else if(m_nCurImg == MAX_IMG - 1)
		[m_btnNext setEnabled:NO];
	
	m_navItem.title = [NSString stringWithFormat:@"%d of %d", m_nCurImg + 1, MAX_IMG];
}
-(UIImage*) imageAtIndex:(NSUInteger) n{
	NSString* strBundle = [[NSBundle mainBundle] bundlePath];
	NSString* str = [NSString stringWithFormat:@"/%d.jpg",  n + 1];
	NSString* strPath = [strBundle stringByAppendingString:str];
	UIImage* img = [UIImage imageWithContentsOfFile:strPath];
	return img;
}
- (IBAction)savePhoto:(id)sender{
	UIImage* curImage = [self imageAtIndex:m_nCurImg];
	UIImageWriteToSavedPhotosAlbum(curImage, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
}
- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saved Photo!" message:nil 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (IBAction)prevPhoto:(id)sender{
//	m_nCurImg--;
//	if (m_nCurImg < 0) 
//		m_nCurImg = 0;
//	[self setImage:m_nCurImg]; 
	CGRect visibleBounds = pagingScrollView.bounds;
	visibleBounds.origin.x -= visibleBounds.size.width;
	pagingScrollView.bounds = visibleBounds;
	[self tilePages];
}
- (IBAction)nextPhoto:(id)sender{
//	m_nCurImg++;
//	if(m_nCurImg >= MAX_IMG)
//		m_nCurImg = MAX_IMG - 1;
//	[self setImage:m_nCurImg]; 
	
	CGRect visibleBounds = pagingScrollView.bounds;
	visibleBounds.origin.x += visibleBounds.size.width;
	pagingScrollView.bounds = visibleBounds;
	[self tilePages];
}
- (IBAction)playAndPause:(id)sender{
	if (m_bPlay == NO) {
		m_bPlay = YES;	
		m_playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
		m_btnPlay.image = [UIImage imageNamed:@"Pause.png"];
	}
	else {
		m_bPlay = NO;
		[m_playTimer invalidate];
		m_btnPlay.image = [UIImage imageNamed:@"Play.png"];
	}

}

- (void) onTimer:(NSTimer*) timer{
//	m_nCurImg++;
//	if(m_nCurImg > MAX_IMG){
//		m_nCurImg = MAX_IMG;
//		[m_playTimer invalidate];
//		m_bPlay = NO;
//	}
//	[self setImage:m_nCurImg]; 
	CGRect visibleBounds = pagingScrollView.bounds;
	
	if (visibleBounds.origin.x >= ([self imageCount] - 1) * visibleBounds.size.width) {
		[m_playTimer invalidate];
		m_bPlay = NO;
		m_btnPlay.image = [UIImage imageNamed:@"Play.png"];
		return;
	}
	visibleBounds.origin.x += visibleBounds.size.width;
	pagingScrollView.bounds = visibleBounds;
	[self tilePages];
	
}
//- (IBAction)info:(id)sender{
//	
//}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }    
	
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
		pagingScrollView.frame = CGRectMake(-10, 0, 340, 480);
	else 
		pagingScrollView.frame = CGRectMake(0, 0, 480, 320);

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // recalculate contentSize based on current orientation
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    // adjust frames and configuration of each visible page
    for (ImageScrollView *page in visiblePages) {
        CGPoint restorePoint = [page pointToCenterAfterRotation];
        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
        page.frame = [self frameForPageAtIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
        [page restoreCenterPoint:restorePoint scale:restoreScale];
        
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidAppear:(BOOL)animated { 
	[super viewDidAppear:animated]; 
	[self.adView resumeAdAutoRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.adView pauseAdAutoRefresh]; 
}

- (void)viewDidUnload {
	[self.adView cancelAd]; self.adView.delegate = nil; self.adView = nil;
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
-(void) selectedImage:(int) index{
	[m_pAllViewController dismissModalViewControllerAnimated:YES];
	
	//SeeAllView에서 rotate되였을때 타산
	{
		CGFloat offset = pagingScrollView.contentOffset.x;
		CGFloat pageWidth = pagingScrollView.bounds.size.width;
		
		if (offset >= 0) {
			firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
			percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
		} else {
			firstVisiblePageIndexBeforeRotation = 0;
			percentScrolledIntoFirstVisiblePage = offset / pageWidth;
		}    
		
		UIInterfaceOrientation ori = [UIApplication sharedApplication].statusBarOrientation; 
		if (ori == UIInterfaceOrientationPortrait || ori == UIInterfaceOrientationPortraitUpsideDown) 
			pagingScrollView.frame = CGRectMake(-10, 0, 340, 480);
		else 
			pagingScrollView.frame = CGRectMake(0, 0, 480, 320);
		
		// recalculate contentSize based on current orientation
		pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
		
		// adjust frames and configuration of each visible page
		for (ImageScrollView *page in visiblePages) {
			CGPoint restorePoint = [page pointToCenterAfterRotation];
			CGFloat restoreScale = [page scaleToRestoreAfterRotation];
			page.frame = [self frameForPageAtIndex:page.index];
			[page setMaxMinZoomScalesForCurrentBounds];
			[page restoreCenterPoint:restorePoint scale:restoreScale];
			
		}
    }
	
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
	
	CGRect visibleBounds = pagingScrollView.bounds;
	
	visibleBounds.origin.x = visibleBounds.size.width * index;
	pagingScrollView.bounds = visibleBounds;
	[self tilePages];
	
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

#pragma mark -
#pragma mark Tiling and page configuration
- (NSUInteger) imageCount{
	return MAX_IMG;
}
- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
    
    // Recycle no-longer-visible pages 
    for (ImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
				
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
			
        }
    }    
	[self setImage:(visibleBounds.origin.x / visibleBounds.size.width)];

}

- (ImageScrollView *)dequeueRecycledPage
{
    ImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    
    // To use full images instead of tiled images, replace the "displayTiledImageNamed:" call
    // above by the following line:
     [page displayImage:[self imageAtIndex:index]];
}

#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

- (void)dealloc {
	[pagingScrollView release];
	[recycledPages release];
	[visiblePages release];
	
	[m_btnPrev release];
	[m_btnNext release];
	[m_navBar release];
	[m_toolbar release];
	
	[m_pAllViewController release];
	[self.adView cancelAd]; self.adView.delegate = nil; self.adView = nil;

    [super dealloc];
}

@end
