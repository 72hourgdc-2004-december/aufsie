private import derelict.sdl.sdl;
private import derelict.sdl.image;
private import derelict.sdl.mixer;
private import Log;
private import Graphics;
private import Game;
private import Music;
private import std.stdio;

int main(char[][] args)
{
    try {
        bit hwcursor = false;
        bit fullscreen = true;
        foreach(char[] arg; args[1..length]) {
            if(arg == "+hwcursor") {
                hwcursor = true;
            }
            else if(arg == "-hwcursor") {
                hwcursor = false;
            }
            else if(arg == "+fullscreen") {
                fullscreen = true;
            }
            else if(arg == "-fullscreen") {
                fullscreen = false;
            }
            else {
                writefln("Warning: Unrecognized command line option '%s'", arg);
            }
        }
        
        
        Log.log("Loading dynamic libraries: SDL");
        DerelictSDL_Load();
        Log.log(", SDL_Image");
        DerelictSDLImage_Load();
        Log.log(", SDL_Mixer");
        DerelictSDLMixer_Load();
        Log.log(" - success\n");
        
        SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_AUDIO);
        
        Graphics.start(fullscreen, hwcursor);
        
        Music.start();
        
        Music.startPreload();
        Music.preloadSound("voice/bictori.ogg");
        Music.preloadSound("voice/ma.ogg");
        Music.preloadSound("voice/mau.ogg");
        Music.preloadSound("voice/shot.ogg");
        Music.preloadSound("voice/wee.ogg");
        SDL_Delay(2000);
        Music.endPreload();
        
        
        
        Game game = new Game;
        game.run();
    }
    finally {
        SDL_Quit();
    }
    
    return 0;
}
