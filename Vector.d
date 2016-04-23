module Vector;

private import Log;
private import SofuResource;
private import Sofu.Sofu;
private import Misc;


const double M_PI = 3.14159265358979323846;

class Vector2d
{
public:
    this()
    {
    }


    this(double x, double y)
    {
        _x = x;
        _y = y;
    }
    
    
    this(Sofu.List.List list)
    {
        _x = list.value(0).toDouble();
        _y = list.value(1).toDouble();
    }
    
    
    this(Vector2d cpy)
    {
        _x = cpy._x;
        _y = cpy._y;
    }


    double x()
    {
        return _x;
    }


    void x(double x)
    {
        _x = x;
    }


    double y()
    {
        return _y;
    }


    void y(double y)
    {
        _y = y;
    }
    
    
    Vector2d opAssign(Vector2d other) {
        _x = other._x;
        _y = other._y;
        return this;
    }
    
    
    Vector2d opAdd(Vector2d other)
    {
        return new Vector2d(_x + other._x, _y + other._y);
    }


    Vector2d opMul(double scalar)
    {
        return new Vector2d(_x * scalar, _y * scalar);
    }


    Vector2d opDiv(double scalar)
    {
        return new Vector2d(_x / scalar, _y / scalar);
    }


    Vector2d opSub(Vector2d other)
    {
        return new Vector2d(_x - other._x, _y - other._y);
    }


    Vector2d opNeg()
    {
        return new Vector2d(-_x, -_y);
    }
    
    
    void opAddAssign(Vector2d other)
    {
        _x += other._x;
        _y += other._y;
    }
    
    


private:
    double _x = 0.0;
    double _y = 0.0;
}



const double D_TO_R = M_PI / 180.0;
const double R_TO_D = 180.0 / M_PI;

double degreesToRadians(double angle) {
    return angle * D_TO_R;
}


double radiansToDegrees(double angle) {
    return angle * R_TO_D;
}


class Rect
{
    this(Vector2d v1, Vector2d v2)
    {
        _v1 = new Vector2d(v1);
        _v2 = new Vector2d(v2);
    }


    this(double x1, double y1, double w, double h)
    {
        this(new Vector2d(x1, y1), new Vector2d(x1 + w, y1 + h));
    }
    
    
    this(Rect rect) {
        _v1 = new Vector2d(rect._v1);
        _v2 = new Vector2d(rect._v2);
    }


    Vector2d p1()
    {
        return _v1;
    }


    Vector2d p2()
    {
        return _v2;
    }
    
    
    double width() {
        return _v2.x() - _v1.x();
    }
    
    
    double height() {
        return _v2.y() - _v1.y();
    }


    /+ A vector pointing from the top left to the lower right corner +/
    Vector2d diagonale()
    {
        return _v2 - _v1;
    }


    double top()
    {
        return _v1.y();
    }


    double bottom() {
        return _v2.y();
    }


    double left() {
        return _v1.x();
    }


    double right() {
        return _v2.x();
    }
    
    
    Vector2d center() {
        return _v1 + (diagonale() / 2);
    }
    
    
    Vector2d topleft() {
        return new Vector2d(_v1);
    }
    
    
    Vector2d topright() {
        return new Vector2d(_v2.x(), _v1.y());
    }
    
    
    Vector2d bottomleft() {
        return new Vector2d(_v1.x(), _v2.y());
    }
    
    
    Vector2d bottomright() {
        return new Vector2d(_v2);
    }
    
    
    double centerx() {
        return center().x();
    }
    
    
    double centery() {
        return center().y();
    }
    
    
    Rect move(Vector2d by) {
        return new Rect(_v1 + by, _v2 + by);
    }
    
    
    Rect moveToTop(double top) {
        Vector2d size = diagonale();
        Vector2d nv1 = new Vector2d(_v1.x(), top);
        Vector2d nv2 = nv1 + size;
        Rect result = new Rect(nv1, nv2);
        return result;
    }

    Rect moveToBottom(double bottom) {
        Vector2d size = diagonale();
        Vector2d nv2 = new Vector2d(_v2.x(), bottom);
        Vector2d nv1 = nv2 - size;
        Rect result = new Rect(nv1, nv2);
        return result;
    }
    
    Rect moveToLeft(double left) {
        Vector2d size = diagonale();
        Vector2d nv1 = new Vector2d(left, _v1.y());
        Vector2d nv2 = nv1 + size;
        Rect result = new Rect(nv1, nv2);
        return result;
    }

    Rect moveToRight(double right) {
        Vector2d size = diagonale();
        Vector2d nv2 = new Vector2d(right, _v2.y());
        Vector2d nv1 = nv2 - size;
        Rect result = new Rect(nv1, nv2);
        return result;
    }


    bit containsPoint(Vector2d vec)
    {
        bit result = vec.x() > _v1.x() && vec.y() > _v1.y()
            && vec.x() < _v2.x() && vec.y() < _v2.y();
        return result;
    }
    
    Rect overlaps(Rect rect) {
        double top = max(top(), rect.top());
        double left = max(left(), rect.left());
        double bottom = min(bottom(), rect.bottom());
        double right = min(right(), rect.right());
        
        if(bottom > top && right > left) {
            Rect result = new Rect(left, top, right-left, bottom-top);
            return result;
        }
        return null;
    }


    invariant
    {
        assert(_v1.x() <= _v2.x() && _v1.y() <= _v2.y());
    }

private:
    Vector2d _v1, _v2;
}
