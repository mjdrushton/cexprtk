from libcpp.pair cimport pair
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

ctypedef pair[string,double] LabelFloatPair
ctypedef vector[LabelFloatPair] LabelFloatPairVector

cdef extern from "exprtk.hpp" namespace "exprtk::details":
  cdef cppclass variable_node[T]:
    T& ref()
    T value()

ctypedef variable_node[double] variable_t
ctypedef variable_t * variable_ptr

cdef extern from "exprtk.hpp" namespace "exprtk":
  cdef cppclass function_traits:
    pass

  cdef cppclass ifunction[T](function_traits):
    ifunction(int& pc) except +

  cdef cppclass ivararg_function[T](function_traits):
    T operator()(vector[T]& args)

  cdef cppclass symbol_table[T]:
    symbol_table() except +
    bool add_constant(string& constant_name, T& value)
    bool add_constants()
    #bool add_function(string& function_name, ifunction[T]& function)
    #bool add_function(string& vararg_function_name, ivararg_function[T]& vararg_function)
    bool is_constant_node(string& symbol_name)
    bool is_vararg_function(string& vararg_function_name)
    bool is_variable(string& variable_name)
    bool remove_function(string& function_name)
    ifunction[T]* get_function(string& function_name)
    int create_variable(string& variable_name, T& value)
    int get_variable_list(LabelFloatPairVector& vlist)
    int variable_count()
    ivararg_function[T]* get_vararg_function(string& vararg_function_name)
    variable_ptr get_variable(string& variable_name)


  cdef cppclass expression[T]:
    expression() except +
    void register_symbol_table(symbol_table[T])
    T value()

  cdef cppclass parser[T]:
    parser() except +
    int compile(string& expression_string, expression[T]&  expr)
    cppclass unknown_symbol_resolver:
      pass
    void enable_unknown_symbol_resolver(unknown_symbol_resolver* usr)
    bool replace_symbol(const string& old_symbol, const string& new_symbol)

  cdef enum c_symbol_type "exprtk::parser<double>::unknown_symbol_resolver::usr_symbol_type":
    e_variable_type "exprtk::parser<double>::unknown_symbol_resolver::e_usr_variable_type"
    e_constant_type "exprtk::parser<double>::unknown_symbol_resolver::e_usr_constant_type"

ctypedef symbol_table[double] symbol_table_type
ctypedef expression[double] expression_type
ctypedef parser[double] parser_type
