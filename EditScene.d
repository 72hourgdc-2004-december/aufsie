module EditScene;

import Scene;
private import Sofu.Sofu;
private import Layer;
private import Brick;
private import SofuResource;
private import ImageResource;
private import Image;
private import std.stream;
private import derelict.sdl.sdl;
private import GameScene;
private import Vector;
private import Game;
private import BrickLayer;
private import Sprite;
private import Log;
private import MainMenu;
private import Button;

private import BrickObject;


class EditScene : Scene
{
    this(Game game, char[] levelstring)
    {
    	_level=loadSofu("levels/"~levelstring~".sofu");
	_user=new Sofu.Map.Map(0,0,"");
        super(game);
	_buttonLayer=new Layer(this);
        _return=0;
	_levelstring=levelstring;
        _brickLayer = new BrickLayer(this);
	_userLayer = new BrickLayer(this);
	_background = new Layer(this);
	lastBrick=0;
	_brick=false;
	foreach(SofuObject object; _level.list("Decoration")) {
            Map map = object.asMap();
            wchar[] type = map.value("Type").toUTF16();
            Sprite newSprite = new Sprite(map);
       	    _background.addEntity(newSprite);
        }
	foreach(SofuObject object; _level.list("Enemies")) {
            Map map = object.asMap();
            wchar[] type = map.value("Type").toUTF16();
            Sprite newSprite = new Sprite(map);
       	    _background.addEntity(newSprite);
        }
        _dingsda = new Vector2d();
        foreach(SofuObject object; _level.list("Pieces")) {
            Value val = object.asValue();
            BrickObject newBrick = new BrickObject(val.toUTF8());
	    _bricklist ~= newBrick;
            //newBrick.split(new Vector2d(map.list("Position"),_userLayer);
        }
	
	foreach(SofuObject object; _level.list("World")) {
            Map map = object.asMap();
            Brick newBrick = new Brick(map);
            _brickLayer.addEntity(newBrick);
        }
        _up=false;
        _down=false;
        _left=false;
        _right=false;
        _motion=false;
	_titletime=_level.value("TitleTime").toDouble();
	_title=loadImage(_level.value("Title").toUTF8());
        _point = new Vector2d(_level.list("PlayerStart"));
	_lemming=new Sprite(new Rect(_point,_point+new Vector2d(32,64)),new Animation(loadSofu("player.sofu").map("Animations").map("Idle")));
	_buttonLayer.addEntity(_lemming);

        Sofu.Map.Map editSceneData = loadSofu("EditScene.sofu");

        _guiLayer = new Layer(this);
        _startButton = new Button(editSceneData.map("StartButton"));
        _guiLayer.addEntity(_startButton);
        _homeButton = new Button(editSceneData.map("HomeButton"));
        _guiLayer.addEntity(_homeButton);
    }
    
    
    void centerOnStart() {
        _point = new Vector2d(_level.list("PlayerStart"));
    }
    
    
    void advance(double frametime)
    {
    	if (_left) _point.x(_point.x()-(frametime/10));
   	if (_right) _point.x(_point.x()+(frametime/10));
	if (_up) _point.y(_point.y()-(frametime/10));
	if (_down) _point.y(_point.y()+(frametime/10));
	bit release=false;
	foreach (BrickObject object; _bricklist) {
		if (object.clicked()) {
			object.release();
			release=true;
		}
	}
	if (release) {
		_userLayer.flush();
		foreach (BrickObject object; _bricklist) {
			if (object.set()) {
				object.split(_userLayer);
			}
	}
	}
	_titletime-=frametime;	
        _brickLayer.advance(frametime);
	_userLayer.advance(frametime);
	_buttonLayer.advance(frametime);
	_background.advance(frametime);
        _brickLayer.centerOn(_point);
        _buttonLayer.centerOn(_point);
	_userLayer.centerOn(_point);
	_background.centerOn(_point);
	if (_lemming.clicked() || _startButton.clicked()) {
	    run();
	}
        if(_homeButton.clicked()) {
            centerOnStart();
        }
	if (_brick) {
                assert(lastBrick < _bricklist.length);
		_bricklist[lastBrick].advance(frametime);
	}
    }
    
    
    void draw()
    {
	_background.draw();
	if (_titletime>0) _title.draw(new Vector2d(320-_title.width()/2,20));
        _brickLayer.draw();
	_userLayer.draw();
	_buttonLayer.draw();
	if (_brick) {
                assert(lastBrick < _bricklist.length);
		_bricklist[lastBrick].draw(_dingsda);
	}
        _guiLayer.draw();
    }
    
