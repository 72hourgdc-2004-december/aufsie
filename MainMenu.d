module MainMenu;

private import Scene;

private import Vector;
private import derelict.sdl.sdl;
private import derelict.sdl.image;
private import Entity;
private import Layer;
private import ImageResource;
private import Image;
private import SofuResource;
private import Game;
private import GameScene;
private import Button;
private import EditScene;
private import Music;
private import Player;
private import Log;

class MainMenu : Scene
{
public:
    this(Game game)
    {
        super(game);
        _last=this;
        _bgLayer = new Layer(this);
       	_background=loadImage("images/mainmenu.png"); 
        _testEntity = new Button(new Rect(187, 60, 266, 116), loadImage("images/startbutton.png"));
        _bgLayer.addEntity(_testEntity);
        _exitButton = new Button(new Rect(575, 0, 64, 64), loadImage("images/exitbutton.png"));
        _bgLayer.addEntity(_exitButton);
        
        
    }
    
    bit won() {
	return true;
    }
    void draw()
    {
	_background.draw(new Vector2d(0,0));
        _bgLayer.draw();
	
    }
    
    
    void startNewGame() {
        _player = new Player(game());
        _last=this;
    }
    
    void advance(double frametime)
    {
    	
        if(_testEntity.clicked()) {
            startNewGame();
        }
        if(_player) { 
            if(_last.won()) {
		_last = _player.nextScene();
		if (_last) {
	                game().pushScene(_last);
		}
		else {
                	_player = null;
            	} 
            }
            else {
                _player = null;
            }
        }
        if(_exitButton.clicked()) {
            finish();
        }
    }
    
    
    void finish()
    {
        _finished = true;
    }
    
    bit finished()
    {
        return _finished;
    }

    void keyDown(SDL_KeyboardEvent event) {}
    void keyUp(SDL_KeyboardEvent event)
    {
        switch(event.keysym.sym) {
            case SDLK_ESCAPE : finish();break;
            case SDLK_RETURN : startNewGame(); break;
            default:break;
        }
    }
    void mouseMotion(Vector2d mousePosition, Vector2d mouseRel)
    {
        _bgLayer.mouseMotion(mousePosition, mouseRel);
    }
    void lmbDown(Vector2d mousePosition)
    {
        _bgLayer.lmbDown(mousePosition);
    }
    void lmbUp(Vector2d mousePosition)
    {
        _bgLayer.lmbUp(mousePosition);
    }
    
    
private:
    bit _finished = false;
    Image _background;
    Layer _bgLayer;
    Entity _testEntity;
    Scene _last;
    Player _player = null;
    Button _exitButton;

}
