from setuptools import setup
from Cython.Build import cythonize

setup(
    name='Trachtenberg Bot',
    ext_modules=cythonize("start.pyx"),
)
