#ifndef EXPRTKWRAP_HPP
#define EXPRTKWRAP_HPP

#include <string>
#include <vector>
#include <utility>
#include <sstream>

#include "exprtk.hpp"


typedef std::pair<std::string, double> LabelFloatPair;
typedef std::vector<LabelFloatPair> LabelFloatPairVector;
typedef std::vector<exprtk::parser_error::type> ErrorList;
typedef double ExpressionValueType;
typedef exprtk::parser<ExpressionValueType> Parser;
typedef exprtk::expression<ExpressionValueType> Expression;
typedef Parser::unknown_symbol_resolver Resolver;
typedef exprtk::symbol_table<ExpressionValueType> SymbolTable;


class UnknownResolver: public virtual Resolver
{
public:
	virtual bool process (const std::string & s, 
		Resolver::symbol_type & st, 
		ExpressionValueType & default_value, 
		std::string & error_message)
	{
		st = e_constant_type;
		default_value = 1.0;
		return true;
	};

	virtual ~UnknownResolver(){};

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
	UnknownResolver resolver;
	parser.enable_unknown_symbol_resolver(&resolver);
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