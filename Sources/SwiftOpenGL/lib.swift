#if os(Linux) || os(OSX)
    import COpenGLOSX
#endif

#if os(iOS)
    import OpenGLES
#endif
//https://www.khronos.org/opengl/wiki/Generic_Vertex_Attribute_-_examples
public protocol Gettable {
    
    associatedtype GLType
    associatedtype SwiftType
    
    static var buffer: [GLType] { get }
    static var get: (GLenum, UnsafeMutablePointer<GLType>) -> () { get }
    
    static func convert(_ value: GLType) -> SwiftType
}

extension GLfloat: Gettable {
    
    public typealias GLType = GLfloat
    public typealias SwiftType = Float
    
    public static var buffer: [GLfloat] {
        return [GLfloat](repeating: 0, count: 4)
    }
    
    public static var get: (GLenum, UnsafeMutablePointer<GLfloat>) -> () {
        return glGetFloatv
    }
    
    public static func convert(_ value: GLfloat) -> Float {
        return value
    }
}

#if !os(iOS)
    extension GLdouble: Gettable {
        
        public typealias GLType = GLdouble
        public typealias SwiftType = Double
        
        public static var buffer: [GLdouble] {
            return [GLdouble](repeating: 0, count: 4)
        }
        
        public static var get: (GLenum, UnsafeMutablePointer<GLdouble>) -> () {
            return glGetDoublev
        }
        
        public static func convert(_ value: GLdouble) -> Double {
            return value
        }
    }
#endif

extension GLboolean: Gettable {
    
    public typealias GLType = GLboolean
    public typealias SwiftType = Bool
    
    public static var buffer: [GLboolean] {
        return [GLboolean](repeating: 0, count: 4)
    }
    
    public static var get: (GLenum, UnsafeMutablePointer<GLboolean>) -> () {
        return glGetBooleanv
    }
    
    public static func convert(_ value: GLboolean) -> Bool {
        return value != 0
    }
}
//Int, GLint

//typealias ProgramID = GLuint


public enum gl {
    
    //glGetError() // https://www.khronos.org/opengl/wiki/GLAPI/glGetError
    
    public enum ShaderType {
        case vertex
        case fragment
        case geometry
    }
    
    public func shader(type: ShaderType) -> String {
        return ""
    }
    
    public struct Color {
        public var red: Double
        public var green: Double
        public var blue: Double
        public var alpha: Double
        
        internal var buffer: [GLfloat] {
            return [
                GLfloat(self.red),
                GLfloat(self.green),
                GLfloat(self.blue),
                GLfloat(self.alpha)
            ]
        }
        
        public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
            self.red = Double(red)
            self.green = Double(green)
            self.blue = Double(blue)
            self.alpha = Double(alpha)
        }
        
        public init(red: Int, green: Int, blue: Int, alpha: Int = 1) {
            self.red = Double(red)
            self.green = Double(green)
            self.blue = Double(blue)
            self.alpha = Double(alpha)
        }
        
        public init?(buffer: [Double]) {
            guard buffer.count > 2 else { return nil }
            
            self.red = buffer[0]
            self.green = buffer[1]
            self.blue = buffer[2]
            
            if buffer.count > 3 {
                self.alpha = buffer[3]
            } else {
                self.alpha = 1
            }
        }
        
        public init?(buffer: [Float]) {
            guard buffer.count > 2 else { return nil }
            
            self.red = Double(buffer[0])
            self.green = Double(buffer[1])
            self.blue = Double(buffer[2])
            
            if buffer.count > 3 {
                self.alpha = Double(buffer[3])
            } else {
                self.alpha = 1
            }
        }
        
