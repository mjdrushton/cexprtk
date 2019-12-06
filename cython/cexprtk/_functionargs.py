import inspect
# import collections
import functools

if hasattr(inspect, 'getfullargspec'):
  # Python 3

  def _argspec(callable_):
    return inspect.getfullargspec(callable_)

  def _partialArgs(callable_):
    argspec = _argspec(callable_)
    if argspec.varargs:
      return -1
    numargs = len(argspec.args)
    return numargs

  from collections.abc import Callable

else:
  # Python 2.7

  def _argspec(callable_):
    return inspect.getargspec(callable_)

  def _partialArgs(callable_):
    argspec = _argspec(callable_.func)
    if argspec.varargs:
      return -1
    numargs = len(argspec.args)
    numargs -= len(callable_.args)
    return numargs

  from collections import Callable

def _isPartial(callable_):
  return isinstance(callable_, functools.partial)

def _isFunction(callable_):
  return isinstance(callable_, Callable)

def _isCallable(callable_):
  return hasattr(callable_, '__call__') and not inspect.isfunction(callable_)

def _callableArgs(callable_):
  callable_ = getattr(callable_, '__call__')
  argspec = _argspec(callable_)
  if argspec.varargs:
    return -1
  numargs = len(argspec.args)
  numargs -= 1
  return numargs

def _genericArgs(callable_):
  argspec = _argspec(callable_)
  if argspec.varargs:
    return -1
  numargs = len(argspec.args)
  return numargs



def functionargs(callable_):
  """Return the number of arguments taken by callable or -1 if callable 
  is a varargs function.

  Args:
    callable_ : Callable object to be checked

  Raises:
    TypeError : If `callable` isn't a function, builtin or callable object raise `TypeError`.
  """
  if not _isFunction(callable_):
    raise TypeError("Argument was not a function: "+str(callable_))

  if inspect.isbuiltin(callable_):
    raise TypeError("Cannot use builtin functions: "+str(callable_))

  if _isPartial(callable_):
    return _partialArgs(callable_)
  elif _isCallable(callable_):
    return _callableArgs(callable_)
  else:
    return _genericArgs(callable_)