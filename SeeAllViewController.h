//
//  SeeAllViewController.h
//  Yumi
//
//  Created by tech sam on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeAllView.h"

@interface SeeAllViewController : UIViewController {
	IBOutlet UINavigationItem* m_navItem;

	UIScrollView*	m_scrollView;
	SeeAllView *	m_contentView;
}
@end
