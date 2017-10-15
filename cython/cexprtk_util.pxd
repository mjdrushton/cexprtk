from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair
from libcpp cimport bool

cimport exprtk

cdef extern from "cexprtk.hpp":
  int variableAssign(exprtk.symbol_table_type & symtable, string& name, double value)
  void parser_compile_and_process_errors(string& expression_string, 
                                         exprtk.parser_type& parser, 
                                         exprtk.expression_type& expression, 
                                         vector[string]& error_messages)
  void check(string& expression_string, vector[string]& error_list)