        public init?(buffer: [Int]) {
            guard buffer.count > 2 else { return nil }
            
            self.red = Double(buffer[0])
            self.green = Double(buffer[1])
            self.blue = Double(buffer[2])
            
            if buffer.count > 3 {
                self.alpha = Double(buffer[3])
            } else {
                self.alpha = 1
            }
        }
    }
    
    public struct Vertex {
        public var x: Double
        public var y: Double
        public var z: Double
        public var w: Double
        
        public init(x: Double, y: Double, z: Double = 0, w: Double = 1) {
            self.x = x
            self.y = y
            self.z = z
            self.w = w
        }
        
        public init(x: Float, y: Float, z: Float = 0, w: Float = 1) {
            self.x = Double(x)
            self.y = Double(y)
            self.z = Double(z)
            self.w = Double(w)
        }
        
        public init(x: Int, y: Int, z: Int = 0, w: Int = 1) {
            self.x = Double(x)
            self.y = Double(y)
            self.z = Double(z)
            self.w = Double(w)
        }
        
        internal var buffer: [GLfloat] {
            return [
                GLfloat(self.x),
                GLfloat(self.y),
                GLfloat(self.z),
                GLfloat(self.w)
            ]
        }
        
        public init?(buffer: [Double]) {
            guard buffer.count > 1 else { return nil }
            
            self.x = buffer[0]
            self.y = buffer[1]
            
            guard buffer.count > 2 else {
                self.z = 0
                self.w = 1
                return
            }
            
            self.z = buffer[2]
            
            if buffer.count > 3 {
                self.w = buffer[3]
            } else {
                self.w = 1
            }
        }
        
        public init?(buffer: [Float]) {
            guard buffer.count > 1 else { return nil }
            
            self.x = Double(buffer[0])
            self.y = Double(buffer[1])
            
            guard buffer.count > 2 else {
                self.z = 0
                self.w = 1
                return
            }
            
            self.z = Double(buffer[2])
            
            if buffer.count > 3 {
                self.w = Double(buffer[3])
            } else {
                self.w = 1
            }
        }
        
        public init?(buffer: [Int]) {
            guard buffer.count > 1 else { return nil }
            
            self.x = Double(buffer[0])
            self.y = Double(buffer[1])
            
            guard buffer.count > 2 else {
                self.z = 0
                self.w = 1
                return
            }
            
            self.z = Double(buffer[2])
            
            if buffer.count > 3 {
                self.w = Double(buffer[3])
            } else {
                self.w = 1
            }
        }
    }
    
    public struct BufferBitMask: OptionSet {
        
        public let rawValue: Int32
        
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        
        public static let color = BufferBitMask(rawValue: GL_COLOR_BUFFER_BIT)
        public static let stencil = BufferBitMask(rawValue: GL_STENCIL_BUFFER_BIT)
        public static let depth = BufferBitMask(rawValue: GL_DEPTH_BUFFER_BIT)
    }
    
    public static func viewport(x: Int, y: Int, width: Int, height: Int) {
        
        glViewport(GLint(x), GLint(y), GLsizei(width), GLsizei(height))
    }
    
    public static func clear(color: Color) {
        glClearColor(GLclampf(color.red), GLclampf(color.green), GLclampf(color.blue), GLclampf(color.alpha))
    }
    
    public static func clear(_ mask: BufferBitMask) {
        let mask = GLbitfield(mask.rawValue)
        glClear(mask)
    }
    
    public static func flush() {
        glFlush()
    }
    
    public static func color(_ color: gl.Color) {
        #if os(iOS)
            if let context = DrawingContext.current {
                context.add(color: color)
            }
        #endif
        
        glColor4f(GLfloat(color.red), GLfloat(color.green), GLfloat(color.blue), GLfloat(color.alpha))
    }
    
    public static func vertex(_ vertex: gl.Vertex) {
        #if os(iOS)
            if let context = DrawingContext.current {
                context.add(vertex: vertex)
            }
        #else
            glVertex4f(GLfloat(vertex.x), GLfloat(vertex.y), GLfloat(vertex.z), GLfloat(vertex.w))
        #endif
    }
    
    
