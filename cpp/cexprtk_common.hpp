#ifndef CEXPRTK_COMMON_HPP
#define CEXPRTK_COMMON_HPP

#include "exprtk.hpp"

#include <string>
#include <vector>
#include <utility>

typedef std::pair<std::string, double> LabelFloatPair;
typedef std::vector<LabelFloatPair> LabelFloatPairVector;
typedef std::vector<exprtk::parser_error::type> ErrorList;
typedef double ExpressionValueType;
typedef exprtk::parser<ExpressionValueType> Parser;
typedef exprtk::expression<ExpressionValueType> Expression;
typedef Parser::unknown_symbol_resolver Resolver;
typedef exprtk::symbol_table<ExpressionValueType> SymbolTable;

#endif
