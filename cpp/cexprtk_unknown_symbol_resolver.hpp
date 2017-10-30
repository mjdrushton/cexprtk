#ifndef CEXPRTK_UNKNOWN_SYMBOL_RESOLVER_HPP
#define CEXPRTK_UNKNOWN_SYMBOL_RESOLVER_HPP
#include "cexprtk_common.hpp"

#include "Python.h"


struct PythonCallableUnknownSymbolResolverReturnTuple
{	
	bool handledFlag;
	Resolver::usr_symbol_type usrSymbolType;
	ExpressionValueType  value;
	std::string errorString;
	void * pyexception;
};

typedef bool (*PythonCallableCythonFunctionPtr)(const std::string& sym, PythonCallableUnknownSymbolResolverReturnTuple&, void * pyobj);

/** Class fulfilling the exprtk USR interface and holds a pointer to a python
		callable. Calling this object's process() method invokes the wrapped
		python callable whilst handling any exception raised by the python function.**/
class PythonCallableUnknownSymbolResolver: public virtual Resolver
{
private:

	void * _pycallable;

	// Function pointer to cythonised function that takes
	// the actual python object (stored in void pointer, _pycallable)
	// and callback arguments.
	// It converts _pycallable back into a python object then calls it.
	PythonCallableCythonFunctionPtr _cythonfunc;
	
	// Field that can hold pointer to a python exception thrown within _cythonfunc
	// this is checked between process() calls.
	// If an exception is raised then, subsequent calls will lead to process() flagging an
	// error.
	// When control returns  to cexprtk.Expression, if the exception is set, it is thrown 
	// on the python side of things.
	void * _pyexception;

public:

	PythonCallableUnknownSymbolResolver(void * pycallable, PythonCallableCythonFunctionPtr cythonfunc) :
		_pycallable(pycallable),
		_cythonfunc(cythonfunc),
		_pyexception(NULL)
	{}

	virtual bool process (const std::string & s, 
		Resolver::usr_symbol_type & st, 
		ExpressionValueType & default_value, 
		std::string & error_message);

	virtual bool wasExceptionRaised() const;

	virtual void * exception();

	virtual ~PythonCallableUnknownSymbolResolver();
};

#endif