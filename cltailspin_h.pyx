import threading

cdef force(o):
    if isinstance(o,tailfish):
        return (<tailfish>o).__force__()
    else:
        return o

cdef class tailfish:
    cdef object func
    cdef object args
    cdef object kw
    def __cinit__(tailfish self,func,args,kw):
        self.func = func
        self.args = args
        self.kw = kw
    cdef __force__(tailfish self):
        return self.func(*self.args,**self.kw)
    
    # Methods for autoforcing
    # see http://docs.cython.org/docs/special_methods.html
    # Some of these were skipped due to laziness; add them if you need them
    def __add__(x,y):
        return force(x) + force(y)
    def __sub__(x,y):
        return force(x) - force(y)
    def __mul__(x,y):
        return force(x) * force(y)
    def __div__(x,y):
        return force(x) / force(y)
    def __floordiv__(x,y):
        return force(x) // force(y)
    def __truediv__(x,y):
        return force(x) / force(y)
    def __mod__(x,y):
        return force(x) % force(y)
    def __lshift__(x,y):
        return force(x) << force(y)
    def __rshift__(x,y):
        return force(x) >> force(y)
    def __and__(x,y):
        return force(x) & force(y)
    def __or__(x,y):
        return force(x) | force(y)
    def __xor__(x,y):
        return force(x) ^ force(y)

    def __neg__(tailfish self):
        return -self.__force__()
    def __pos__(tailfish self):
        return +self.__force__()
    def __abs__(tailfish self):
        return abs(self.__force__())
    def __nonzero__(tailfish self):
        return bool(self.__force__())
    def __invert__(tailfish self):
        return ~self.__force__()
    
    def __cmp__(x,y):
        return cmp(force(x),force(y))
    def __richcmp__(x,y,int op):
        if op == 0:
            return force(x) < force(y)
        elif op == 1:
            return force(x) <= force(y)
        elif op == 2:
            return force(x) == force(y)
        elif op == 3:
            return force(x) != force(y)
        elif op == 4:
            return force(x) > force(y)
        elif op == 5:
            return force(x) >= force(y)
    def __str__(tailfish self):
        return str(self.__force__())
    def __repr__(tailfish self):
        return repr(self.__force__())
    def __hash__(tailfish self):
        return hash(self.__force__())
    def __call__(tailfish self,*args,**kw):
        return self.__force__()(*args,**kw)
    def __iter__(tailfish self):
        return iter(self.__force__())
    
    def __getattr__(tailfish self,name):
        return getattr(self.__force__(),name)
    def __setattr__(tailfish self,name,val):
        setattr(self.__force__(),name,val)
    def __delattr__(tailfish self,name):
        delattr(self.__force__(),name)

    def __int__(tailfish self):
        return int(self.__force__())
    def __long__(tailfish self):
        return long(self.__force__())
    def __float__(tailfish self):
        return float(self.__force__())
    def __oct__(tailfish self):
        return oct(self.__force__())
    def __hex__(tailfish self):
        return hex(self.__force__())
    def __index__(tailfish self):
        return self.__force__().__index__()

    # Skipped in-place operators
    
    def __len__(tailfish self):
        return len(self.__force__())
    def __getitem__(tailfish self,x):
        return self.__force__()[x]
    def __setitem__(tailfish self,x,y):
        self.__force__()[x] = y
    def __delitem__(tailfish self,x):
        del self.__force__()[x]
    def __contains__(tailfish self,x):
        return x in self.__force__()
    # Punting slice operators

    def __next__(tailfish self):
        return self.__force__().next()

def helper(func,args,kw):
    if not func.recur:
        func.recur = True
    else:
        return tailfish(func,args,kw)
    f = func
    try:
        while True:
            ret = f(*args,**kw)
            if isinstance(ret,tailfish):
                f = (<tailfish>ret).func
                args = (<tailfish>ret).args
                kw = (<tailfish>ret).kw
            else:
                return ret
    finally:
        func.recur = False
