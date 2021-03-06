//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MMViewController.h"

@class MMCenteringClipView, MMNoBlurImageView, MMPreviewViewPageInfo, NSScrollView;

@interface MMPreviewViewController : MMViewController
{
    MMPreviewViewPageInfo *_pageInfo;
    NSScrollView *_scrollView;
    MMNoBlurImageView *_imageView;
    MMCenteringClipView *_clipView;
}

@property(retain, nonatomic) MMCenteringClipView *clipView; // @synthesize clipView=_clipView;
@property(retain, nonatomic) MMNoBlurImageView *imageView; // @synthesize imageView=_imageView;
@property(retain, nonatomic) NSScrollView *scrollView; // @synthesize scrollView=_scrollView;
@property(retain, nonatomic) MMPreviewViewPageInfo *pageInfo; // @synthesize pageInfo=_pageInfo;
//- (void).cxx_destruct;
- (void)standardSize;
- (void)zoomOut;
- (void)zoomIn;
- (void)setupWithPageInfo:(id)arg1;
- (void)setupImageScaleMod;
- (void)resetMagnificationWhileSwipe;
- (void)viewDidDisappear;
- (void)viewDidLoad;

@end

