from libcpp.pair cimport pair
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

ctypedef pair[string,double] LabelFloatPair
ctypedef vector[LabelFloatPair] LabelFloatPairVector

ctypedef pair[string,string] LabelStringPair
ctypedef vector[LabelStringPair] LabelStringPairVector

cdef extern from "exprtk.hpp" namespace "exprtk::details":
  cdef cppclass variable_node[T]:
    T& ref()
    T value()

  cdef cppclass stringvar_node[T]:
    string& ref()
    T value()

ctypedef variable_node[double] variable_t
ctypedef variable_t * variable_ptr

ctypedef stringvar_node[double] stringvar_t
ctypedef stringvar_t* stringvar_ptr

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
    bool is_stringvar(string& variable_name)
    bool remove_function(string& function_name)
    ifunction[T]* get_function(string& function_name)
    bool create_variable(string& variable_name, T& value)
    bool create_stringvar(string& variable_name, string& value)
    bool get_variable_list(LabelFloatPairVector& vlist)
    bool get_stringvar_list(LabelStringPairVector& vlist)

    int variable_count()
    ivararg_function[T]* get_vararg_function(string& vararg_function_name)
    variable_ptr get_variable(string& variable_name)
    stringvar_ptr get_stringvar(string& variable_name)

  cdef cppclass type_store[T]:
    type_store() except +
    int size
    int type
    cppclass scalar_view:
      scalar_view(type_store[T]& ts) except +
      T& v_
    cppclass type_view[ViewType]:
      type_view(type_store[T]& ts) except +
      int size()
      ViewType& operator[](int& i)
      ViewType* data_
    ctypedef type_view[T] vector_view
    ctypedef type_view[char] string_view

  cdef string to_str(type_store[double].string_view& view)

  cdef cppclass results_context[T]:
    results_context() except +
    int count()
    type_store[T] operator[](int& index)

  cdef cppclass expression[T]:
    expression() except +
    void register_symbol_table(symbol_table[T])
    T value()
    results_context[T] results()

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
ctypedef results_context[double] results_context_type
ctypedef type_store[double] type_store_type
