//
//  EAGLViewController.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2021/11/18.
//  Copyright © 2021 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif
    void WBMPPerformBlockOnWBoxGameThread(void (^block)(void));
    void WBMPPerformBlockOnWBoxGameThreadSync(void (^block)(void));
#ifdef __cplusplus
}
#endif

@interface OpenGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
}
@end

@interface EAGLViewController : UIViewController

@end


NS_ASSUME_NONNULL_END
