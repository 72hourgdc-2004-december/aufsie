module Scene;

private import derelict.sdl.sdl;
private import Vector;
private import Game;

class Scene
{
    this(Game game)
    {
        _game = game;
    }
    
    
    Game game()
    {
        return _game;
    }
    
    
    bit won() {
	return true;
    } 
    
    abstract void advance(double frametime);
    
    abstract void draw();
    
    void keyDown(SDL_KeyboardEvent event) {}
    void keyUp(SDL_KeyboardEvent event) {}
    void mouseMotion(Vector2d mousePosition, Vector2d mouseRel) {}
    void lmbDown(Vector2d mousePosition) {}
    void lmbUp(Vector2d mousePosition) {}
    void rmbDown(Vector2d mousePosition) {}
    void rmbUp(Vector2d mousePosition) {}
    
    abstract void finish();
    abstract bit finished();
    
private:
    Game _game;
    
}
