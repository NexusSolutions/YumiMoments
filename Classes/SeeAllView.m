//
//  SeeAllView.m
//  Yumi
//
//  Created by tech sam on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SeeAllView.h"
#import "YumiAppDelegate.h"

@implementation SeeAllView

-(id) init{
	CGFloat h = ((73 / 4) + 1) * (CELL_H + 4) + 24;

	self = [super initWithFrame:CGRectMake(0, 0, 320, h)];
    if (self) {
        // Initialization code.
		
    }
	
	return self;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(UIImage*) imageFromNumber:(int) n{
	NSString* strBundle = [[NSBundle mainBundle] bundlePath];
	NSString* str = [NSString stringWithFormat:@"/s%d.jpg",  n];
	NSString* strPath = [strBundle stringByAppendingString:str];
	UIImage* img = [UIImage imageWithContentsOfFile:strPath];
	return img;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	UIInterfaceOrientation ori = [UIApplication sharedApplication].statusBarOrientation; 
	UIImage* img;
	if (ori == UIInterfaceOrientationPortrait || ori == UIInterfaceOrientationPortraitUpsideDown) {
		for (int i = 0; i < 73; i++) {
			CGFloat x = 4 + (CELL_H + 4) * (i % 4);
			CGFloat y = 4 + (CELL_H + 4) * (i / 4);
			img = [self imageFromNumber:i+1];
			[img drawInRect:CGRectMake(x, y, CELL_H, CELL_H)];
		}
	}
	else {
		for (int i = 0; i < 73; i++) {
			CGFloat x = 4 + (CELL_H + 4) * (i % 6);
			CGFloat y = 4 + (CELL_H + 4) * (i / 6);
			img = [self imageFromNumber:i+1];
			[img drawInRect:CGRectMake(x, y, CELL_H, CELL_H)];
		}
		
	}
							  
	
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint pointInView = [[touches anyObject] locationInView:self];
	int row = pointInView.y / (CELL_H + 4);
	int col = pointInView.x / (CELL_H + 4);
	int index;
	UIInterfaceOrientation ori = [UIApplication sharedApplication].statusBarOrientation; 
	if (ori == UIInterfaceOrientationPortrait || ori == UIInterfaceOrientationPortraitUpsideDown) 
		index = row * 4 + col;
	else 
		index = row * 6 + col;
	YumiAppDelegate* del = [[UIApplication sharedApplication] delegate];
	[del.viewController selectedImage:index];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
