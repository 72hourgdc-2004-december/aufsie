module Player;

private import Game;
private import EditScene;
private import SofuResource;
private import Scene;
private import Sofu.Sofu;
private import OutroScene;


class Player
{
public:
    this(Game game) {
        _game = game;
	foreach (SofuObject object;loadSofu("level.sofu").list("Levels")) { 
        	_levels ~= object.asValue().toString();
	}
    }
    
    
    Scene nextScene() {
        if(_level < _levels.length) {
            scene = new EditScene(_game, _levels[_level]);
            ++_level;
            return scene;
        }
        else if(_level == _levels.length) {
            scene = new OutroScene(_game);
            ++_level;
            return scene;
        }
        return null;
    }
private:
    Game _game;
    char[][] _levels;
    int _level = 0;
    Scene scene;
}
