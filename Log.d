module Log;

private import std.stream;

private File _log = null;


void log(...)
{
    if(!_log) {
        _log = new File("log.txt", FileMode.OutNew);
    }
    
	void putc(dchar c)
	{
        char[4] buf;
        char[] b;

        b = std.utf.toUTF8(buf, c);
        _log.writeBlock(b, b.length);
	}

	std.format.doFormat(&putc, _arguments, _argptr);
}
