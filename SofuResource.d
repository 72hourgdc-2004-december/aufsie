module SofuResource;

private import Sofu.Sofu;


Sofu.Map.Map[char[]] _sofuFiles;

Sofu.Map.Map loadSofu(char[] fileName)
{
    if(!_sofuFiles[fileName])
    {
        _sofuFiles[fileName] = Sofu.Sofu.loadFile(fileName);
    }
    return _sofuFiles[fileName];
}
