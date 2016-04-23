module Image;

private import ImageResource;
private import Vector;
private import Log;

class Image
{
    this(ImageResource resource)
    {
        _resource = resource;
    }
    
    
    void draw(Vector2d vec)
    {
        //Log.log("Image.draw\n");
        _resource.load();
        _resource.draw(cast(int) vec.x(),
            cast(int) vec.y());
        //Log.log("/Image.draw\n");
    }
    
   int width() {
        return _resource.width();
    }
    
    
    int height() {
        return _resource.height();
    }
    
    ImageResource resource() {
        return _resource;
    }
    
    
    Image mirrored() {
        if(!_mirrored) {
            _mirrored = loadMirroredImage(_resource.fileName());
        }
        return _mirrored;
    }
private:
    ImageResource _resource;
    Image _mirrored = null;
}
