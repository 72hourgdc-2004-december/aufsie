module Actor;

private import Entity;
private import Vector;
private import BrickLayer;
private import Brick;
private import Sofu.Sofu;
private import Scene;

class Actor : Entity
{
    this(Rect extent, BrickLayer brickLayer)
    {
        super(extent);
        _brickLayer = brickLayer;
        _velocity = new Vector2d;
    }
    
    void advance(double frametime)
    {
        _velocity += layer().gameScene().gravity() * frametime;
        extent(_brickLayer.moveCollide(this, _velocity * frametime));
    }
    
    
    Vector2d velocity()
    {
        return _velocity;
    }
    
    
    void velocity(Vector2d velocity)
    {
        _velocity = velocity;
    }
    
    void accelerate(Vector2d acc)
    {
        _velocity += acc;
    }
    
    
    BrickLayer brickLayer()
    {
        return _brickLayer;
    }
    
    
    void setFloor(Brick floor)
    {
        _oldFloor = _currentFloor;
        _currentFloor = floor;
    }
    
    
    Brick currentFloor()
    {
        return _currentFloor;
    }
    
    
    Brick oldFloor()
    {
        return _oldFloor;
    }
    
    
    int heading() {
        return _heading;
    }
    
    
    void heading(int heading) {
        _heading = heading;
    }
    
    
    void turnAround() {
        if(_heading == 1) {
            _heading = -1;
        }
        else {
            _heading = 1;
        }
    }
    
    
    abstract void die();
    
    
    abstract void jump();
    
    
    abstract void hitGoal();
    
    
    abstract void hitBullet();
    
    
private:
    Vector2d _velocity;
    BrickLayer _brickLayer;
    Brick _currentFloor = null;
    Brick _oldFloor = null;
    int _heading = 1; // Left -1 Right 1
}
