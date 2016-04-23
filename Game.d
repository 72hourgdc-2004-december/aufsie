module Game;

private import Scene;
private import derelict.sdl.sdl;
private import IntroScene;
private import MainMenu;
private import Vector;
private import Graphics;
private import ImageResource;
private import SofuResource;
private import Image;

class Game
{
public:
    this() {
        pushScene(new MainMenu(this));
        pushScene(new IntroScene(this));
        _mouseCursor = loadImage("images/cursor.png");
        _mousePosition = new Vector2d;
    }
    
    
    
    
    void run()
    {
        Uint32 frametime=0, time1=0, time2=SDL_GetTicks();
        while(currentScene()) {
            
            Scene scene = currentScene();

            SDL_Event event;
            while(SDL_PollEvent(&event)) {
                switch(event.type) {
                    case SDL_MOUSEMOTION: {
                        Vector2d mousePosition = 
                            new Vector2d(event.motion.x, event.motion.y);
                        _mousePosition = mousePosition;
                        Vector2d mouseRel =
                            new Vector2d(event.motion.xrel, event.motion.yrel);
                        
                        scene.mouseMotion(mousePosition, mouseRel);
                        break;
                    }
                    case SDL_MOUSEBUTTONDOWN: {
                        Vector2d mousePosition = 
                            new Vector2d(event.motion.x, event.motion.y);
                        switch(event.button.button) {
                            case SDL_BUTTON_LEFT:
                                scene.lmbDown(mousePosition);
                                break;
 			    case SDL_BUTTON_RIGHT:
                                scene.rmbDown(mousePosition);
                                break;
                            default:
                                break;
                        }
                        break;
                    }
                    case SDL_MOUSEBUTTONUP: {
                        Vector2d mousePosition = 
                            new Vector2d(event.motion.x, event.motion.y);
                        
                        switch(event.button.button) {
                            case SDL_BUTTON_LEFT:
                                scene.lmbUp(mousePosition);
                                break;
			    case SDL_BUTTON_RIGHT:
                                scene.rmbUp(mousePosition);
                                break;
                            default:
                                break;
                        }
                        break;
                    }
                    case SDL_KEYDOWN: {
                        scene.keyDown(event.key);
                        break;
                    }
                    case SDL_KEYUP: {
                        scene.keyUp(event.key);
                        break;
                    }
                    case SDL_QUIT: {
                        scene.finish();
                        break;
                    }
                    default: {
                        break;
                    }
                }
            }
            
            time1 = time2;
            time2 = SDL_GetTicks();
            frametime = time2 - time1;
            
            scene.advance(cast(double) frametime);
            

            SDL_Rect screenrect;
            screenrect.x = 0; screenrect.y = 0;
            screenrect.w = 640; screenrect.h = 480;
            SDL_FillRect(Graphics.inst().screen(), &screenrect,
                SDL_MapRGB(Graphics.inst().screen().format, 0, 0, 0));

            scene.draw();
            
            if(!Graphics.inst().hwcursor()) {
                _mouseCursor.draw(_mousePosition - new Vector2d(16, 16));
            }
            
                
            Graphics.inst().updateScreen();

            if(currentScene().finished()) {
                _popScene();
            }
        }
    }
    
    
    Scene currentScene() {
        if(_scenes.length) {
            return _scenes[length-1];
        }
        else {
            return null;
        }
    }
    
    void pushScene(Scene scene) {
        _scenes ~= scene;
    }

    
private:
    
    
    void _popScene() {
        _scenes.length = _scenes.length - 1;
    }


    Scene[] _scenes;
    
    Image _mouseCursor;
    Vector2d _mousePosition;

}
