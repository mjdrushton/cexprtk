import os

HEADER = """#ifndef GENERATE_CUSTOM_FUNCTIONS_IMPLEMENTATION
#define GENERATE_CUSTOM_FUNCTIONS_IMPLEMENTATION
#include "cexprtk_custom_functions.hpp"
"""

FOOTER = """#endif
"""

CLASS_TEMPLATE = """

class {classname:s} : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{{

private:
    {classname:s}();
public:
    typedef {function_signature:s};

protected:
    FunctionType _cythonfunc;

public:

    {classname:s}( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>({num_args:d}), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {{
    set_pycallable(pycallable_);
  }}

  {method:s}

  virtual ~{classname:s}(){{ }}

}};  
"""

#const ExpressionValueType& a1,const ExpressionValueType& a2
METHOD_TEMPLATE = """virtual ExpressionValueType operator()({sig_args:s})
{{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {{
    return retval;
  }}
  retval = _cythonfunc(_pycallable, &_pyexception {callable_args:s});
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}}
"""

#  CustomFunction_0( 
#                  const std::string &key_,
#                  void *pycallable_,
#                  FunctionType cythonfunc_)

PXD_TEMPLATE = """

  cdef cppclass {classname:s}(CustomFunctionBase):
    {classname:s}(string& key_, void * pycallable_, ({function_signature:s}) cythonfunc_)
"""

FUNCTION_SIGNATURE_TEMPLATE = "{valueType:s} (*{functionType:s})(void *, void ** {args})"

def makeFunctionSignature(i, valueType = "ExpressionValueType", functionType = "FunctionType"):
  args = [valueType] * i
  args = ",".join(args)
  if args:
    args = ", " + args
  return FUNCTION_SIGNATURE_TEMPLATE.format(args = args, valueType = valueType, functionType = functionType)


def makeMethod(i):
  args = [ "a{:d}".format(j) for j in range(1, i+1)]
  sigargs = [ "const ExpressionValueType& {}".format(arg) for arg in args]
  sigargs = ",".join(sigargs)
  args = ",".join(args)

  if args:
    sigargs = sigargs 
    args = ", " + args 

  return METHOD_TEMPLATE.format(callable_args= args, sig_args = sigargs)

def writePXDClass(outfile, i):
    outfile.write(PXD_TEMPLATE.format(
    classname = "CustomFunction_{:d}".format(i), 
    function_signature = makeFunctionSignature(i, "double", "")
  ))

def writeClass(outfile, i):
  outfile.write(CLASS_TEMPLATE.format(
    classname = "CustomFunction_{:d}".format(i), 
    method = makeMethod(i),
    num_args = i,
    function_signature = makeFunctionSignature(i)
  ))

def main():
  dirname = os.path.dirname(__file__)
  cppdirname = os.path.join(dirname, os.path.pardir, "cpp")
  ibase = "cexprtk_custom_functions_implementation"
  filename = os.path.join(cppdirname, ibase + ".hpp")
  maxargs = 21
  with open(filename, 'w') as outfile:
    outfile.write(HEADER)
    for i in range(maxargs):
      writeClass(outfile, i)
    outfile.write(FOOTER)

  pxd_filename = os.path.join(dirname, ibase + ".pxd")

  with open(pxd_filename,'w') as outfile:
    outfile.write("# distutils: language = c++\n")
    outfile.write("from libcpp.string cimport string\n")
    outfile.write("from cexprtk_custom_functions cimport CustomFunctionBase\n")
    outfile.write('cdef extern from "{}":\n'.format(ibase+".hpp"))
    for i in range(maxargs):
      writePXDClass(outfile, i)

if __name__ == '__main__':
  main()