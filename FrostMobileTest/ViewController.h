//
//  ViewController.h
//  FrostMobileTest
//
//  Created by Mikaela Koller on 2016-04-29.
//  Copyright © 2016 Mikaela Koller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)removeWebview:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *removeWebview;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
