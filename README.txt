cexprtk: Mathematical Expression Parsing and Evaluation in Python
=================================================================

``cexprtk`` is a cython wrapper around the "`C++ Mathematical Expression
Toolkit Library
(ExprTk) <http://www.partow.net/programming/exprtk/index.html>`__\ " by
Arash Partow. Using ``cexprtk`` a powerful mathematical expression
engine can be incorporated into your python project.

Table of Contents
-----------------

[TOC]

Installation
------------

The latest version of ``cexprtk`` can be installed using
`pip <http://www.pip-installer.org/en/latest/index.html>`__ :

.. code:: bash

        $ pip install cexprtk

**Note:** Installation requires a compatible C++ compiler to be
installed.

Usage
-----

The following examples show the major features of ``cexprtk``.

Example: Evaluate a simple equation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following shows how the arithmetic expression ``(5+5) * 23`` can be
evaluated:

.. code:: python

        >>> import cexprtk
        >>> cexprtk.evaluate_expression("(5+5) * 23", {})
        230.0

Example: Using Variables
~~~~~~~~~~~~~~~~~~~~~~~~

Variables can be used within expressions by passing a dictionary to the
``evaluate_expression`` function. This maps variable names to their
values. The expression from the previous example can be re-calculated
using variable values:

.. code:: python

        >>> import cexprtk
        >>> cexprtk.evaluate_expression("(A+B) * C", {"A" : 5, "B" : 5, "C" : 23})
        230.0

Example: Re-using expressions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When using the ``evaluate_expression()`` function, the mathematical
expression is parsed, evaluated and then immediately thrown away. This
example shows how to re-use an ``Expression`` for multiple evaluations.

-  An expression will be defined to calculate the circumference of
   circle, this will then be re-used to calculate the value for several
   different radii.
-  First a ``Symbol_Table`` is created containing a variable ``r`` (for
   radius), it is also populated with some useful constants such as π.

   .. code:: python

           >>> import cexprtk
           >>> st = cexprtk.Symbol_Table({'r' : 1.0}, add_constants= True)

-  Now an instance of ``Expression`` is created, defining our function:

   .. code:: python

           >>> circumference = cexprtk.Expression('2*pi*r', st)

-  The ``Symbol_Table`` was initialised with ``r=1``, the expression can
   be evaluated for this radius simply by calling it:

   .. code:: python

           >>> circumference()
           6.283185307179586

-  Now update the radius to a value of 3.0 using the dictionary like
   object returned by the ``Symbol_Table``'s ``.variables`` property:

   .. code:: python

           >>> st.variables['r'] = 3.0
           >>> circumference()
           18.84955592153876

Example: Defining an unknown symbol resolver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A callback can be passed to the ``Expression`` constructor through the
``unknown_symbol_resolver_callback`` parameter. This callback is invoked
during expression parsing when a variable or constant is encountered
that isn't in the ``Symbol_Table`` associated with the ``Expression``.

The callback can be used to provide some logic that leads to a new
symbol being registered or for an error condition to be flagged.

**The Problem:** The following example shows a potential use for the
symbol resolver:

-  An expression contains variables of the form ``m_VARIABLENAME`` and
   ``f_VARIABLENAME``.
-  ``m_`` or ``f_`` prefix the actual variable name (perhaps indicating
   gender).
-  ``VARIABLENAME`` should be used to look up the desired value in a
   dictionary.
-  The dictionary value of ``VARIABLENAME`` should then be weighted
   according to its prefix:

   -  ``m_`` variables should be multiplied by 0.8.
   -  ``f_`` variables should be multiplied by 1.1.

**The Solution:**

-  First the ``VARIABLENAME`` dictionary is defined:

   .. code:: python

       variable_values = { 'county_a' : 82, 'county_b' : 76}

