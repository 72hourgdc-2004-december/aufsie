module Button;

import Entity;
private import Sofu.Sofu;
private import Vector;
private import ImageResource;
private import Image;

class Button : Entity
{
    this(Rect extent, Image image)
    {
        super(extent);
        _image = image;
    }
    
    
    this(Sofu.Map.Map data)
    {
        Vector2d pos = new Vector2d(data.list("Position"));
        Vector2d size = new Vector2d(data.list("Size"));
        Rect extent = new Rect(pos, pos + size);
        super(extent);
        _image = loadImage(data.value("Image").toUTF8());
    }
    
    void draw()
    {
        _image.draw(drawPosition());
    }
    
private:
    Image _image;
}
