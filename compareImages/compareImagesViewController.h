//
//  compareImagesViewController.h
//  compareImages
//
//  Created by Jorge Maroto García on 25/09/11.
//  Copyright 2011 http://www.tactilapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface compareImagesViewController : UIViewController{
    UIImageView *captcha;
    UIImageView *chr1, *chr2, *chr3, *chr4, *chr5, *chr6;
    UISlider *sliderX, *sliderWidth;
    UILabel *labelX, *labelWidth;
}
    @property (nonatomic, retain) IBOutlet UIImageView *captcha;
    @property (nonatomic, retain) IBOutlet UIImageView *chr1;
    @property (nonatomic, retain) IBOutlet UIImageView *chr2;
    @property (nonatomic, retain) IBOutlet UIImageView *chr3;
    @property (nonatomic, retain) IBOutlet UIImageView *chr4;
    @property (nonatomic, retain) IBOutlet UIImageView *chr5;
    @property (nonatomic, retain) IBOutlet UIImageView *chr6;
    
    @property (nonatomic, retain) IBOutlet UISlider *sliderX;
    @property (nonatomic, retain) IBOutlet UISlider *sliderWidth;

    @property (nonatomic, retain) IBOutlet UILabel *labelX;
    @property (nonatomic, retain) IBOutlet UILabel *labelWidth;

-(UIImage *)cropImage:(UIImage *)image fromX:(float) x width:(float) width;
-(IBAction)sliderChange:(id)sender;
-(void)updateValueSliders;
@end
