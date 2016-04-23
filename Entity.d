module Entity;

private import ImageResource;
private import Vector;
private import Layer;
private import Sofu.Sofu;



class Entity
{
public:
    this(Rect extent) {
        _extent = new Rect(extent);
    }                       
    
    
    Layer layer()
    {
        return _layer;
    }
    
    
    void setLayer(Layer layer)
    {
        _layer = layer;
    }
    
    
    Rect extent()
    {
        return new Rect(_extent);
    }
    
    
    void extent(Rect extent)
    {
        _extent = new Rect(extent);
    }
    
    
    abstract void draw();

    void advance(double frametime) {}
    
    void mouseMotion(Vector2d mousePosition, Vector2d mouseRel)
    {
        bit pointIn = drawRect().containsPoint(mousePosition);
        if(pointIn && !_underMouse) {
            mouseIn();
        }
        if(!pointIn && _underMouse) {
            mouseOut();
        }
    }
    
    
    void lmbDown(Vector2d mousePosition)
    {
        if(_underMouse) {
            lmbDown();
        }
    }
    
    
    void lmbUp(Vector2d mousePosition)
    {
        if(_underLMB) {
            lmbUp();
        }
    } 
    void mouseIn()
    {
        _underMouse = true;
    }
    void mouseOut()
    {
        _underMouse = false;
    }
    void lmbDown()
    {
        _underLMB = true;
    }
    
    void lmbUp()
    {
        if(_underLMB) {
            _underLMB = false;
            click();
        }
    }

    void rmbDown() {}
    void rmbUp() {}
    
    void click() {
        _clicked = true;
    }
    
    
    bit underMouse()
    {
        return _underMouse;
    }
    
    
    bit underLMB() {
        return _underLMB;
    }
    
    
    bit underMMB() {
        return _underMMB;
    }
    
    
    bit underRMB() {
        return _underRMB;
    }


    bit clicked()
    {
        bit result = _clicked;
        _clicked = false;
        return result;
    }
    
    
    Vector2d drawPosition() {
        return layer().offset() + extent().p1();
    }
    
    
    Rect drawRect() {
        return new Rect(layer().offset() + extent().p1(), layer().offset() + extent().p2());
    }

private:
    Layer _layer;
    Rect _extent;
    
    bit _underMouse = false;
    bit _underLMB = false;
    bit _underRMB = false;
    bit _underMMB = false;
    
    bit _clicked = false;
}
