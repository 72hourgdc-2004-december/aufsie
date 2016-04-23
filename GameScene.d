module GameScene;

private import Scene;
private import Sofu.Sofu;
private import derelict.sdl.sdl;
private import Layer;
private import SofuResource;
private import ImageResource;
private import Image;
private import Lemming;
private import BrickLayer;
private import BulletLayer;
private import EnemyLayer;
private import Vector;
private import Game;
private import Brick;
private import Log;
private import Sprite;
private import EditScene;
private import Music;
private import Button;


class GameScene : Scene
{
    this(Game game, EditScene editScene, Sofu.Map.Map level,Sofu.Map.Map user)
    {
        _editScene = editScene;
        super(game);
        
        _brickLayer = new BrickLayer(this);
	_background = new Layer(this);
	_bulletlayer = new BulletLayer(this);
	_enemylayer = new EnemyLayer(this);

       foreach(SofuObject object; user.list("Bricks")) {
            Map map = object.asMap();
            wchar[] type = map.value("Type").toUTF16();
            Brick newBrick = new Brick(map);
            _brickLayer.addEntity(newBrick);
        } 

	foreach(SofuObject object; level.list("World")) {
            Map map = object.asMap();
            wchar[] type = map.value("Type").toUTF16();
            Brick newBrick = new Brick(map);
            _brickLayer.addEntity(newBrick);
        }

	foreach(SofuObject object; level.list("Decoration")) {
            Map map = object.asMap();
            Sprite newSprite = new Sprite(map);
       	    _background.addEntity(newSprite);
        }
	foreach(SofuObject object; level.list("Enemies")) {
            Map map = object.asMap();
            Enemy newEnemy = new Enemy(map,_bulletlayer);
       	    _enemylayer.addEntity(newEnemy);
        }
       
        _lemmingLayer = new Layer(this);
        Map lemmingMap = loadSofu("player.sofu");
        _lemming = new Lemming(
            new Vector2d(level.list("PlayerStart")),
            _brickLayer,
            lemmingMap);
        _lemmingLayer.addEntity(_lemming);
        _titletime=level.value("TitleTime").toDouble();
	_title=loadImage(level.value("Title").toUTF8());
        _gravity = new Vector2d(level.list("Gravity"));
        
        Sofu.Map.Map gameSceneData = loadSofu("GameScene.sofu");
        
        _guiLayer = new Layer(this);
        _stopButton = new Button(gameSceneData.map("StopButton"));
        _guiLayer.addEntity(_stopButton);
        
        
        Music.playSound("voice/mau.ogg");
    }
    
    
    void advance(double frametime)
    {
        if(_stopButton.clicked()) {
            _lemming.die();
        }
	_titletime-=frametime;	
        _brickLayer.advance(frametime);
        _lemmingLayer.advance(frametime);
	_background.advance(frametime);
	_bulletlayer.advance(frametime);
	_enemylayer.advance(frametime);
        _guiLayer.advance(frametime);
        _brickLayer.centerOn(_lemming.extent().center());
        _lemmingLayer.centerOn(_lemming.extent().center());
	_background.centerOn(_lemming.extent().center());
	_bulletlayer.centerOn(_lemming.extent().center());
	_enemylayer.centerOn(_lemming.extent().center());
        _bulletlayer.collide(_lemming);
        _enemylayer.collide(_lemming);
    }
    
    
    void draw()
    {
	_background.draw();
        _brickLayer.draw();
        _lemmingLayer.draw();
	_bulletlayer.draw();
	_enemylayer.draw();
        _guiLayer.draw();
	if (_titletime>0) _title.draw(new Vector2d(320-_title.width()/2,20));

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
        Music.playSound("voice/bictori.ogg");
	_won=true;
        _editScene.win();
        finish();
    } 
    
    void mouseMotion(Vector2d mousePosition, Vector2d mouseRel)
    {
        _guiLayer.mouseMotion(mousePosition, mouseRel);
    }
    
    
    void lmbDown(Vector2d mousePosition)
    {
        _guiLayer.lmbDown(mousePosition);
    }
    
    void lmbUp(Vector2d mousePosition)
    {
        _guiLayer.lmbUp(mousePosition);
    }
    
    void keyUp(SDL_KeyboardEvent event) {
         switch (event.keysym.sym) {
	     case SDLK_ESCAPE:_lemming.die();break;
	     default:break;
         }
    }
    Vector2d gravity() {
        return _gravity;
    }
    
private:
    EditScene _editScene;
    BrickLayer _brickLayer;
    
    Lemming _lemming;
    Layer _lemmingLayer;
    BulletLayer _bulletlayer;
    EnemyLayer _enemylayer;
    Layer _background;
    Layer _guiLayer;
    Vector2d _gravity;
    Button _stopButton;
    
    double _titletime;
    Image _title;

    bit _won=false;
    bit _finished = false;
    
}
