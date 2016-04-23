module Music;

private import derelict.sdl.sdl;
private import derelict.sdl.mixer;
private import Log;


private Mix_Music*[char[]] loadedMusic;
private Mix_Chunk*[char[]] loadedSounds;


void start()
{
    Mix_OpenAudio(22050, AUDIO_S16SYS, 2, 2048);
}


void playMusic(char[] fileName, int times = -1)
{
    if(!loadedMusic[fileName]) {
        Log.log("Loading music '%s'\n", fileName);
        loadedMusic[fileName] = Mix_LoadMUS(fileName);
    }
    Mix_PlayMusic(loadedMusic[fileName], times);
}


void stopMusic(double ms)
{
    Mix_FadeOutMusic(cast(int) ms);
}


void loadSound(char[] fileName)
{
    if(!loadedSounds[fileName]) {
        Log.log("Loading sound '%s'\n", fileName);
        loadedSounds[fileName] = Mix_LoadWAV(fileName);
    }
}


void startPreload()
{
    Mix_Volume(1, 0);
}


void endPreload()
{
    Mix_Volume(1, 128);
}

void preloadSound(char[] fileName)
{
    loadSound(fileName);
    Mix_PlayChannel(1, loadedSounds[fileName], 0);
}


void playSound(char[] fileName)
{
    loadSound(fileName);
    Mix_PlayChannel(-1, loadedSounds[fileName], 0);
}
