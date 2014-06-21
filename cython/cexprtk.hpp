#ifndef EXPRTKWRAP_HPP
#define EXPRTKWRAP_HPP

#include <string>
#include <vector>
#include <utility>
#include <sstream>

#include "Python.h"

#include "exprtk.hpp"

struct PythonCallableReturnTuple;


typedef std::pair<std::string, double> LabelFloatPair;
typedef std::vector<LabelFloatPair> LabelFloatPairVector;
typedef std::vector<exprtk::parser_error::type> ErrorList;
typedef double ExpressionValueType;
typedef exprtk::parser<ExpressionValueType> Parser;
typedef exprtk::expression<ExpressionValueType> Expression;
typedef Parser::unknown_symbol_resolver Resolver;
typedef exprtk::symbol_table<ExpressionValueType> SymbolTable;

typedef bool (*PythonCallableCythonFunctionPtr)(const std::string& sym, PythonCallableReturnTuple&, void * pyobj);

struct PythonCallableReturnTuple
{	
	bool handledFlag;
	Resolver::symbol_type usrSymbolType;
	ExpressionValueType  value;
	std::string errorString;
	void * pyexception;
};

class PythonCallableUnknownResolver: public virtual Resolver
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

	PythonCallableUnknownResolver(void * pycallable, PythonCallableCythonFunctionPtr cythonfunc) :
		_pycallable(pycallable),
		_cythonfunc(cythonfunc),
		_pyexception(NULL)
	{};


	virtual bool process (const std::string & s, 
		Resolver::symbol_type & st, 
		ExpressionValueType & default_value, 
		std::string & error_message)
	{
		if (wasExceptionRaised())
		{
			error_message = "exception_raised";
			return false;
		}

		PythonCallableReturnTuple pyvals;
		pyvals.pyexception = NULL;
		_cythonfunc(s, pyvals, _pycallable);

		// Unpack values from pyvals into references passed to this method.
		st = pyvals.usrSymbolType;
		default_value = pyvals.value;
		error_message = pyvals.errorString;

		if (pyvals.pyexception)
		{
			_pyexception = pyvals.pyexception;
			return false;
		}

		return pyvals.handledFlag;
	};

	virtual bool wasExceptionRaised() const
	{
		return _pyexception != NULL;
	};

	virtual void * exception() 
	{
		return _pyexception;
	};

	virtual ~PythonCallableUnknownResolver(){
		// Make sure reference held to _pyexception is decremented.
		PyObject* pyobjptr = static_cast<PyObject*>(_pyexception);
		Py_XDECREF(pyobjptr);
	};

};



void errorlist_to_strings(const ErrorList& error_list, std::vector<std::string>& outlist)
{
	std::ostringstream sbuild;
	exprtk::parser_error::type error;
	for (ErrorList::const_iterator it = error_list.begin(); it != error_list.end(); ++it)
	{
		error = *it;

		sbuild << error.diagnostic;
		sbuild << exprtk::parser_error::to_str(error.mode);
        if (error.mode == exprtk::parser_error::e_lexer)
        {	
	        sbuild << " (token: " << exprtk::lexer::token::to_str(error.token.type);
	        sbuild << " '" << error.token.value << "' ";
	        sbuild << " at pos:" << error.token.position << ")";
		}
		outlist.push_back(sbuild.str());
		sbuild.str("");
	}
}


void parser_compile_and_process_errors(const std::string& expression_string, Parser& parser, Expression& expression, std::vector<std::string>& error_messages)
{
   if (!parser.compile(expression_string,expression))
   {
      ErrorList error_list;
      exprtk::parser_error::type error;
      std::size_t ecount = parser.error_count();
      if (ecount)
      {
	      for (int i =0; i < ecount; ++i )
	      {
	         error = parser.get_error(i);
	         error_list.push_back(error);
	      }
	      errorlist_to_strings(error_list, error_messages);
  	  }
  	  else
  	  {
  	  	// A compilation error has been encountered (parser.compile evaluates as false)
  	  	// but error_count is still 0. For python wrapper to throw ParseException, something
  	  	// needs to be in error_messages, add a generic message now.
  	  	error_messages.push_back("Expression compilation error");
  	  }
   }
}


void check(const std::string& expression_string, std::vector<std::string>& error_list)
{
	Parser parser;
	Expression expression;
	parser.enable_unknown_symbol_resolver();
	parser_compile_and_process_errors(expression_string, parser, expression, error_list);
}


// Cython doesn't accept references as lvalues, provide this function to 
// enable variableAssignment
inline bool variableAssign(SymbolTable& symtable, const std::string& name, double value)
{
	exprtk::details::variable_node<double> * vp;
	if (! (vp = symtable.get_variable(name)))
	{
		return false;
	}


	if (symtable.is_constant_node(name))
	{
		return false;
	}
	vp->ref() = value;
	return true;
};	

#endif