//    https://www.opengl.org/sdk/docs/man/html/glGet.xhtml
    public static func get<T: Gettable, Result>(_ type: T.Type,
                           key: GLenum,
                           closure: ([T.SwiftType]) throws -> Result) rethrows -> Result {
        var result = T.buffer
        T.get(key, &result)
        return try closure(result.map { T.convert($0) })
    }
    
    //https://www.opengl.org/sdk/docs/man/html/glGetString.xhtml
    public static func string(for key: GLenum) -> String {
        guard let cString = glGetString(key) else { return "" }
        return String(cString: cString)
    }
    
    public static func createShader(for key: GLenum) -> GLuint {
        return glCreateShader(key)
    }
    
    public static func shaderSource(id: GLuint, sources: [String]) {

        var array = [UnsafePointer<GLchar>?]()
        
        for shader in sources {
            shader.withCString { string in
                array.append(string)
            }
        }
        
        glShaderSource(id, GLsizei(array.count), array, nil)
    }
    
    public static func compileShader(id: GLuint) {
        glCompileShader(id)
    }
    
    //https://www.khronos.org/opengles/sdk/docs/man/xhtml/glGetShaderiv.xml
    //
    public static func shaderInfo(id: GLuint, for key: GLenum) -> GLint {
        var value: GLint = 0
        glGetShaderiv(id, key, &value)
        return value
    }
    
    public static func shaderInfoLog(id: GLuint, length: GLint) -> String? {
        var log: [Int8] = []
        glGetShaderInfoLog(id, length, nil, &log)
        return String.init(validatingUTF8: log)
    }
    
    public static func createProgram() -> GLuint {
        return glCreateProgram()
    }
    
    public static func deleteShader(id: GLuint) {
        glDeleteShader(id)
    }
    
    public static func attach(shader shaderID: GLuint, to programID: GLuint) {
        glAttachShader(programID, shaderID)
    }
    
    public static func linkProgram(id: GLuint) {
        glLinkProgram(id)
    }
    
    public static func programInfo(id: GLuint, for key: GLenum) -> GLint {
        var value: GLint = 0
        glGetProgramiv(id, key, &value)
        return value
    }
    
    public static func programInfoLog(id: GLuint, length: GLint) -> String? {
        var log: [Int8] = []
        glGetProgramInfoLog(id, length, nil, &log)
        return String.init(validatingUTF8: log)
    }
    
    public enum MatrixMode {
        
        case modelView
        case projection
        case texture
        case color
        
        internal var raw: GLenum {
            switch self {
            case .modelView:
                return GLenum(GL_MODELVIEW)
            case .projection:
                return GLenum(GL_PROJECTION)
            case .texture:
                return GLenum(GL_TEXTURE)
            case .color:
                return GLenum(GL_COLOR)
            }
        }
    }
    
    public static func matrixMode(_ mode: MatrixMode) {
        glMatrixMode(mode.raw)
    }
    
    public static func loadIdentity() {
        glLoadIdentity()
    }
    
    public static func ortho(left: Double, right: Double, bottom: Double, top: Double, near: Double, far: Double) {
        #if os(iOS)
            glOrthof(Float(left), Float(right), Float(bottom), Float(top), Float(near), Float(far))
        #else
            glOrtho(left, right, bottom, top, near, far)
        #endif
    }
    
    public static func frustum(left: Double, right: Double, bottom: Double, top: Double, near: Double, far: Double) {
        #if os(iOS)
            glFrustumf(Float(left), Float(right), Float(bottom), Float(top), Float(near), Float(far))
        #else
            glFrustum(left, right, bottom, top, near, far)
        #endif
    }
    
    public static func perspective(angle: Double, aspect: Double, near: Double, far: Double) {
        let height = tan( angle / 360 * M_PI ) * near;
        let width = height * aspect;
        
        #if os(iOS)
            glFrustumf(Float(-width), Float(width), Float(-height), Float(height), Float(near), Float(far))
        #else
            glFrustum(-width, width, -height, height, near, far)
        #endif
    }
    
    public enum DrawMode {
        
        case triangles
        case quads
        
        internal var raw: GLenum {
                switch self {
                case .triangles:
                    return GLenum(GL_TRIANGLES)
                case .quads:
                    #if os(iOS)
                        return GLenum(GL_TRIANGLE_FAN)
                    #else
                        return GLenum(GL_QUADS)
                    #endif
                }
        }
    }
    
//    public static func Drawer {
    
        //func vertex
        //func color
        //func index
        
//    }
    
    //newList
    //Certain commands are not compiled into the display list but are executed immediately, regardless of the display-list mode. These commands are glAreTexturesResident, glColorPointer, glDeleteLists, glDeleteTextures, glDisableClientState, glEdgeFlagPointer, glEnableClientState, glFeedbackBuffer, glFinish, glFlush, glGenLists, glGenTextures, glIndexPointer, glInterleavedArrays, glIsEnabled, glIsList, glIsTexture, glNormalPointer, glPopClientAttrib, glPixelStore, glPushClientAttrib, glReadPixels, glRenderMode, glSelectBuffer, glTexCoordPointer, glVertexPointer, and all of the glGet commands.
