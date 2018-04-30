#ifndef EXPRTKWRAP_HPP
#define EXPRTKWRAP_HPP

#include <sstream>
#include <iostream>

#include "cexprtk_common.hpp"


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
	      for (size_t i =0; i < ecount; ++i )
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
	SymbolTable st;
	Expression expression;

	expression.register_symbol_table(st);

	Parser::unknown_symbol_resolver usr;
	// usr.mode = exprtk::parser<double>::unknown_symbol_resolver::e_usrmode_default;

	parser.enable_unknown_symbol_resolver(&usr);
	// parser.enable_unknown_symbol_resolver();
	parser_compile_and_process_errors(expression_string, parser, expression, error_list);
}

// Cython doesn't accept references as lvalues, provide this function to 
// enable variableAssignment
inline bool variableAssign(SymbolTable& symtable, const std::string& name, double value)
{
	exprtk::details::variable_node<double> * vp;
	vp = symtable.get_variable(name);
	if (!vp)
	{
		return false;
	}
	if (vp && symtable.is_constant_node(name))
	{
		return false;
	}
	vp->ref() = value;
	return true;
};	

// For some reason cython doesn't like the overloading of the symbol_table.add_function
// hence this helper function and add_varargfunction
bool add_function(SymbolTable& st_, 
	const std::string& function_name_,  
	exprtk::ifunction<ExpressionValueType>& function_)
{
	return st_.add_function(function_name_, function_);
}

bool add_varargfunction(SymbolTable& st_, 
	const std::string& function_name_,  
	exprtk::ivararg_function<ExpressionValueType>& function_)
{
	return st_.add_function(function_name_, function_);
}

#endif