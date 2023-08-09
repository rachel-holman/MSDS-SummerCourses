from setuptools import setup, find_packages

setup(name='bookPackage',
      version='1.0',
      url='https://github.com/rachel-holman/DS5100-M9Project/blob/main/bookPackage/booklover.py',
      description='A package for BookLover.',
      author='Rachel Holman',
      author_email='dnw9qk@virginia.edu',
      packages = find_packages(),
      install_requires = ['pandas', 'numpy']
     )