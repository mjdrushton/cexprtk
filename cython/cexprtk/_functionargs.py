import inspect
import collections

def _isFunction(callable_):
  return isinstance(callable_, collections.Callable)

def _isCallable(callable_):
  return hasattr(callable_, '__call__') and not inspect.isfunction(callable_)

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

  isc = _isCallable(callable_)
  if isc:
    callable_ = getattr(callable_, '__call__')

  argspec = inspect.getargspec(callable_)

  if argspec.varargs:
    return -1

  if not argspec.keywords is None:
    raise TypeError("Functions with keywords are not supported.")

  numargs = len(argspec.args)
  if isc:
    numargs -= 1

  return numargs