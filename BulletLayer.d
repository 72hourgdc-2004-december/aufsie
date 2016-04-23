module BulletLayer;

private import Layer;
private import Actor;
private import Entity;
private import Vector;
private import Sofu.Sofu;
private import Scene;
private import Graphics;
private import Animation;
private import Music;

class Bullet : Entity {
	this(Sofu.Map.Map data,Vector2d _position) {
        	Vector2d size = new Vector2d(data.list("Size"));
		super(new Rect(_position, _position + size));
		_velocity = new Vector2d(data.list("Speed"));
		_anim = new Animation(data.map("Animation"));
                Music.playSound("voice/shot.ogg");
	}
	void draw () {
		_anim.get().draw(drawPosition());	
	}
	void advance(double frametime) {
		extent(extent().move(_velocity*frametime));
		_anim.next(frametime);
	}
	private:
	Vector2d _velocity;
	Animation _anim;
}

class BulletLayer : Layer
{
    this(Scene scene)
    {
        super(scene);
    }
    
    
    bit collide(Actor actor)
    {
        bit result;
        foreach(Entity entity; _entities) {
            if(actor.extent().overlaps(entity.extent())) {
                result = true;
            }
        }
        if(result) {
            actor.hitBullet();
        }
        return result;
    }
}
