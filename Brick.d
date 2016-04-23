module Brick;

private import Entity;
private import Sofu.Sofu;
private import Vector;
private import Sprite;
private import ImageResource;
private import Image;
private import std.utf;
private import Misc;


class Brick : Sprite
{
    this(Sofu.Map.Map data)
    {	
        _data = new Map(0, 0, "BrickMap1");
        foreach(wchar[] attribName, SofuObject attrib; data) {
            _data.setAttribute(attribName, attrib);
        } 
	_type=_data.value("Type").toUTF8();
        super(_data);

    }
    this(Sofu.Map.Map data, Vector2d position)
    {
        _data = new Map(0, 0, "BrickMap2");
        foreach(wchar[] attribName, SofuObject attrib; data) {
            _data.setAttribute(attribName, attrib);
        } 
	_type=data.value("Type").toUTF8();
	Sofu.List.List koord=new Sofu.List.List(0,0,"0");       
	koord.appendElement(new Sofu.Value.Value(toUTF16(swritef("%s", position.x())),0,0,"0"));
        koord.appendElement(new Sofu.Value.Value(toUTF16(swritef("%s", position.y())),0,0,"0"));
        _data.setAttribute("Position",koord);
        super(_data);
    }
    
    char[] type() {
	return _type;
    }

    
    Sofu.Map.Map getBrick() {
        return _data;
    }
    
private:
    Sofu.Map.Map _data;
    char[] _type;
}
