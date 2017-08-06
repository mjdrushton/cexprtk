from libcpp cimport bool
from libcpp.string cimport string

cimport exprtk

ctypedef (bool (*)(string&, PythonCallableUnknownSymbolResolverReturnTuple&, void*)) PythonCallableCythonFunctionPtr

cdef extern from "cexprtk_unknown_symbol_resolver.hpp":
  cdef cppclass PythonCallableUnknownSymbolResolverReturnTuple:
    bool handledFlag
    int usrSymbolType
    double value
    string errorString
    void* pyexception
    
  cdef cppclass PythonCallableUnknownSymbolResolver:
    PythonCallableUnknownSymbolResolver(void *, PythonCallableCythonFunctionPtr)
    bool wasExceptionRaised() const
    void* exception()

cdef extern from *:
    exprtk.parser[double].unknown_symbol_resolver* dynamic_cast_PythonCallableUnknownSymbolResolver "dynamic_cast<exprtk::parser<double>::unknown_symbol_resolver*>" (PythonCallableUnknownSymbolResolver*) except NULL
