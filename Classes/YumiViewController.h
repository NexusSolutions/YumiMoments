//
//  YumiViewController.h
//  Yumi
//
//  Created by tech sam on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobclixAdView.h"

@class ImageScrollView;
@class SeeAllViewController;
#define MAX_IMG	73

@interface YumiViewController : UIViewController <UIScrollViewDelegate>{
	
	UIScrollView *pagingScrollView;
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
	
	IBOutlet UIBarButtonItem* m_btnPrev;
	IBOutlet UIBarButtonItem* m_btnPlay;
	IBOutlet UIBarButtonItem* m_btnNext;
	//IBOutlet UIBarButtonItem* m_btnInfo;
	IBOutlet UINavigationItem* m_navItem;
	IBOutlet UIToolbar*			m_toolbar;
	IBOutlet UINavigationBar* m_navBar;

	int m_nCurImg;
	BOOL m_bPlay;
	
	NSTimer* m_playTimer;
	
	SeeAllViewController* m_pAllViewController;
	
	BOOL m_bToolbarShow;
	
	MobclixAdView *adView;

}
@property (nonatomic,retain) MobclixAdView *adView;

@property (nonatomic, retain) SeeAllViewController* m_pAllViewController;

- (IBAction)savePhoto:(id)sender;
- (IBAction)prevPhoto:(id)sender;
- (IBAction)nextPhoto:(id)sender;
- (IBAction)playAndPause:(id)sender;
//- (IBAction)info:(id)sender;

- (void) setImage:(int) n;

- (void)configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (ImageScrollView *)dequeueRecycledPage;

- (NSUInteger)imageCount;
//- (NSString *)imageNameAtIndex:(NSUInteger)index;
//- (CGSize)imageSizeAtIndex:(NSUInteger)index;
- (UIImage *)imageAtIndex:(NSUInteger)index;

-(void) selectedImage:(int) index;

@end

