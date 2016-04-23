module Layer;

private import Entity;
private import ImageResource;
private import Vector;
private import Scene;
private import GameScene;
private import Sofu.Sofu;


class Layer
{
public:
    this(Scene scene) {
        _scene = scene;
        _offset = new Vector2d;
    }

    void draw()
    {
        foreach(Entity entity; _entities) {
            entity.draw();
        }
    }
    void flush() 
    {
	_entities.length=0;
    }

    void addEntity(Entity entity)
    {
        assert(entity);
        _entities ~= entity;
        entity.setLayer(this);
    }
    
    
    
    
    
    void mouseMotion(Vector2d mousePosition, Vector2d mouseRel)
    {
        foreach(Entity entity; _entities) {
            entity.mouseMotion(mousePosition, mouseRel);
        }
    }
    
    void lmbDown(Vector2d mousePosition) {
        foreach(Entity entity; _entities) {
            entity.lmbDown(mousePosition);
        }
    }
    
    void lmbUp(Vector2d mousePosition) {
        foreach(Entity entity; _entities) {
            entity.lmbUp(mousePosition);
        }
    }
    
    void advance(double frametime)
    {
        foreach(Entity entity; _entities) {
            entity.advance(frametime);
        }
    }
    void centerOn(Vector2d offset)
    {
        _offset = new Vector2d(-offset + new Vector2d(320, 240));
    }
    

    Vector2d offset()
    {
        return _offset;
    }

    
    Scene scene() {
        return _scene;
    }
    
    
    GameScene gameScene() {
        return cast(GameScene) _scene;
    }
    
private:
    Scene _scene;
    Vector2d _offset;

protected:
    Entity[] _entities;
}
