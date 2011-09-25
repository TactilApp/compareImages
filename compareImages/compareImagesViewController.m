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
@synthesize block1, block2, block3;

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

-(IBAction)save{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (block1.text != @""){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                      [NSString stringWithFormat:@"%@.png", block1.text]];
        NSData *data = UIImagePNGRepresentation(chr1.image);
        [data writeToFile:path atomically:YES];
    } 
    if (block2.text != @""){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithFormat:@"%@.png", block2.text]];
        NSData *data = UIImagePNGRepresentation(chr2.image);
        [data writeToFile:path atomically:YES];
    } 
    if (block3.text != @""){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithFormat:@"%@.png", block3.text]];
        NSData *data = UIImagePNGRepresentation(chr3.image);
        [data writeToFile:path atomically:YES];
    } 
}

-(IBAction)compare{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    for (int i = 0; i<22800; i++){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithString: @"test.png"] ];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:path];

        if ([self compareImage:image withImage:chr1.image]){
//            NSLog(@"Es igual");
        }else{
//            NSLog(@"NO ES IGUAL");
        }
        [image release];
    }
    
}

-(BOOL)compareImage:(UIImage *)image1 withImage:(UIImage *)image2{
    int errores = 0;
    CGImageRef cgimage1 = image1.CGImage;
    CGImageRef cgimage2 = image2.CGImage;
    
    // Info para la primera imagen
    size_t width1  = CGImageGetWidth(cgimage1);
    size_t height1 = CGImageGetHeight(cgimage1);
    
    size_t bpr1 = CGImageGetBytesPerRow(cgimage1);
    size_t bpp1 = CGImageGetBitsPerPixel(cgimage1);
    size_t bpc1 = CGImageGetBitsPerComponent(cgimage1);
    size_t bytes_per_pixel1 = bpp1 / bpc1;
    
    CGDataProviderRef provider1 = CGImageGetDataProvider(cgimage1);
    NSData* data1 = (id)CGDataProviderCopyData(provider1);
    [data1 autorelease];
    const uint8_t* bytes1 = [data1 bytes];
    
    
    // Info para la segunda imagen
    size_t width2 = CGImageGetWidth(cgimage2);
    size_t height2 = CGImageGetHeight(cgimage2);

    if (width1 != width2 || height1 != height2)
        return FALSE;
    
    size_t bpr2 = CGImageGetBytesPerRow(cgimage2);
    size_t bpp2 = CGImageGetBitsPerPixel(cgimage2);
    size_t bpc2 = CGImageGetBitsPerComponent(cgimage2);
    size_t bytes_per_pixel2 = bpp2 / bpc2;
    
    
    CGDataProviderRef provider2 = CGImageGetDataProvider(cgimage2);
    NSData* data2 = (id)CGDataProviderCopyData(provider2);
    [data2 autorelease];
    const uint8_t* bytes2 = [data2 bytes];

    //Recorrer toda la imagen comparando
    for(size_t row = 0; row < height1; row++){
        for(size_t col = 0; col < width1; col++){
            const uint8_t* pixel1 = &bytes1[row * bpr1 + col * bytes_per_pixel1];
            const uint8_t* pixel2 = &bytes2[row * bpr2 + col * bytes_per_pixel2];
            
            for(size_t x = 0; x < bytes_per_pixel1; x++){
                if (pixel1[x] != pixel2[x])
                    errores++;
            }
        }
    }
    return TRUE;
}
#define CHR1_X  6
#define CHR2_X  50
#define CHR3_X  85
#define CHR4_X  65
#define CHR5_X  4
#define CHR6_X  4

#define CHR1_WIDTH  35
#define CHR2_WIDTH  35
#define CHR3_WIDTH  35
#define CHR4_WIDTH  15
#define CHR5_WIDTH  15
#define CHR6_WIDTH  15
-(IBAction)splitImages{
    [chr1 setImage:[self cropImage:captcha.image fromX:CHR1_X width:CHR1_WIDTH]];
    [chr2 setImage:[self cropImage:captcha.image fromX:CHR2_X width:CHR2_WIDTH]];
    [chr3 setImage:[self cropImage:captcha.image fromX:CHR3_X width:CHR3_WIDTH]];
    [chr4 setImage:[self cropImage:captcha.image fromX:CHR4_X width:CHR4_WIDTH]];
    [chr5 setImage:[self cropImage:captcha.image fromX:CHR5_X width:CHR5_WIDTH]];
    [chr6 setImage:[self cropImage:captcha.image fromX:CHR6_X width:CHR6_WIDTH]];
    
    for (int i=1; i<=6; i++){
        UIImageView *imageViewAux = [self valueForKey:[NSString stringWithFormat:@"chr%d", i ]];
        [imageViewAux setFrame:CGRectMake(imageViewAux.frame.origin.x, imageViewAux.frame.origin.y, imageViewAux.image.size.width*2, imageViewAux.image.size.height*2)];
    }
}

#define CAPTCHA_URL @"http://www.cmt.es/cmt_ptl_ext/Captcha.jpg"

-(IBAction)cargarImagen{
    block1.text = @"";
    block2.text = @"";
    block3.text = @"";
    
    NSURL *url = [NSURL URLWithString:CAPTCHA_URL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    [captcha setImage:[UIImage imageWithData:[request responseData]]];
    [request release];
    
    [self splitImages];
}

@end
