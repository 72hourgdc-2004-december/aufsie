module OutroScene;

private import Scene;
private import Vector;
private import Game;
private import Music;
private import Image;
private import ImageResource;
private import Graphics;
private import derelict.sdl.sdl;


class OutroScene : Scene
{
    
    this(Game game)
    {
        super(game);
        
        _image = loadImage("images/complete.png");
        Music.playMusic("musik/outro.ogg", 1);
    }
    
    void advance(double frametime)
    {
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
    bit _finished = false;
}
