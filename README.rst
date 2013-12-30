******************************************************************
cexprtk: mathematical expression parsing and evaluation in python
******************************************************************

cexprtk is a cython wrapper around "`C++ Mathematical Expression  Toolkit Library (ExprTk) <ExprTk_>`_ "  by Arash Partow. Using ``cexprtk`` a powerful mathematical expression engine can be incorporated into your python project.


.. contents::
	:local:
	:depth: 1
	:backlinks: none


Installation
============

The latest version of ``cexprtk`` can be installed using `pip`_ :

.. code-block:: bash

	$ pip install cexprtk

.. note:: Installation requires a compatible C++ compiler to be installed.


Usage
=====

The ``cexprtk`` module contains two functions check_expression_ and evaluate_expression_; the first can be used validate a mathematical formula before calculating its value using the latter.

Example: Evaluate a simple equation
-----------------------------------

The following shows how the arithmetic expression ``(5+5) * 23`` can be evaluated:

.. code-block:: python

	>>> import cexprtk
	>>> cexprtk.evaluate_expression("(5+5) * 23", {})
	230.0


Example: Using Variables
------------------------

Variables can be used within expressions by passing a dictionary to the evaluate_expression_ function. This maps variable names to their values. The expression from the previous example can be re-calculated using variable values:

.. code-block:: python

	>>> import cexprtk
	>>> cexprtk.evaluate_expression("(A+B) * C", {"A" : 5, "B" : 5, "C" : 23})
	230.0


API Reference
=============

For information about expressions supported by ``cexprtk`` please refer to the original C++ `ExprTK`_ documentation:

.. _check_expression :

**check_expression** (*expression*)
	
	Check that expression can be parsed. If successful do nothing, if unsuccessful raise ParseException.

	**Parameters:**

		**expression** (*str*) Formula to be evaluated

	**Raises** ``ParseException``: If expression is invalid.	


.. _evaluate_expression :

**evaluate_expression** (*expression*, *variables*)

	Evaluate a mathematical formula using the exprtk library and return result.

	For more information about supported functions and syntax see the
	exprtk C++ library website http://code.google.com/p/exprtk/

	**Parameters:**

		**expression** (*str*) Expression to be evaluated.
		
		**variables** (*dict*) Dictionary containing variable name, variable value pairs to be used in expression.

	**Returns** (*float*): Evaluated expression

	**Raises** ``ParseException``: if **expression** is invalid.



Authors
=======

Cython wrapper by Michael Rushton (m.j.d.rushton@gmail.com), although most credit should go to Arash Partow for creating the underlying ExprTK_ library.


License
=======

``cexprtk`` is released under the same terms as the ExprTK_ library the `Common Public License Version 1.0`_ (CPL).


------------


.. _ExprTK: http://www.partow.net/programming/exprtk/index.html
.. _pip: http://www.pip-installer.org/en/latest/index.html
.. _Common Public License Version 1.0: http://opensource.org/licenses/cpl1.0.php
