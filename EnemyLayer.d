module EnemyLayer;

private import Layer;
private import Actor;
private import Entity;
private import Vector;
private import Sofu.Sofu;
private import Scene;
private import Graphics;
private import Animation;
private import BulletLayer;

class Enemy : Entity {
	this(Sofu.Map.Map data,BulletLayer layer){
		_layer=layer;
		_position = new Vector2d(data.list("Position"));
        	Vector2d size = new Vector2d(data.list("Size"));
		super(new Rect(_position, _position + size));
		_anim = new Animation(data.map("Animation"));
		if (data.value("Type").toUTF8() == "Shooting") {
			_shoot=true;
			_bullet=data.map("Bullet");
			_bullettime=data.value("Bullettime").toDouble();
			_timeleft=_bullettime;
		}
	}
	void draw () {
		_anim.get().draw(drawPosition());	
	}
	void advance(double frametime) {
		_anim.next(frametime);
		super.advance(frametime);
		if (_shoot) {
			_timeleft-=frametime;
			if (_timeleft<0) {
				_timeleft+=_bullettime;
				Bullet bullet=new Bullet(_bullet,_position);			
				layer.addEntity(bullet);
			}
		}
		
	}
	private:
	Vector2d _position;
	bit _shoot=false;
	Animation _anim;
	double _timeleft;
	double _bullettime;
	Sofu.Map.Map _bullet;
	BulletLayer _layer;
}

class EnemyLayer : Layer
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
