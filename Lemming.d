module Lemming;
private import Sofu.Sofu;
private import Actor;
private import Animation;
private import ImageResource;
private import SofuResource;
private import Vector;
private import Brick;
private import Log;
private import Music;



class Lemming : Actor
{
    this(Vector2d position, BrickLayer brickLayer, Sofu.Map.Map data)
    {
   	_state="Idle";
   	foreach(wchar[] attribName, SofuObject attrib; data.map("Animations")) {	
		_Animations[attribName] = new Animation(attrib.asMap());
	}
	
        Rect extent = new Rect(position, position + new Vector2d(data.list("Size")));
        super(extent, brickLayer);
    }
    
    void statechange(wchar[] state)
    {
    	if (_Animations[state]) {
	     _state=state;
	     _Animations[_state].reset();
        }
        else {
             throw(new Exception("Player: State has no Animation"));
        }
    }
    void advance(double frametime)
    {
        super.advance(frametime);
        if(!_dead) {
            if(currentFloor() && !oldFloor()) {
                statechange("Walk");
            }
            if(!currentFloor() && oldFloor()) {
                statechange("Jump");
            }
        }
    	_Animations[_state].next(frametime);
        if(_state == "Walk") {
            velocity(new Vector2d(0.08 * heading(), 0));
        }
        if(_state == "Die") {
            _deadTime += frametime;
            if(_deadTime >= _Animations["Die"].length()) {
                layer().scene().finish();
            }
        }
    }
    
    void draw()
    {
        //Graphics.inst().paintRect(drawRect(), 255, 0, 0);
        if(heading == 1) {
            _Animations[_state].get().draw(drawPosition());
        }
        else {
            _Animations[_state].getMirrored().draw(drawPosition());
        }
    }
    
    
    void hitGoal() {
        layer().gameScene().win();
    }
    
    
    void hitBullet() {
        Log.log("Die\n");
        die();
    }
    
    void die() {
        if(!_dead) {
            statechange("Die");
            _dead = true;
            velocity(new Vector2d(0, 0));
            Music.playSound("voice/ma.ogg");
        }
    }
    
    
    void jump() {
        if(!_dead && _state != "Jump") {
            extent(extent().move(new Vector2d(0, -10)));
            velocity(new Vector2d(0.12 * heading(), -0.3));
            Music.playSound("voice/wee.ogg");
            statechange("Jump");
        }
    }
    
private:
    bit _dead = false;
    wchar[] _state;
    Animation[wchar[]] _Animations;
    double _deadTime = 0;
}
