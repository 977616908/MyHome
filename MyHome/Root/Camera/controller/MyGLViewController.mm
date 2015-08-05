//
//  ViewController.m
//  TestOpenGL
//
//  Created by apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyGLViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};


@interface MyGLViewController () {
    GLuint _program;

}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation MyGLViewController

@synthesize context = _context;

- (void)dealloc
{
    //[_context release];
    //self.context = nil;
    [self tearDownGL];
//    [super dealloc];
}

- (void)WriteYUVFrame:(Byte *)pYUV Len:(int)length width:(int)width height:(int)height
{
    //NSLog(@"WriteYUVFrame... Len: %d, width: %d, height: %d", length, width, height);
    [m_YUVDataLock lock];
    //SAFE_DELETE(m_pYUVData);
    if (m_pYUVData != NULL) {
        delete m_pYUVData;
        m_pYUVData = NULL;
    }
    m_pYUVData = new Byte[length];
    if (m_pYUVData == NULL) {
        [m_YUVDataLock unlock];
        return;
    }
    
    memcpy(m_pYUVData, pYUV, length);
    
    m_nWidth = width;
    m_nHeight = height;
    
    m_bNeedSleep = NO;
    
    
    [m_YUVDataLock unlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setUserInteractionEnabled:NO];
    m_bNeedSleep = YES;
    
    m_nHeight = 0;
    m_nWidth = 0;
    m_pYUVData = NULL;
    m_YUVDataLock = [[NSCondition alloc] init];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormatNone;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGB565;
    
   // [self setupGL];
    
    [EAGLContext setCurrentContext:self.context];
    
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    //NSLog(@"vertShaderPathname: %@", vertShaderPathname);
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
    //if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:@"ShaderTest.vsh"]) {
        NSLog(@"Failed to compile vertex shader");
        return ;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    //NSLog(@"fragShaderPathname: %@", fragShaderPathname);
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return ;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return ;
    }

    glEnable(GL_TEXTURE_2D);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    glGenTextures(3, _testTxture);
  
    glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _testTxture[0]);
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 640, 480, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, y);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  

	glActiveTexture(GL_TEXTURE1);
	glBindTexture(GL_TEXTURE_2D, _testTxture[1]);
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 320, 240, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, u);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glActiveTexture(GL_TEXTURE2);
	glBindTexture(GL_TEXTURE_2D, _testTxture[2]);
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 320, 240, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, v);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
   	
    GLuint i;
	
	glActiveTexture(GL_TEXTURE1);
	i=glGetUniformLocation(_program,"Utex");//	glUniform1i(i,1);  /* Bind Utex to texture unit 1 */
    //NSLog(@"i: %d", i);
    // glBindTexture(GL_TEXTURE_2D, _textureU);
    glUniform1i(i,1); 
	
	/* Select texture unit 2 as the active unit and bind the V texture. */
	glActiveTexture(GL_TEXTURE2);
	i=glGetUniformLocation(_program,"Vtex");
    //NSLog(@"i: %d", i);
    //glBindTexture(GL_TEXTURE_2D, _textureV);
	glUniform1i(i,2);  /* Bind Vtext to texture unit 2 */
	
	
	/* Select texture unit 0 as the active unit and bind the Y texture. */
	glActiveTexture(GL_TEXTURE0);
	i=glGetUniformLocation(_program,"Ytex");
    //NSLog(@"i: %d", i);
    //glBindTexture(GL_TEXTURE_2D, _textureY);
	glUniform1i(i,0);  /* Bind Ytex to texture unit 0 */
     
     [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];

}

- (void)tearDownGL
{
    //[EAGLContext setCurrentContext:self.context];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
    
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{

}

- (BOOL)drawYUV
{
    [m_YUVDataLock lock];
    
    if (m_bNeedSleep) {
        usleep(10000);
    }
    
    m_bNeedSleep = YES;
    
    if (m_pYUVData == NULL) {
        [m_YUVDataLock unlock];
        return NO;
    }
    
    //NSLog(@"drawYUV... m_nHeight: %d, m_nWidth: %d", m_nHeight, m_nWidth);
    
    Byte *y = m_pYUVData;
    Byte *u = m_pYUVData + m_nHeight * m_nWidth;
    Byte *v = m_pYUVData + m_nHeight * m_nWidth * 5 / 4;
    
    glActiveTexture(GL_TEXTURE0);
	//glTexSubImage2D (GL_TEXTURE_2D, 0, 0, 0, m_nWidth, m_nHeight, GL_LUMINANCE, GL_UNSIGNED_BYTE, y);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, m_nWidth, m_nHeight, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, y);
	
	glActiveTexture(GL_TEXTURE1);
	//glTexSubImage2D (GL_TEXTURE_2D, 0, 0, 0, m_nWidth / 2, m_nHeight / 2, GL_LUMINANCE, GL_UNSIGNED_BYTE, u);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, m_nWidth / 2, m_nHeight / 2, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, u);
	
	glActiveTexture(GL_TEXTURE2);
	//glTexSubImage2D (GL_TEXTURE_2D, 0, 0, 0, m_nWidth / 2, m_nHeight / 2, GL_LUMINANCE, GL_UNSIGNED_BYTE, v);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, m_nWidth / 2, m_nHeight / 2, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, v);
    
    
    [m_YUVDataLock unlock];
    
    return YES;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    
    //NSLog(@"draw....");
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if ([self drawYUV] == NO) {
        return;
    }
    
    GLfloat varray[] = {
        -1.0f,  1.0f, 0.0f,
        -1.0f, -1.0f, 0.0f,             
        1.0f, -1.0f, 0.0f,             
        1.0f,  1.0f, 0.0f,
        -1.0f,  1.0f, 0.0f
    };
    
    GLfloat triangleTexCoords[] = {            
        // X, Y, Z            
        0.0f, 0.0f,             
        0.0f, 1.0f,             
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f        
	}; 
    
    
    glEnable(GL_DEPTH_TEST);
    
    
    GLuint i;
    i = glGetAttribLocation(_program, "vPosition");
    glVertexAttribPointer(i, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), varray);
    
    glEnableVertexAttribArray(i);
    
    i = glGetAttribLocation(_program, "myTexCoord");
	//__android_log_print(ANDROID_LOG_INFO,"TAG","myTexCoord i: %d", i);
	glVertexAttribPointer(i, 2, GL_FLOAT, GL_FALSE, 
                          2 * sizeof(float),
                          triangleTexCoords);   
    
	glEnableVertexAttribArray(i);
 
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 5);

}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
