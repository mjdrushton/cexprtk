#cexprtk: mathematical expression parsing and evaluation in python

`cexprtk` is a cython wrapper around the "[C++ Mathematical Expression  Toolkit Library (ExprTk)][ExprTk]"  by Arash Partow. Using `cexprtk` a powerful mathematical expression engine can be incorporated into your python project.

[TOC]

##Installation

The latest version of `cexprtk` can be installed using [pip][pip] :

```bash
	$ pip install cexprtk
```

__Note:__ Installation requires a compatible C++ compiler to be installed.


##Usage

The `cexprtk` module contains two functions `check_expression` and `evaluate_expression` the first can be used validate a mathematical formula before calculating its value using the latter.

###Example: Evaluate a simple equation

The following shows how the arithmetic expression `(5+5) * 23` can be evaluated:

```python
	>>> import cexprtk
	>>> cexprtk.evaluate_expression("(5+5) * 23", {})
	230.0
```

###Example: Using Variables

Variables can be used within expressions by passing a dictionary to the [evaluate_expression][] function. This maps variable names to their values. The expression from the previous example can be re-calculated using variable values:

```python
	>>> import cexprtk
	>>> cexprtk.evaluate_expression("(A+B) * C", {"A" : 5, "B" : 5, "C" : 23})
	230.0
```

###Example: Re-using expressions
TODO: Document

###Example: Defining an unknown symbol resolver
TODO: Document

##API Reference

For information about expressions supported by `cexprtk` please refer to the original C++ [ExprTK][ExprTK] documentation:

### Class Reference

#### class Expression:
Class representing mathematical expression.

* Following instantiation, the expression is evaluated calling the expression or invoking its `value()` method.
* The variable values used by the Expression can be modified through the `variables` property of the `Symbol_Table` instance associated with the expression. The `Symbol_Table` can be accessed using the `Expression.symbol_table` property.

######Defining unknown symbol-resolver:

The `unknown_symbol_resolver_callback` argument  to the `Expression`
constructor accepts a callable which is invoked  whenever a symbol (i.e. a
variable or a constant), is not found in the `Symbol_Table` given by the
`symbol_table` argument. The `unknown_symbol_resolver_callback` can be
used to provide a value for the missing value or to set an error condition.

The callable should have following signature:

```python
	def callback(symbol_name):
		...
```

Where `symbol_name` is a string identifying the missing symbol.

The callable should return a tuple of the form:

```python
	(HANDLED_FLAG, USR_SYMBOL_TYPE, SYMBOL_VALUE, ERROR_STRING)
```

Where:

* `HANDLED_FLAG` is a boolean:
	+ `True` indicates that callback was able handle the error condition and that `SYMBOL_VALUE` should be used for the missing symbol. 
	+ `False`, flags and error condition, the reason why the unknown symbol could not be resolved by the callback is described by `ERROR_STRING`.
* `USR_SYMBOL_TYPE` gives type of symbol (constant or variable) that should be added to the `symbol_table` when unkown symbol is resolved. Value should be one of those given in `cexprtk.USRSymbolType`. e.g.
	+ `cexprtk.USRSymbolType.VARIABLE`  
	+ `cexprtk.USRSymbolType.CONSTANT`  
* `SYMBOL_VALUE`, floating point value that should be used when resolving missing symbol.
* `ERROR_STRING` when `HANDLED_FLAG` is `False` this can be used to describe error condition.

#####def __init__(self, expression, symbol_table, unknown_symbol_resolver_callback = None):
Instantiate `Expression` from a text string giving formula and `Symbol_Table`
instance encapsulating variables and constants used by the expression.

__Parameters:__

* __expression__ (*str*) String giving expression to be calculated.
* __symbol_table__ (*Symbol_Table*) Object defining variables and constants.
* __unknown_symbol_resolver_callback__ (*callable*)  See description above.

#####def value(self):
Evaluate expression using variable values currently set within associated `Symbol_Table`

__Returns:__
* (*float*) Value resulting from evaluation of expression.

#####def __call__(self):
Equivalent to calling value() method.

__Returns:__

* (*float*) Value resulting from evaluation of expression.

#####symbol_table
Read only property that returns `Symbol_Table` instance associated with this expression.

__Returns:__

* (*Symbol_Table*) `Symbol_Table` associated with this `Expression`.

---

#### class Symbol_Table:
Class for providing variable and constant values to `Expression` instances.

TODO: Example instantiation here.

#####def __init__(self, variables, constants = {}, add_constants = False):
Instantiate `Symbol_Table` defining variables and constants for use with `Expression` class.

__Parameters:__

* __variables__ (*dict*) Mapping between variable name and initial variable value.
* __constants__ (*dict*) Constant name to value dictionary.
* __add_constants__ (*bool*) If True, add the standard constants `pi`, `inf`, `epsilon` to the 'constants' dictionary before populating the `Symbol_Table`

#####variables
TODO: Document

#####constants
TODO: Document

---

####class USRSymbolType:
TODO: Document


### Utility Functions
##### check_expression (*expression*)

Check that expression can be parsed. If successful do nothing, if unsuccessful raise `ParseException`.

**Parameters:**
* *expression* (*str*) Formula to be evaluated

**Raises** `ParseException`: If expression is invalid.	


##### evaluate_expression (*expression*, *variables*)
Evaluate a mathematical formula using the exprtk library and return result.

For more information about supported functions and syntax see the
[exprtk C++ library website][ExprTk].

**Parameters:**

* *expression* (*str*) Expression to be evaluated.
* *variables* (*dict*) Dictionary containing variable name, variable value pairs to be used in expression.

**Returns** (*float*): Evaluated expression
**Raises** `ParseException`: if *expression* is invalid.

##Authors

Cython wrapper by Michael Rushton (m.j.d.rushton@gmail.com), although most credit should go to Arash Partow for creating the underlying ExprTK_ library.


##License

`cexprtk` is released under the same terms as the ExprTK_ library the `Common Public License Version 1.0`_ (CPL).


---

[ExprTK]: http://www.partow.net/programming/exprtk/index.html
[pip]: http://www.pip-installer.org/en/latest/index.html
[Common Public License Version 1.0]: http://opensource.org/licenses/cpl1.0.php
