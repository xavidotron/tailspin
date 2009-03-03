import threading

cdef class tailfish:
    cdef object func
    cdef object args
    cdef object kw
    def __cinit__(self,func,args,kw):
        self.func = func
        self.args = args
        self.kw = kw
    cdef force(self):
        return self.func(*self.args,**self.kw)

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