//    
//    #if os(iOS)
//    internal class DrawingContext {
//        
//        static var current: DrawingContext?
//        
//        private var mode: DrawMode
//        private var colors = [Color]()
//        private var vertexes = [Vertex]()
//        
//        internal init(mode: DrawMode) {
//            self.mode = mode
//        }
//        
//        internal func add(color: gl.Color) {
//            if self.vertexes.count > 0,
//                let colorBuffer = [GLfloat]?.some(gl.get(GLfloat.self, key: GLenum(GL_CURRENT_COLOR)) { $0 }),
//                let color = gl.Color(buffer: colorBuffer) {
//                for _ in 0..<self.vertexes.count {
//                    self.colors.append(color)
//                }
//            }
//            
//            self.colors.append(color)
//        }
//        
//        internal func add(vertex: gl.Vertex) {
//            self.vertexes.append(vertex)
//            
//            if self.colors.count != 0,
//                self.colors.count < self.vertexes.count,
//                let lastColor = self.colors.last {
//                    self.colors.append(lastColor)
//            }
//        }
//        
//        internal func finish() {
//            guard self.vertexes.count > 0 else { return }
//            glEnableClientState(GLenum(GL_VERTEX_ARRAY))
//            
//            if self.colors.count > 0 {
//                glEnableClientState(GLenum(GL_COLOR_ARRAY))
//            }
//            
//            let vertexBuffer = self.vertexes.flatMap { $0.buffer }
//            glVertexPointer(4, GLenum(GL_FLOAT), 0, vertexBuffer);
//            
//            if self.colors.count > 0 {
//                let colorBuffer = self.colors.flatMap { $0.buffer }
//                glColorPointer(4, GLenum(GL_FLOAT), 0, colorBuffer);
//            }
//            
//            glDrawArrays(self.mode.raw, 0, GLsizei(self.vertexes.count));
//            
//            if self.colors.count > 0 {
//                glDisableClientState(GLenum(GL_COLOR_ARRAY))
//            }
//            
//            glDisableClientState(GLenum(GL_VERTEX_ARRAY))
//        }
//    }
//    #endif
    
    //drawArray client state
    //draw?
//    public static func draw(_ mode: DrawMode, action: (Void) -> Void) { //throws
//        //draw.color
//        //draw.index
//        //draw.vertex ??
//        //
//        //The commands are glVertex, glColor, glSecondaryColor, glIndex, glNormal, glFogCoord, glTexCoord, glMultiTexCoord, glVertexAttrib, glEvalCoord, glEvalPoint, glArrayElement, glMaterial, and glEdgeFlag.
//        #if os(iOS)
//            DrawingContext.current = DrawingContext(mode: mode)
//            action()
//            DrawingContext.current?.finish()
//            DrawingContext.current = nil
//        #else
//            glBegin(mode.raw)
//            action()
//            glEnd()
//        #endif
//        //else 
//        //stack
//        //https://pandorawiki.org/Porting_to_GLES_from_GL
//        
//    }
    
    #if !os(iOS)
    public static func begin(_ mode: DrawMode) {
        glBegin(mode.raw)
    }
    
    public static func end() {
        glEnd()
    }
    #endif
}


//https://www.opengl.org/sdk/docs/man/
//print("Hello, world!")
/*
 glDepthMask(GLboolean(GL_FALSE))
 glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
 glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLint(GL_MIRRORED_REPEAT))
 
 struct Texture {
 
 func parameters(for target: gl.Target) -> Parameter {
 return Parameter(target: target)
 }
 
 func bind(_ texture: Int, to: gl.Target) {
 
 }
 
 func generate(count: Int) -> [Int] {
 return []
 }
 }
 
 extension Texture {
 
 struct Parameter {
 
 private var target: gl.Target
 
 enum Name {
 
 case minFilter
 case magFilter
 }
 
 enum Value {
 case nearest
 case linear
 }
 
 init(target: gl.Target) {
 self.target = target
 }
 
 func set(_ value: Value, for name: Name) {
 
 }
 
 func set(_ value: [Value], for name: Name) {
 
 }
 
 func set(_ value: [Double], for name: Name) {
 
 }
 
 func set(_ value: Double, for name: Name) {
 
 }
 
 func get(_ name: Name) -> [Value] {
 return []
 }
 
 func get(_ name: Name) -> [Double] {
 return []
 }
 }
 }
 
 struct gl {
 
 enum Target {
 
 case texture1D
 case texture2D
 case texture3D
 case textureCubeMap
 //        GL_COLOR_TABLE, GL_POST_CONVOLUTION_COLOR_TABLE, GL_POST_COLOR_MATRIX_COLOR_TABLE, GL_PROXY_COLOR_TABLE, GL_PROXY_POST_CONVOLUTION_COLOR_TABLE, or GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE.
 }
 
 
 
 static var texture: Texture {
 return Texture()
 }
 
 static func begin(closure: (() -> Void)? = nil) {
 
 }
 
 static func end() {
 
 }
 
 
 
 static func error() throws {
 
 }
 
 }
 
 
 gl.texture.parameters(for: .texture1D).set(.nearest, for: .magFilter)
 
 let value: [Texture.Parameter.Value] = gl.texture.parameters(for: .texture1D).get(.magFilter)
 
 gl.begin()
 gl.end()
 
 gl.begin {
 gl.clear(mask: [.color, .buffer])
 gl.color()
 }*/