-  Now the callback is defined. This takes a single argument, *symbol*,
   which gives the name of the missing variable found in the expression:

   .. code:: python


       def callback(symbol):
           # Tokenize the symbol name into prefix and VARIABLENAME components.
           prefix,variablename = symbol.split("_", 1)
           # Get the value for this VARIABLENAME from the variable_values dict
           value = variable_values[variablename]
           # Find the correct weight for the prefix
           if prefix == 'm':
               weight = 0.8
           elif prefix == 'f':
               weight = 1.1
           else:
               # Flag an error condition if prefix not found.
               errormsg = "Unknown prefix "+ str(prefix)
               return (False, cexprtk.USRSymbolType.VARIABLE, 0.0, errormsg)
           # Apply the weight to the 
           value *= weight
           # Indicate success and return value to cexprtk
           return (True, cexprtk.USRSymbolType.VARIABLE, value, "")

-  All that remains is to register the callback with an instance of
   ``Expression`` and to evaluate an expression. The expression to be
   evaluated is:

   -  ``(m_county_a - f_county_b)``
   -  This should give a value of ``(0.8*82) - (1.1*76) = -18``

   .. code:: python

           >>> st = cexprtk.Symbol_Table({})
           >>> e = cexprtk.Expression("(m_county_a - f_county_b)", st, callback)
           >>> e.value()
           -18.0

--------------

API Reference
-------------

For information about expressions supported by ``cexprtk`` please refer
to the original C++
`ExprTK <http://www.partow.net/programming/exprtk/index.html>`__
documentation:

Class Reference
~~~~~~~~~~~~~~~

class Expression:
^^^^^^^^^^^^^^^^^

Class representing mathematical expression.

-  Following instantiation, the expression is evaluated calling the
   expression or invoking its ``value()`` method.
-  The variable values used by the Expression can be modified through
   the ``variables`` property of the ``Symbol_Table`` instance
   associated with the expression. The ``Symbol_Table`` can be accessed
   using the ``Expression.symbol_table`` property.

Defining unknown symbol-resolver:
                                 

The ``unknown_symbol_resolver_callback`` argument to the ``Expression``
constructor accepts a callable which is invoked whenever a symbol (i.e.
a variable or a constant), is not found in the ``Symbol_Table`` given by
the ``symbol_table`` argument. The ``unknown_symbol_resolver_callback``
can be used to provide a value for the missing value or to set an error
condition.

The callable should have following signature:

.. code:: python

        def callback(symbol_name):
            ...

Where ``symbol_name`` is a string identifying the missing symbol.

The callable should return a tuple of the form:

.. code:: python

        (HANDLED_FLAG, USR_SYMBOL_TYPE, SYMBOL_VALUE, ERROR_STRING)

Where:

-  ``HANDLED_FLAG`` is a boolean:

   -  ``True`` indicates that callback was able handle the error
      condition and that ``SYMBOL_VALUE`` should be used for the missing
      symbol.
   -  ``False``, flags and error condition, the reason why the unknown
      symbol could not be resolved by the callback is described by
      ``ERROR_STRING``.

-  ``USR_SYMBOL_TYPE`` gives type of symbol (constant or variable) that
   should be added to the ``symbol_table`` when unkown symbol is
   resolved. Value should be one of those given in
   ``cexprtk.USRSymbolType``. e.g.

   -  ``cexprtk.USRSymbolType.VARIABLE``
   -  ``cexprtk.USRSymbolType.CONSTANT``

-  ``SYMBOL_VALUE``, floating point value that should be used when
   resolving missing symbol.
-  ``ERROR_STRING`` when ``HANDLED_FLAG`` is ``False`` this can be used
   to describe error condition.

def **init**\ (self, *expression*, *symbol\_table*, *unknown\_symbol\_resolver\_callback* = None):
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Instantiate ``Expression`` from a text string giving formula and
``Symbol_Table`` instance encapsulating variables and constants used by
the expression.

**Parameters:**

-  **expression** (*str*) String giving expression to be calculated.
-  **symbol\_table** (*Symbol\_Table*) Object defining variables and
   constants.
-  **unknown\_symbol\_resolver\_callback** (*callable*) See description
   above.

def value(self):
''''''''''''''''

Evaluate expression using variable values currently set within
associated ``Symbol_Table``

**Returns:**

-  (*float*) Value resulting from evaluation of expression.

def **call**\ (self):
'''''''''''''''''''''

Equivalent to calling ``value()`` method.

**Returns:**

-  (*float*) Value resulting from evaluation of expression.

