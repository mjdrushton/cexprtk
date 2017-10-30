"""Script that generates the callbacks the twenty callbacks in custom_function_callbacks.pyx"""

HEADER = """# distutils: language = c++
from cpython.ref cimport Py_INCREF
cimport cexprtk_custom_functions_implementation
from cexprtk_custom_functions cimport CustomFunctionBase
from cexprtk_custom_vararg_function cimport Custom_Vararg_Function
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef double callback_vararg(
    void * pyobj_, void ** exception_, const vector[double]& args_):
  cdef object pycallable
  cdef double retval = 0.0

  try:
    pycallable = <object>pyobj_
    retval = pycallable(*args_)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
"""

import os

TEMPLATE="""cdef double {funcname}(
    void * pyobj_, void ** exception_{args}):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable({pyargs})
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
"""

WRAPFUNCTION_TEMPLATE = """
cdef CustomFunctionBase* wrapFunction(int numargs_, string& key_, object pycallable_):
  cdef void* pyptr = <void *> pycallable_
  cdef CustomFunctionBase* retval = NULL
  if numargs_ == -1:
    retval = new Custom_Vararg_Function(key_, pyptr, callback_vararg)
{if_statements:s}

  return retval
"""

IF_STATEMENT_TEMPLATE = """  {ifs} numargs_ == {numargs:d}:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_{numargs:d}(key_, pyptr, callback_{numargs:d}) """


def writeCallback(numargs, outfile):
  funcname = "callback_{:d}".format(numargs)

  args = [ "arg_{:d}".format(i) for i in range(1, numargs+1) ]
  
  if args:
    pyargs = ", ".join(args)
    args = ", " + ", ".join(["double " + arg for arg in args])
  else:
    pyargs = ""
    args = ""

  templatedata = dict(funcname = funcname, args = args, pyargs = pyargs)
  outfile.write(TEMPLATE.format(**templatedata))

def writeWrapFunction(maxargs, outfile):
  ifstatements = []
  ifs = "elif"
  for i in range(maxargs):
    ifstatement = IF_STATEMENT_TEMPLATE.format(numargs = i, ifs = ifs)
    ifstatements.append(ifstatement)
    # ifs = "elif"
  ifstatements = os.linesep.join(ifstatements)
  outfile.write(WRAPFUNCTION_TEMPLATE.format(if_statements = ifstatements))

def main():
  dirname = os.path.dirname(__file__)
  filename = os.path.join(dirname, "cexprtk", "_custom_function_callbacks.pyx")
  maxargs = 21
  with open(filename, 'w') as outfile:
    outfile.write(HEADER)
    for i in range(maxargs):
      writeCallback(i, outfile)
    writeWrapFunction(maxargs, outfile)

if __name__ == '__main__':
  main()