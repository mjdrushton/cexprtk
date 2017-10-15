import unittest

import cexprtk
from cexprtk import VariableNameShadowException, ReservedFunctionShadowException
from cexprtk._functionargs import functionargs

class FunctionsTestCase(unittest.TestCase):

  # def testNullaryFunction(self):
  #   """Test function that takes no arguments"""
  #   #TODO: Test something like "foo() + 1"
  #   #TODO: Make sure that the "foo + 1" style of function invocation is disabled
    
  #   symbol_table = cexprtk.Symbol_Table({})

  #   def f():
  #     return 1.0

  #   with self.assertRaises(TypeError):
  #     symbol_table.functions["f"] = f


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

  def testShadowingOfReservedFunction(self):
    """Test that reserved function names cannot be overwritten"""

    symbol_table = cexprtk.Symbol_Table({})
    expression = cexprtk.Expression("exp(2)", symbol_table)
    self.assertAlmostEqual(7.3890560989, expression.value())

    import math

    def f(a):
      return math.exp(a) + 1

    symbol_table = cexprtk.Symbol_Table({})
    with self.assertRaises(ReservedFunctionShadowException):
      symbol_table.functions['exp'] = f


  def testCallableAsFunction(self):
    """Test that objects that implement __call__ can be used as functions in expressions"""

    class Callable(object):

      def __call__(self, a):  
        return a + 4.1

    c = Callable()
    symbol_table = cexprtk.Symbol_Table({})
    symbol_table.functions['f'] = c
    expression = cexprtk.Expression("f(1)", symbol_table)
    self.assertAlmostEquals(5.1, expression.value())


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

  def testFunctionAlreadyExists(self):
    """Test that a pre-existing function cannot be overwritten if it is in use"""
    st = cexprtk.Symbol_Table({})    
    
    def f1(a):
      return 1

    def f2(a,b):
      return 1

    st.functions["f"] = f1
    self.assertEqual(1, st.functions["f"](100))

    # Function isn't registered with expression changing should work at this point.
    with self.assertRaises(KeyError):
      st.functions["f"] = f2


class FunctionSignatureTestCase(unittest.TestCase):
  """Test introspection of functions"""

  def testNotFunc(self):
    """Test for bad functions"""

    with self.assertRaises(TypeError):
      functionargs(None)

    with self.assertRaises(TypeError):
      functionargs(1.0)

    with self.assertRaises(TypeError):
      functionargs("a")

    with self.assertRaises(TypeError):
      functionargs(object())

    with self.assertRaises(TypeError):
      functionargs(sum)

  def testVarArgs(self):
    class VarArg(object):
      def __call__(self, *args):
        pass

    cb = VarArg()

    def f(*args):
      pass

    self.assertEquals(-1, functionargs(cb))
    self.assertEquals(-1, functionargs(f))

  def testManyArguments(self):
    class Many(object):
      def __call__(self, a,b,c,d,e,f,g):
        pass

    cb = Many()

    def f(a,b,c,d,e,f,g):
      pass

    self.assertEquals(7, functionargs(cb))
    self.assertEquals(7, functionargs(f))

  def testBinaryFunction(self):
    class Binary(object):
      def __call__(self, a,b):
        pass

    cb = Binary()

    def f(a,b):
      pass

    self.assertEquals(2, functionargs(cb))
    self.assertEquals(2, functionargs(f))

  def testUnaryFunction(self):
    class Unary(object):
      def __call__(self, a):
        pass

    cb = Unary()

    def f(a):
      pass

    self.assertEquals(1, functionargs(cb))
    self.assertEquals(1, functionargs(f))

  def testNullary(self):
    class Unary(object):
      def __call__(self):
        pass

    cb = Unary()

    def f():
      pass  

    self.assertEquals(0, functionargs(cb))
    self.assertEquals(0, functionargs(f))