import os

env = Environment(ENV = {'PATH' : os.environ['PATH']})

importPath = []
libPath = []
libs = []

source = [
#        'windows.def',
        'main.d',
        'Log.d',
        'Graphics.d',
        'Game.d',
        'Scene.d',
        'Vector.d',
        'MainMenu.d',
        'Misc.d',
        'ImageResource.d',
        'Image.d',
        'Layer.d',
        'Entity.d',
        'SofuResource.d',
        'Brick.d',
        'GameScene.d',
        'Button.d',
        'Lemming.d',
        'Actor.d',
        'BrickLayer.d',
        'EnemyLayer.d',
        'BulletLayer.d',
        'Animation.d',
        'EditScene.d',
	'Sprite.d',
	'BrickObject.d',
        'Music.d',
        'IntroScene.d',
        'Player.d',
        'OutroScene.d'
]


flags = ''

if env['PLATFORM'] == 'win32' or env['PLATFORM'] == 'cygwin':
    importPath.append('c:/dmd/src/phobos')
    importPath.append('c:/dmd/src/derelict')
    importPath.append('c:/dmd/src/Sofud')
    flags += '-L c:/dmd/lib/derelictSDL.lib -L c:/dmd/lib/sofu.lib -g'
    env['OBJSUFFIX']='.obj'

elif env['PLATFORM'] == 'posix':
    importPath.append('/opt/dmd/src/phobos')
    importPath.append('/opt/dmd/src/derelict')
    libPath.append('/opt/dmd/lib')
    libs = ['derelictSDL']



env.Program(
	target = "aufsie",
	source = source, 
	DPATH = importPath,
	LIBPATH = libPath,
    LIBS = libs,
    DFLAGS = flags
)
