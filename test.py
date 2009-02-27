#!/usr/bin/python

from tailspin import tailspin
from ltailspin import ltailspin
from ctailspin import ctailspin
from trampolined import trampolined

def test(tail):
    
    @tail
    def factorial(n, acc=1):
        "calculate a factorial"
        if n == 0:
            return acc
        return factorial(n-1, n*acc)

    assert factorial(5) == 120
    
    @tail 
    def even(n): 
        if n == 0: 
            return True 
        else: 
            return odd(n-1)

    @tail 
    def odd(n): 
        if n == 0: 
            return False 
        else: 
            return even(n-1)
    
    assert odd(3)
    assert not even(3)
    assert not odd(222)
    assert even(222)

def ftime(tail,n):
    global factorial
    @tail
    def fact(n, acc=1):
        "calculate a factorial"
        if n == 0:
            return acc
        return factorial(n-1, n*acc)
    factorial = fact

    import timeit
    return timeit.Timer('factorial(%d)'%n,
                        "from __main__ import factorial").timeit(1000)

if __name__ == '__main__':
    test(tailspin)
    test(ctailspin)
    test(trampolined)
    test(lambda f:f)
    for n in xrange(100,1000,100):
        base = ftime(lambda f:f,n)
        print "tailspin",n,ftime(tailspin,n)/base
        print "ltailspin",n,ftime(ltailspin,n)/base
        print "ctailspin",n,ftime(ctailspin,n)/base
        print "trampolined",n,ftime(trampolined,n)/base
