module BrickObject;

private import Sofu.Sofu;
private import Vector;
private import SofuResource;
private import ImageResource;
private import Image;
private import BrickLayer;
private import Sprite;
private import std.utf;
private import Misc;
private import Brick;
private import Log;


class Brickpos {
	this(char[] name,Vector2d pos,Sofu.Map.Map data) {
		_name=name;
		_absPos=pos;
		_brick=new Sprite(data.map("Brickys").map(toUTF16(name)),true);
	}
	Vector2d position() {
		return _absPos;
	}
	void draw(Vector2d pos) {
                assert(pos);
                assert(_absPos);
		_brick.draw(pos+_absPos);
	}
	void advance(double frametime) {
		_brick.advance(frametime);
	}
        char[] name() {
            return _name;
        }
        Vector2d absPos() {
            return _absPos;
        }
        Sprite sprite() {
            return _brick;
        }
	private:
	Vector2d _absPos;
	char[] _name;
	Sprite _brick;
}

class BrickObject {
	this(char[] name) {
		_name=name;
		_position=new Vector2d(0,0);
		_set=false;
		_data=loadSofu("bricks.sofu");
		foreach(SofuObject object; _data.map("Bricks").list(toUTF16(_name))) {
			Brickpos Pos=new Brickpos(object.asMap().value("Brick").toUTF8(),new Vector2d(object.asMap().list("Position")),_data);
			_daList_o_daBricks~=Pos;
		}	
	}
	bit clicked() {
		bit s=0;
		foreach (Brick foo;_bricklist) {
			if (foo.clicked()) {
			    s = true;
			}
		}
		return s;
	}
	bit set() {
		return _set;
	}
	void release() {
		_set=false;
	}
	
	void draw(Vector2d position) {
		foreach (Brickpos bricky;_daList_o_daBricks) {
			bricky.draw(position);
		}
	}
	void split(Vector2d position, BrickLayer layer) {
		_position=position;
		_set=true;
		foreach (Brickpos bricky;_daList_o_daBricks) {
			Brick daBrick=new Brick(_data.map("Brickys").map(toUTF16(bricky.name)),position+bricky.absPos);
			_bricklist ~= daBrick;
			layer.addEntity(daBrick);
		}
	}
	void split(BrickLayer layer) {
		_set=true;
		foreach (Brickpos bricky;_daList_o_daBricks) {
			Brick daBrick=new Brick(_data.map("Brickys").map(toUTF16(bricky.name)),_position+bricky.absPos);
			_bricklist ~= daBrick;
			layer.addEntity(daBrick);
		}
	}
	void advance(double frametime) {
		foreach (Brickpos bricky;_daList_o_daBricks) {
			bricky.advance(frametime);
		}
	}
        
        Rect extent()
        {
            if(_daList_o_daBricks.length > 0) {
                double top = _daList_o_daBricks[0].sprite().extent().top();
                double bottom = _daList_o_daBricks[0].sprite().extent().bottom();
                double left = _daList_o_daBricks[0].sprite().extent().left();
                double right = _daList_o_daBricks[0].sprite().extent().right();
                foreach(Brickpos bricky; _daList_o_daBricks) {
                    Rect ext = bricky.sprite().extent().move(bricky.position());
                    if(ext.top() < top) {
                        top = ext.top();
                    }
                    if(ext.bottom() > bottom) {
                        bottom = ext.bottom();
                    }
                    if(ext.left() < left) {
                        left = ext.left();
                    }
                    if(ext.right() > right) {
                        right = ext.right();
                    }
                }
                
                return new Rect(new Vector2d(left, top), new Vector2d(right, bottom));
            }
            return new Rect(0, 0, 0, 0);
        }
        
	private:
	Vector2d _position;
	bit _set;
	Brick[] _bricklist;
	Brickpos[] _daList_o_daBricks;
	char[] _name;
	Sofu.Map.Map _data;
}
