module ImageResource;

private import derelict.sdl.sdl;
private import derelict.sdl.image;
private import Image;
private import Graphics;
private import Misc;
private import Log;
private import Vector;

interface ImageResource
{
    void load();
    void unload();
    void draw(int x, int y);
    int width();
    int height();
    SDL_Surface* surface();
    char[] fileName();
}

class NormalImageResource : ImageResource
{
public:
    this(char[] fileName)
    {
        _fileName = fileName;
    }
    
    
    void load()
    {
        if(!_loaded) {
            Log.log("ImageResource: Loading image '%s'\n", _fileName);
            SDL_Surface* tmpSurface = IMG_Load(_fileName);
            if(!tmpSurface) {
                throw new CouldNotLoadImageException(_fileName);
            }
            SDL_SetAlpha(tmpSurface, SDL_RLEACCEL, 255);
            _surface = SDL_DisplayFormatAlpha(tmpSurface);
            SDL_FreeSurface(tmpSurface);
            assert(_surface);
    
            _loaded = true;
        }
    }
    
    
    void unload()
    {
        if(_loaded) {
            Log.log("ImageResource: Unloading image '%s'\n", _fileName);
            SDL_FreeSurface(_surface);
            _surface = null;
            _loaded = false;
        }
    }
    
    
    void draw(int x, int y)
    {
        //Log.log("ImageResource.draw()\n");
        SDL_Rect dstrct;
        dstrct.x = x;
        dstrct.y = y;
        SDL_BlitSurface(_surface, null, Graphics.inst().screen(), &dstrct);
        //Log.log("/ImageResource.draw\n");
    }
    
    
    int width() {
        return _surface.w;
    }
    
    
    int height() {
        return _surface.h;
    }
    
    
    SDL_Surface* surface() {
        return _surface;
    }
    
    
    char[] fileName() {
        return _fileName;
    }
    
protected:
    char[] _fileName;
    bit _loaded = false;
    SDL_Surface* _surface = null;
}


class MirroredImageResource : ImageResource
{
    this(char[] fileName)
    {
        _fileName = fileName;
    }


    void load()
    {
        if(!_loaded) {
            Log.log("ImageResource: Loading mirrored image '%s'\n", _fileName);
            ImageResource resource = loadImage(_fileName).resource();
            resource.load();
            SDL_Surface* tmpSurface = resource.surface();
            _surface = hmirror(tmpSurface);
            SDL_SetAlpha(_surface, SDL_RLEACCEL | SDL_SRCALPHA, 255);
            assert(_surface);
    
            _loaded = true;
        }
    }
    
    void unload()
    {
        if(_loaded) {
            Log.log("ImageResource: Unloading mirrored image '%s'\n", _fileName);
            SDL_FreeSurface(_surface);
            _surface = null;
            _loaded = false;
        }
    }
    
    
    void draw(int x, int y)
    {
        //Log.log("ImageResource.draw()\n");
        SDL_Rect dstrct;
        dstrct.x = x;
        dstrct.y = y;
        SDL_BlitSurface(_surface, null, Graphics.inst().screen(), &dstrct);
        //Log.log("/ImageResource.draw\n");
    }
    
    
    int width() {
        return _surface.w;
    }
    
    
    int height() {
        return _surface.h;
    }
    
    
    SDL_Surface* surface() {
        return _surface;
    }
    
    char[] fileName() {
        return _fileName;
    }
    
    static SDL_Surface* hmirror(SDL_Surface* sfc)
    {
        SDL_Surface* result = SDL_CreateRGBSurface(sfc.flags, sfc.w, sfc.h,
            sfc.format.BytesPerPixel * 8, sfc.format.Rmask, sfc.format.Gmask,
            sfc.format.Bmask, sfc.format.Amask); 
        ubyte* pixels = cast(ubyte*) sfc.pixels;
        ubyte* rpixels = cast(ubyte*) result.pixels;
        uint pitch = sfc.pitch;
        uint pxlength = pitch*sfc.h;
        uint bypp = sfc.format.BytesPerPixel;
        assert(result != null);
        
        for(uint col = 0; col < pitch; col += bypp) {
            for(uint line = 0; line < sfc.h; ++line) {
                uint rpos = line * pitch + col;
                uint pos = line * pitch + (pitch - col - bypp);
                rpixels[rpos..rpos+bypp] = pixels[pos..pos+bypp];
            }
        }
        
        return result;
    }

private:
    char[] _fileName;
    SDL_Surface* _surface = null;
    bit _loaded = false;
}


class CouldNotLoadImageException : Exception
{
    char[] fileName;
    
    this(char[] ifileName)
    {
        fileName = ifileName;
        super(swritef("Could not load image '%s'", fileName));
    }
}


private NormalImageResource[char[]] _normalResources;
private MirroredImageResource[char[]] _mirroredResources;

Image loadImage(char[] fileName)
{
    if(!_normalResources[fileName])
    {
        _normalResources[fileName] = new NormalImageResource(fileName);
    }
    _normalResources[fileName].load();
    return new Image(_normalResources[fileName]);
}


Image loadMirroredImage(char[] fileName)
{
    if(!_mirroredResources[fileName])
    {
        _mirroredResources[fileName] = new MirroredImageResource(fileName);
    }
    _mirroredResources[fileName].load();
    return new Image(_mirroredResources[fileName]);
}
