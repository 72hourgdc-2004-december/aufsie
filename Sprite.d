module Sprite;

import Entity;
private import Sofu.Sofu;
private import Vector;
private import ImageResource;
private import Image;
private import Animation;
private import Log;

class Sprite : Entity
{
    this(Rect extent, Animation anim)
    {
        super(extent);
	_animation = true;
        _anim = anim;
    }
    this(Sofu.Map.Map data, bit moveable=false)
    {
	Vector2d _size = new Vector2d(data.list("Size"));
	Vector2d position= new Vector2d(0,0);
	if (!moveable) {
		position = new Vector2d(data.list("Position"));
	}
	super(new Rect(position, position + _size));
	try {
		Sofu.Map.Map ani=data.map("Animation");
		_animation = true;
		_anim = new Animation(ani);
	}
	catch (AttributeDoesNotExistException x){
		_animation = false;
		_image = loadImage(data.value("Image").toUTF8());
	}
    }

	this(Rect extent, Image img)
    {
        super(extent);
	_animation = false;
        _image = img;
    }
    
    void draw()
    {
        //Graphics.inst().paintRect(drawRect(), 255, 0, 0);
        if (_animation) {
		_anim.get().draw(drawPosition());
	}
	else {
		_image.draw(drawPosition());
	}

    }
    void draw(Vector2d position)
    {
        //Graphics.inst().paintRect(new Rect(position, position + new Vector2d(32, 32)), 0, 0, 255);
        if (_animation) {
		_anim.get().draw(position);
	}
	else {
		_image.draw(position);
	}

    }
    void advance(double frametime) {
	if (_animation) {
		_anim.next(frametime);
	}
	super.advance(frametime);
    }
    
private:
    bit _animation;
    Animation _anim;
    Image _image;
}
