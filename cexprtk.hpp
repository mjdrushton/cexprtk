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
	parser.compile(expression_string,expression);

	bool isError = parser.error_count() > 0;
	if (isError)
	{
		ErrorList error_list;
		exprtk::parser_error::type error;
		for (int i =0; i < parser.error_count(); ++i )
		{
			error = parser.get_error(i);
			error_list.push_back(error);
		}
		errorlist_to_strings(error_list, error_messages);
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


ExpressionValueType evaluate(const std::string& expression_string, const LabelFloatPairVector& variables, std::vector<std::string>& error_list)
{
	exprtk::symbol_table<ExpressionValueType> symbol_table;

	// Add Variables
	for (LabelFloatPairVector::const_iterator it = variables.begin(); it != variables.end(); ++it)
	{
		const std::string & var_name = it->first;
		double var_value = it->second;
		symbol_table.add_constant( var_name, var_value);
	}

	symbol_table.add_constants();
	Expression expression;

	expression.register_symbol_table(symbol_table);
	
	Parser parser;
	parser_compile_and_process_errors(expression_string, parser, expression, error_list);

	return expression.value();
};

#endif