module BrickLayer;

private import Layer;
private import Actor;
private import Entity;
private import Brick;
private import Vector;
private import Sofu.Sofu;
private import Scene;
private import Graphics;

class BrickLayer : Layer
{
    this(Scene scene)
    {
        super(scene);
    }
    
    
    Rect moveCollide(Actor actor, Vector2d velocity)
    {
        bit ondefloor = false;
        Rect crect = actor.extent().move(velocity);
        foreach(Entity entity; _entities) {
            Brick brick = cast(Brick) entity;
            if(brick) {
                bit collide = false;
                Rect over = brick.extent().overlaps(crect);
                if(over) {
                    collide = true;
                    bit noturn = false;
                    if(over.height() * over.width() <= 4) {
                        noturn = true;
                    }
                    if(over.height() < over.width()) {
                        if(velocity.y() >= 0) {
                            if(crect.center().y() < brick.extent().center().y()) {
                                if(brick.type() == "solid" || brick.type() == "TopStone") {
                                    crect = crect.moveToBottom(brick.extent().top());
                                    ondefloor = true;
                                    actor.setFloor(brick);
                                }
                            }
                        }
                        else {
                            if(crect.center().y() > brick.extent().center().y()) {
                                if(brick.type() == "solid") {
                                    crect = crect.moveToTop(brick.extent().bottom());
                                    actor.velocity(new Vector2d(actor.velocity().x(), 0));
                                }
                                if(brick.type() == "TopStone") {
                                    actor.die();
                                }
                            }
                        }
                    }
                    else {
                        if(velocity.x() >= 0) {
                            if(crect.center().x() < brick.extent().center().x()) {
                                if(brick.type() == "solid") {
                                    crect = crect.moveToRight(brick.extent().left());
                                    if(!noturn)
                                    {
                                        actor.velocity(new Vector2d(0, actor.velocity().y()));
                                        actor.heading(-1);
                                    }
                                }
                                if(brick.type() == "TopStone") {
                                    actor.die();
                                }
                            }
                        }
                        else {
                            if(crect.center().x() > brick.extent().center().x()) {
                                if(brick.type() == "solid") {
                                    crect = crect.moveToLeft(brick.extent().right());
                                    if(!noturn) {
                                        actor.velocity(new Vector2d(0, actor.velocity().y()));
                                        actor.heading(1);
                                    }
                                }
                                if(brick.type() == "TopStone") {
                                    actor.die();
                                }
                            }
                        }
                    }
                }
                if(collide) {
                    if(brick.type == "Jump") {
                        actor.jump();
                    }
                    if(brick.type == "Goal") {
                        actor.hitGoal();
                    }
                }
            }
        }
        
        if(!ondefloor) {
            actor.setFloor(null);
        }
        
        return crect;
    }
    
    Sofu.List.List getEntities() {
 	Sofu.List.List list=new Sofu.List.List(0,0,"");
	foreach(Entity entity; _entities) {
	    Brick brick = cast(Brick) entity;
	    list.appendElement(brick.getBrick());
        }
	return list;
    }
}
