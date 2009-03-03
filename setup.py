#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(name='TailSpin',
      version='0.1',
      description='Efficient Tail Recursion',
      author='Xavid Pretzer',
      author_email='xavid@mit.edu',
      url='http://xavecode.mit.edu/tailspin/',
      package_dir = {'': 'src'}, 
      packages=['tailspin'],
      requires=['Cython'],
      cmdclass = {'build_ext': build_ext},
      ext_modules = [Extension("tailspin.fast_h",
                               ["src/tailspin/fast_h.pyx"]),
                     Extension("tailspin.fastlazy_h",
                               ["src/tailspin/fastlazy_h.pyx"])]
      )
