//
//  ViewController.h
//  TestOpenGL
//
//  Created by apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@interface MyGLViewController : GLKViewController{
    int m_nWidth;
    int m_nHeight;
    
    Byte* m_pYUVData;
    NSCondition *m_YUVDataLock;
    
    GLuint _testTxture[3];
    
    BOOL m_bNeedSleep;
}

- (void) WriteYUVFrame: (Byte*) pYUV Len: (int) length width: (int)width height: (int) height;

@end