    void finish()
    {
        _finished = true;
    }
    
    bit finished() {
        return _finished;
    }
    bit won() {
	return _won;
    }   
    void win() {
	finish();
	_won=true;
    } 
    int returncode() {
	if (_finished) {
	     return _return;
        }
	
    }
    void run() {
    	save();
	GameScene gamer=new GameScene(game(), this, _level, _user);
        game().pushScene(gamer);
    }
    void save() {
        _user.setAttribute("Bricks",_userLayer.getEntities());
	//File file=new File("save/"~_levelstring~".sofu", FileMode.OutNew);
	//char[] str = _user.outputString();
	//file.writeBlock(str, str.length);	
    }
    void keyDown(SDL_KeyboardEvent event) {
         switch (event.keysym.sym) {
	     case SDLK_LEFT:_left=true;break;
	     case SDLK_RIGHT:_right=true;break;
	     case SDLK_UP:_up=true;break;
	     case SDLK_DOWN:_down=true;break;
	     case SDLK_SPACE:chooseBrick();break;
             case SDLK_h:centerOnStart();break;
	     default:break;
         }
    }
    void chooseBrick() {
    	//Log.log("%s","Choose Brick...");
    	if (!_brick) {
		lastBrick=0;
	}
	else {
		lastBrick++;
	}
	for (int i=lastBrick;i<_bricklist.length;i++) {
		if (!_bricklist[i].set()) {
			lastBrick=i;
			_brick=true;
			//Log.log("found:%d.\n",i);
			return;
		}
	}
	//Log.log("%s","No brick\n");
	_brick=false;
	lastBrick=0;
    }
    void keyUp(SDL_KeyboardEvent event) {
         switch (event.keysym.sym) {
	     case SDLK_LEFT:_left=false;break;
	     case SDLK_RIGHT:_right=false;break;
	     case SDLK_UP:_up=false;break;
	     case SDLK_DOWN:_down=false;break;
	     case SDLK_ESCAPE:_finished=true;_return=0;save();break;
	     case SDLK_RETURN:run();break;
	     default:break;
         }
    }
    void mouseMotion(Vector2d mousePosition, Vector2d mouseRel) {
    	_userLayer.mouseMotion(mousePosition,mouseRel);
	_buttonLayer.mouseMotion(mousePosition,mouseRel);
    	if (_motion) {
	    _point+=-mouseRel;
	}
	if (_brick) {
		_dingsda=mousePosition - _bricklist[lastBrick].extent().center();
	}
        _guiLayer.mouseMotion(mousePosition, mouseRel);
    }
    void lmbDown(Vector2d mousePosition) {
    	_userLayer.lmbDown(mousePosition);
	_buttonLayer.lmbDown(mousePosition);
        _guiLayer.lmbDown(mousePosition);
    }
    void lmbUp(Vector2d mousePosition) {
        _userLayer.lmbUp(mousePosition);
	_buttonLayer.lmbUp(mousePosition);
	if (_brick)  {
		_bricklist[lastBrick].split(_point+mousePosition-new Vector2d(320,240) - _bricklist[lastBrick].extent().center(),_userLayer);
		_brick=false;
	}
        _guiLayer.lmbUp(mousePosition);
    }
    void rmbDown(Vector2d mousePosition) {
        _motion=true;
	SDL_WM_GrabInput(SDL_GRAB_ON);;
    }
    void rmbUp(Vector2d mousePosition) {
        _motion=false;
	SDL_WM_GrabInput(SDL_GRAB_OFF);
    }


    
private:
    BrickLayer _brickLayer;
    BrickLayer _userLayer;
    Layer _buttonLayer;
    Layer _background;  
    Layer _guiLayer;
    Button _startButton;
    Button _homeButton;
    Sprite _lemming;
    Sofu.Map.Map _user;
    Sofu.Map.Map _level;
    int _return;
    
    bit _up;
    bit _down;
    bit _left;
    bit _right;
    bit _motion;
    bit _brick;
    bit _won=false;
    BrickObject[] _bricklist;
    int lastBrick;
    Vector2d _point;
    Vector2d _dingsda;
    double _titletime;
    Image _title;

    bit _finished = false;
    char[] _levelstring;
}
