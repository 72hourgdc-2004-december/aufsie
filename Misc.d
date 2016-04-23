module Misc;

private import std.format;
private import std.utf;
private import derelict.sdl.sdl;

char[] swritef(...)
{
    char[] result;

	void putc(dchar c)
	{
        char[4] buf;
        char[] b;

        b = std.utf.toUTF8(buf, c);
        for (size_t i = 0; i < b.length; i++) {
            result ~= b[i];
	    }
	}

	std.format.doFormat(&putc, _arguments, _argptr);
    
    return result;
}


double max(double a, double b)
{
    if(a > b) {
        return a;
    }
    else {
        return b;
    }
}


double min(double a, double b)
{
    if(a < b) {
        return a;
    }
    else {
        return b;
    }
}
