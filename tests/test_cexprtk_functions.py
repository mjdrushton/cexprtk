import unittest

import cexprtk
from cexprtk import VariableNameShadowException

class FunctionsTestCase(unittest.TestCase):

  def testNullaryFunction(self):
    """Test function that takes no arguments"""
    #TODO: Test something like "foo() + 1"
    #TODO: Make sure that the "foo + 1" style of function invocation is disabled
    
    symbol_table = cexprtk.Symbol_Table({})

    def f():
      return 1.0

    with self.assertRaises(TypeError):
      symbol_table.functions["f"] = f


  def testUnaryFunction(self):
    """Test function that takes single argument"""
    symbol_table = cexprtk.Symbol_Table({})
    symbol_table.functions["plustwo"] = lambda x: x+2
    expression = cexprtk.Expression("plustwo(2)", symbol_table)
    self.assertEqual(4, expression())

    symbol_table.variables["A"] = 3.0
    expression = cexprtk.Expression("plustwo(A) + 4", symbol_table)
    self.assertEqual(3+2+4, expression())

  def testNoNameShadowing_variableExists(self):
    """Test that functions and variables don't share names (variable is set before function)"""
    symbol_table = cexprtk.Symbol_Table({"b" : 3.0})

    def func(a):
      return a

    symbol_table.variables["f"] = 2.0
    with self.assertRaises(VariableNameShadowException):
      symbol_table.functions["f"] = func

    with self.assertRaises(VariableNameShadowException):
      symbol_table.functions["b"] = func

  def testNoNameShadowing_functionExists(self):
    """Test that functions and variables don't share names (function is set before variable)"""
    symbol_table = cexprtk.Symbol_Table({})

    def func(a):
      return a

    symbol_table.functions["f"] = func
    with self.assertRaises(VariableNameShadowException):
      symbol_table.variables["f"] = 2.0

  def testNoNameShadowing_constantExists(self):
    symbol_table = cexprtk.Symbol_Table({}, {'f' : 1.0})
    with self.assertRaises(KeyError):
      symbol_table.variables['f'] = 2.0

    def func(a):
      return a

    with self.assertRaises(VariableNameShadowException):
      symbol_table.functions["f"] = func

  def testPopulateFunctionsViaConstructor(self):
    """Populate symbol_table functions using constructor argument"""

    def f(a):
      return 1

    def g(a):
      return 2

    symbol_table = cexprtk.Symbol_Table({}, functions = {"f" : f, "g" : g})
    self.assertEquals(['f', 'g'], sorted(symbol_table.functions.keys()))

    self.assertEquals(1, symbol_table.functions['f'](3))
    self.assertEquals(2, symbol_table.functions['g'](3))


  def testFunctionThatThrows(self):
    """Test a function that throws an exception"""

    class CustomException(Exception):
      pass

    def f(a):
      raise CustomException()

    symbol_table = cexprtk.Symbol_Table({}, functions = {"f" : f})
    expression = cexprtk.Expression("f(1)", symbol_table)
    with self.assertRaises(CustomException):
      expression.value()
    