symbol\_table
'''''''''''''

Read only property that returns ``Symbol_Table`` instance associated
with this expression.

**Returns:**

-  (*Symbol\_Table*) ``Symbol_Table`` associated with this
   ``Expression``.

--------------

class Symbol\_Table:
^^^^^^^^^^^^^^^^^^^^

Class for providing variable and constant values to ``Expression``
instances.

def **init**\ (self, *variables*, *constants* = {}, *add\_constants* = False):
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Instantiate ``Symbol_Table`` defining variables and constants for use
with ``Expression`` class.

**Example:**

-  To instantiate a ``Symbol_Table`` with:

   -  ``x = 1``
   -  ``y = 5``
   -  define a constant ``k = 1.3806488e-23``

-  The following code would be used:

   .. code:: python

           st = cexprtk.Symbol_Table({'x' : 1, 'y' : 5}, {'k'= 1.3806488e-23})

**Parameters:**

-  **variables** (*dict*) Mapping between variable name and initial
   variable value.
-  **constants** (*dict*) Dictionary containing values that should be
   added to ``Symbol_Table`` as constants. These can be used a variables
   within expressions but their values cannot be updated following
   ``Symbol_Table`` instantiation.
-  **add\_constants** (*bool*) If ``True``, add the standard constants
   ``pi``, ``inf``, ``epsilon`` to the 'constants' dictionary before
   populating the ``Symbol_Table``

variables
'''''''''

Returns dictionary like object containing variable values.
``Symbol_Table`` values can be updated through this object.

**Example:**

.. code:: python

        >>> import cexprtk
        >>> st = cexprtk.Symbol_Table({'x' : 5, 'y' : 5})
        >>> expression = cexprtk.Expression('x+y', st)
        >>> expression()
        10.0

Update the value of ``x`` in the symbol table and re-evaluate the
expression:

.. code:: python

        >>> expression.symbol_table.variables['x'] = 11.0
        >>> expression()
        16.0

**Returns:**

-  Dictionary like giving variables stored in this ``Symbol_Table``.
   Keys are variables names and these map to variable values.

constants
'''''''''

Property giving constants stored in this ``Symbol_Table``.

**Returns:**

-  Read-only dictionary like object mapping constant names stored in
   ``Symbol_Table`` to their values.

--------------

class USRSymbolType:
^^^^^^^^^^^^^^^^^^^^

Defines constant values used to determine symbol type returned by
``unknown_symbol_resolver_callback`` (see ``Expression`` constructor
documentation for more).

VARIABLE
''''''''

Value that should be returned by an ``unknown_symbol_resolver_callback``
to define a variable.

CONSTANT
''''''''

Value that should be returned by an ``unknown_symbol_resolver_callback``
to define a constant.

--------------

Utility Functions
~~~~~~~~~~~~~~~~~

def check\_expression (*expression*)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check that expression can be parsed. If successful do nothing, if
unsuccessful raise ``ParseException``.

**Parameters:**

-  *expression* (*str*) Formula to be evaluated

**Raises:**

-  ``ParseException``: If expression is invalid.

def evaluate\_expression (*expression*, *variables*)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Evaluate a mathematical formula using the exprtk library and return
result.

For more information about supported functions and syntax see the
`exprtk C++ library
website <http://www.partow.net/programming/exprtk/index.html>`__.

**Parameters:**

-  **expression** (*str*) Expression to be evaluated.
-  **variables** (*dict*) Dictionary containing variable name, variable
   value pairs to be used in expression.

**Returns:**

-  (*float*): Evaluated expression

**Raises:**

-  ``ParseException``: if *expression* is invalid.

--------------

Authors
-------

Cython wrapper by Michael Rushton (m.j.d.rushton@gmail.com), although
most credit should go to Arash Partow for creating the underlying
`ExprTK <http://www.partow.net/programming/exprtk/index.html>`__
library.

License
-------

``cexprtk`` is released under the same terms as the
`ExprTK <http://www.partow.net/programming/exprtk/index.html>`__ library
the `Common Public License Version
1.0 <http://opensource.org/licenses/cpl1.0.php>`__ (CPL).
