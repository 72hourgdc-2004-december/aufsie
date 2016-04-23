module IntroScene;

private import Scene;
private import Vector;
private import Game;
private import Music;
private import Image;
private import ImageResource;
private import Graphics;
private import derelict.sdl.sdl;


class IntroScene : Scene
{
    static const double duration = 19000;
    
    this(Game game)
    {
        super(game);
        
        _image = loadImage("images/title.png");
        Music.playMusic("musik/introsound.ogg", 1);
    }
    
    void advance(double frametime)
    {
        _time += frametime;
        if(_time >= duration) {
            finish();
        }
    }
    
    
    void draw()
    {
        _image.draw(new Vector2d);
    }
    
    
    void finish() {
        _finished = true;
        Music.stopMusic(1000);
        Music.playMusic("musik/musik1.ogg", -1);
    }
    
    
    bit finished() {
        return _finished;
    }
    
    

    
    
    void lmbDown(Vector2d mousePosition) {
        finish();
    }
    
    
    void keyDown(SDL_KeyboardEvent event) {
        finish();
    }
    
    
private:
    Image _image;
    double _time = 0;
    bit _finished = false;
}
