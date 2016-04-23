module Graphics;

private import derelict.sdl.sdl;
private import Misc;
private import Vector;

private SDL_Surface* _screen = null;


class GraphicsSystem
{
public:
    this(bit fullscreen, bit hwcursor)
    {
        _fullscreen = fullscreen;
        _hwcursor = hwcursor;
        Uint32 flags = SDL_DOUBLEBUF;
        if(_fullscreen) {
            flags |= SDL_FULLSCREEN;
        }
        _screen = SDL_SetVideoMode(640, 480, 32, flags);
        
        if(!_hwcursor) {
            SDL_ShowCursor(SDL_DISABLE);
        }

        if(!_screen) {
            throw new CouldNotSetVideoModeException;
        }
    }
    
    
    SDL_Surface* screen()
    {
        return _screen;
    }
    
    
    void updateScreen()
    {
        SDL_Flip(_screen);
    }
    
    
    void paintRect(Rect rect, int r, int g, int b)
    {
        SDL_Rect sdlrect;
        sdlrect.x = cast(short) rect.left();
        sdlrect.y = cast(short) rect.top();
        sdlrect.w = cast(short) rect.diagonale().x();
        sdlrect.h = cast(short) rect.diagonale().y();
        Uint32 color = SDL_MapRGB(_screen.format, r, g, b);
        SDL_FillRect(_screen, &sdlrect, color);
    }


    void paintRectAlpha(Rect rect, int r, int g, int b, int a)
    {
        SDL_Rect sdlrect;
        sdlrect.x = cast(short) rect.left();
        sdlrect.y = cast(short) rect.top();
        sdlrect.w = cast(short) rect.diagonale().x();
        sdlrect.h = cast(short) rect.diagonale().y();
        Uint32 color = SDL_MapRGBA(_screen.format, r, g, b, a);
        SDL_FillRect(_screen, &sdlrect, color);
    }
    
    
    bit hwcursor() {
        return _hwcursor;
    }
    
    
    bit fullscreen() {
        return _fullscreen;
    }


private:
    SDL_Surface* _screen;
    
    bit _fullscreen;
    bit _hwcursor;
}


private GraphicsSystem myInstance = null;



/+ Start graphics +/
void start(bit fullscreen, bit hwcursor)
{
    if(myInstance) {
        delete myInstance;
    }
    
    myInstance = new GraphicsSystem(fullscreen, hwcursor);
}


/+ Stop graphics +/
void stop()
{
    assert(myInstance);
    delete myInstance;
}


/+ Return the current GraphicsSystem instance +/
GraphicsSystem inst()
{
    assert(myInstance);
    return myInstance;
}


class CouldNotSetVideoModeException : Exception
{
    this()
    {

        char[] msg = swritef("Could not set video mode");
        super(msg);
    }
}
