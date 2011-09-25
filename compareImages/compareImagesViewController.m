//
//  compareImagesViewController.m
//  compareImages
//
//  Created by Jorge Maroto García on 25/09/11.
//  Copyright 2011 http://www.tactilapp.com. All rights reserved.
//

#import "compareImagesViewController.h"

@implementation compareImagesViewController
@synthesize captcha;
@synthesize chr1, chr2, chr3, chr4, chr5, chr6;
@synthesize sliderX, sliderWidth;
@synthesize labelX, labelWidth;

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self updateValueSliders];
    [captcha setImage:[UIImage imageNamed:@"captcha.jpg"]];
}

-(UIImage *)cropImage:(UIImage *)image fromX:(float) x width:(float) width{
    CGRect cropRect = CGRectMake(x, 0, width, image.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image  CGImage], cropRect);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
}

-(IBAction)sliderChange:(id)sender{
    [self updateValueSliders];
    UIImage *image = [self cropImage:captcha.image fromX:sliderX.value width:sliderWidth.value];
    [chr1 setImage:image];
    [chr1 setFrame:CGRectMake(chr1.frame.origin.x, chr1.frame.origin.y, image.size.width*2, image.size.height*2)];
    [image release];
}

-(void)updateValueSliders{
    labelX.text = [NSString stringWithFormat:@"%d", (int)sliderX.value];
    labelWidth.text = [NSString stringWithFormat:@"%d", (int)sliderWidth.value];
}

@end
