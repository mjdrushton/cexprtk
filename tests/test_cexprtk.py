import unittest
import math

import cexprtk

class ExpressionTestCase(unittest.TestCase):
  """Tests for the cexprtk.Expression class"""

  def testNoVariables(self):
    """Perform test with no variables"""
    st = cexprtk.Symbol_Table({},{})
    expression = cexprtk.Expression("2+2", st)
    v = expression.value()
    self.assertAlmostEquals(4.0, v)

    v = expression()
    self.assertAlmostEquals(4.0, v)

  def testWithVariables(self):
    """Perform a test with some variables"""

    st = cexprtk.Symbol_Table({'a' : 2, 'b' : 3},{})
    expression = cexprtk.Expression("(a+b) * 3", st)
    v = expression.value()
    self.assertAlmostEquals(15.0, v)

  def testParseException(self):
    """Test that bad expressions lead to ParseException being thrown"""
    st = cexprtk.Symbol_Table({},{})

    with self.assertRaises(cexprtk.ParseException):
      expression = cexprtk.Expression("(2+2", st)


  def testSymbolTableProperty(self):
    st = cexprtk.Symbol_Table({'a' : 2, 'b' : 3},{})
    expression = cexprtk.Expression("(a+b) * 3", st)
    st = None
    v = expression.value()
    self.assertAlmostEquals(15.0, v)

    st = expression.symbol_table
    st.variables['a'] = 3.0

    v = expression()
    self.assertAlmostEquals(18.0, v)


class Symbol_TableVariablesTestCase(unittest.TestCase):
  """Tests for cexprtk._Symbol_Table_Variables"""

  def testBadVariableNames(self):
    """Test that Symbol_Table throws exceptions when instantiated with bad variable names"""
    inexpect = [
      ("a",  True),
      ("a1", True),
      ("2a", False),
      (" a", False),
      ("_a", False),
      ("a a", False),
      ("_", False)]

    for i, e in inexpect:
      if e:
        cexprtk.Symbol_Table({i : 1.0})
      else:
        with self.assertRaises(cexprtk.BadVariableException):
          cexprtk.Symbol_Table({i : 1.0})

    for i, e in inexpect:
      if e:
        cexprtk.Symbol_Table({}, {i : 1.0})
      else:
        with self.assertRaises(cexprtk.BadVariableException):
          cexprtk.Symbol_Table({}, {i : 1.0})

  def testNameShadowingException(self):
    """Test that an exception is raised if variable names and constant names overlap"""

    with self.assertRaises(cexprtk.VariableNameShadowException):
      cexprtk.Symbol_Table({"a" : 1.0, "b" : 2.0}, {"e" : 1.0, "f" : 3.0, "b" : 2.0})


  def testGetItem(self):
    """Test item access for Symbol_Table"""
    symTable = cexprtk.Symbol_Table({'x' : 10.0, 'y' : 20.0 }, {'a' : 1})

    with self.assertRaises(KeyError):
      v = symTable.variables['a']

    with self.assertRaises(KeyError):
      v = symTable.variables['z']

    self.assertEquals(20.0, symTable.variables['y'])


  def testVariablesHasKey(self):
    """Test 'in' and 'has_key' for _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table(d, {'a' : 1})

    self.assertTrue(symTable.variables.has_key('x'))
    self.assertFalse(symTable.variables.has_key('blah'))
    self.assertFalse(symTable.variables.has_key(1))

    self.assertTrue('x' in symTable.variables)
    self.assertFalse('z' in symTable.variables)


  def testVariablesKeys(self):
    """Test keys() method _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    self.assertEquals(['x','y','z'], sorted(symTable.variables.keys()))
    self.assertEquals(['x','y','z'], sorted(symTable.variables.iterkeys()))
    self.assertEquals(['x','y','z'], sorted(symTable.variables))


  def testVariablesItems(self):
    """Test items() method _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    self.assertEquals(sorted(d.items()), sorted(symTable.variables.items()))


  def testVariablesLen(self):
    """Test len() for _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    self.assertEquals(3, len(symTable.variables))


  def testVariableInstantiation(self):
    """Test instantiation using variable dictionary and contents of variables dictionary"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table(dict(d), {'a' : 1})
    self.assertEquals(d, dict(symTable.variables))


  def testVariableAssignment(self):
    """Test assignment to variables property of Symbol_Table"""
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})
    self.assertEquals(10.0, symTable.variables['x'])
    symTable.variables['x'] = 20.0
    self.assertEquals(20.0, symTable.variables['x'])


  def testBadVariableAssignment(self):
    """Test assignment to non-existent variable"""
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    with self.assertRaises(KeyError):
      y = symTable.variables['y']

    with self.assertRaises(KeyError):
      symTable.variables['y'] = 11.0

  def testVariableAssignmentToConstant(self):
    """Check that variable assignment cannot happen to name taken by constant"""
    symTable = cexprtk.Symbol_Table({'a' : 1}, {'x' : 2})
    with self.assertRaises(KeyError):
      symTable.variables['x'] = 2.0


  def testVariablesOwnership(self):
    """Test sensible behaviour if _Symbol_Table_Variables reference is held after garbage collection of parent Symbol_Table object"""
    import gc
    self.assertTrue(gc.isenabled())
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table(d, {'a' : 1})
    variables = symTable.variables
    self.assertEquals(10.0, variables['x'])
    symTable = None
    gc.collect()

    with self.assertRaises(ReferenceError):
      variables['x']

    with self.assertRaises(ReferenceError):
      variables['x'] = 20.0

    with self.assertRaises(ReferenceError):
      len(variables)

    with self.assertRaises(ReferenceError):
      variables.items()

    with self.assertRaises(ReferenceError):
      variables.iteritems()

    with self.assertRaises(ReferenceError):
      variables.iteritems()

    with self.assertRaises(ReferenceError):
      variables.iterkeys()

    with self.assertRaises(ReferenceError):
      variables.itervalues()

    with self.assertRaises(ReferenceError):
      variables.keys()

    with self.assertRaises(ReferenceError):
      variables.values()

    with self.assertRaises(ReferenceError):
      variables.has_key('x')

    with self.assertRaises(ReferenceError):
      iter(variables)


class Symbol_TableConstantsTestCase(unittest.TestCase):
  """Tests for cexprtk._Symbol_Table_Constants"""

  def testAddConstantsFlag(self):
    """Test the Symbol_Table 'add_constants' flag"""
    symTable = cexprtk.Symbol_Table({},{}, add_constants = True)
    self.assertEquals(sorted(["pi", "epsilon", "inf"]), sorted(symTable.constants.keys()))

    symTable = cexprtk.Symbol_Table({},{}, add_constants = False)
    self.assertEquals({}, dict(symTable.constants))


  def testGetItem(self):
    """Test item access for Symbol_Table"""
    symTable = cexprtk.Symbol_Table({'x' : 10.0, 'y' : 20.0 }, {'a' : 1})

    with self.assertRaises(KeyError):
      v = symTable.constants['x']

    with self.assertRaises(KeyError):
      v = symTable.constants['z']

    self.assertEquals(1.0, symTable.constants['a'])

  def testConstantsHasKey(self):
    """Test 'in' and 'has_key' for _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    self.assertTrue(symTable.constants.has_key('x'))
    self.assertFalse(symTable.constants.has_key('blah'))
    self.assertFalse(symTable.constants.has_key(1))

    self.assertTrue('x' in symTable.constants)
    self.assertFalse('z' in symTable.constants)


  def testConstantsKeys(self):
    """Test keys() method _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    self.assertEquals(['x','y','z'], sorted(symTable.constants.keys()))
    self.assertEquals(['x','y','z'], sorted(symTable.constants.iterkeys()))
    self.assertEquals(['x','y','z'], sorted(symTable.constants))


  def testConstantsItems(self):
    """Test items() method _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    self.assertEquals(sorted(d.items()), sorted(symTable.constants.items()))


  def testConstantsLen(self):
    """Test len() for _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    self.assertEquals(3, len(symTable.constants))


  def testVariableInstantiation(self):
    """Test instantiation using variable dictionary and contents of constants dictionary"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, dict(d))
    self.assertEquals(d, dict(symTable.constants))


  def testVariableAssignment(self):
    """Test assignment to constants property of Symbol_Table"""
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)
    with self.assertRaises(TypeError):
      symTable.constants['x'] = 20.0


  def testConstantsOwnership(self):
    """Test sensible behaviour if _Symbol_Table_Constants reference is held after garbage collection of parent Symbol_Table object"""
    import gc
    self.assertTrue(gc.isenabled())
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)
    con = symTable.constants
    self.assertEquals(10.0, con['x'])
    symTable = None
    gc.collect()

    with self.assertRaises(ReferenceError):
      con['x']

    with self.assertRaises(ReferenceError):
      len(con)

    with self.assertRaises(ReferenceError):
      con.items()

    with self.assertRaises(ReferenceError):
      con.iteritems()

    with self.assertRaises(ReferenceError):
      con.iteritems()

    with self.assertRaises(ReferenceError):
      con.iterkeys()

    with self.assertRaises(ReferenceError):
      con.itervalues()

    with self.assertRaises(ReferenceError):
      con.keys()

    with self.assertRaises(ReferenceError):
      con.values()

    with self.assertRaises(ReferenceError):
      con.has_key('x')

    with self.assertRaises(ReferenceError):
      iter(con)


class CheckExpressionTestCase(unittest.TestCase):
  """Tests for cexprtk.check_expression"""

  def testCheckExpression(self):
    with self.assertRaises(cexprtk.ParseException):
      cexprtk.check_expression("(a + 1")

    with self.assertRaises(cexprtk.ParseException):
      cexprtk.check_expression("(a + log(1)+foo(bar))")
    cexprtk.check_expression("(a + exp(bar))")


    cexprtk.check_expression("(a + 1)")

    cexprtk.check_expression("log(a + 1)")
    cexprtk.check_expression("log(2)")


class EvaluateExpressionTestCase(unittest.TestCase):
  """Tests for cexprtk.evaluate_expression"""

  def testParseException(self):
    with self.assertRaises(cexprtk.ParseException):
      cexprtk.evaluate_expression("(1 + 1", {})

  def testAddition(self):
    self.assertAlmostEquals(3.57,
      cexprtk.evaluate_expression("A+B", {"A" : 1.23, "B" : 2.34}))

  def testSubtraction(self):
    self.assertAlmostEquals(
      -6.33,
      cexprtk.evaluate_expression('A - 12', {"A" : 5.67}))

  def testMultiplication(self):
    self.assertAlmostEquals(
      6.9741,
      cexprtk.evaluate_expression('A * B', {"A" : 1.23, "B": 5.67}))

  def testDivision(self):
    self.assertAlmostEquals(
      4.065040650406504,
      cexprtk.evaluate_expression('5/A', {"A" : 1.23 }))

  def testPower(self):
    self.assertAlmostEquals(
      8.0,
      cexprtk.evaluate_expression('2^A', {"A" : 3}))


  def testSqrt(self):
    expression ='5+sqrt(3-B)-0'
    self.assertAlmostEquals(
      math.sqrt(2)+5,
      cexprtk.evaluate_expression(expression, {"B" : 1}))


  def testNegativeNumber(self):
    self.assertAlmostEquals(-1.0,
      cexprtk.evaluate_expression("-1.0", {"A" : 1.0}))

    self.assertAlmostEquals(-1.0,
      cexprtk.evaluate_expression("-A", {"A" : 1.0}))

    self.assertAlmostEquals(2.0,
      cexprtk.evaluate_expression("A--1", {"A" : 1.0}))


  def testVariablesStartingInE(self):
    self.assertAlmostEquals(4.0,
      cexprtk.evaluate_expression("electroneg * 4", {"electroneg" : 1.0}))

    self.assertAlmostEquals(1e-3,
      cexprtk.evaluate_expression("1e-3", {"electroneg" : 1.0}))


  def testBooleanAnd(self):
    self.assertEquals(1,
      cexprtk.evaluate_expression("A and B", {"A" : 1.2, "B" : 1}))

    self.assertEquals(0,
      cexprtk.evaluate_expression("A and B", {"A" : 1.2, "B" : 0}))

  def testBooleanOr(self):
    self.assertEquals(1,
      cexprtk.evaluate_expression("A or B", {"A" : 1.2, "B" : 1}))

    self.assertEquals(1,
      cexprtk.evaluate_expression("A or B", {"A" : 1.2, "B" : 0}))

    self.assertEquals(0,
      cexprtk.evaluate_expression("A or B", {"A" : 0, "B" : 0}))


  def testBooleanNot(self):
    self.assertEquals(1,
      cexprtk.evaluate_expression("not(A)", {"A" : 0.0}) )


    self.assertEquals(0,
      cexprtk.evaluate_expression("not(A and B)", {"A": 1.2, "B" : 1}))

    self.assertEquals(0,
      cexprtk.evaluate_expression("not(abs(A))", {"A": 1.2, "B" : 1}))


  def testIf(self):
    self.assertEquals(2,
      cexprtk.evaluate_expression("if ( A>1 , 2, 3 )", {"A" : 3}))

    self.assertEquals(3,
      cexprtk.evaluate_expression("if ( not(A>2), 2, 3 )", {"A" : 3}))


  def testNestedFunction(self):
    expression = 'floor(if(abs(2)<0, 0.8, A))'
    expect = 1.0
    actual = cexprtk.evaluate_expression(expression, {'A':1.5})
    self.assertAlmostEquals(expect, actual)

    expression = 'floor(if(2<0, 0.8, if(ceil(A) > 1.9, -1.0, 3)))'
    expect = -1.0
    actual = cexprtk.evaluate_expression(expression, {'A':1.5})
    self.assertAlmostEquals(expect, actual)



class UnknownSymbolResolverTestCase(unittest.TestCase):
  """Test unknown_symbol_resolver_callback argument to Expression"""

  def testEndToEnd(self):
    """End to end test"""

    class MemoUnknownSymbolResolver(object):

      def __init__(self):
        self.callList = []
        self.retList = {
          'x' : (True, cexprtk.USRSymbolType.VARIABLE, 1.0, ""),
          'y' : (True, cexprtk.USRSymbolType.CONSTANT, 2.0, ""),
          'z' : (True, cexprtk.USRSymbolType.VARIABLE, 3.0, "")}

      def __call__(self, sym):
        self.callList.append(sym)
        return self.retList[sym]

    unknownSymbolResolver = MemoUnknownSymbolResolver()

    symbolTable = cexprtk.Symbol_Table({})
    expression = cexprtk.Expression("x+y+z", symbolTable, unknownSymbolResolver)

    self.assertEquals(['x','y','z'], unknownSymbolResolver.callList)
    self.assertEquals(6.0, expression())

    expectVariables = {'x' : 1.0, 'z' : 3.0}
    self.assertEquals(expectVariables, dict(symbolTable.variables.items()))

    expectConstants = {'y' : 2.0}
    self.assertEquals(expectConstants, dict(symbolTable.constants.items()))

  def testErrors(self):
    """Test unknown_symbol_resolver_callback when it throws errors."""

    def callback(sym):
      if sym == 'x':
        return (True, cexprtk.USRSymbolType.VARIABLE, 1.0, "")
      else:
        return (False, cexprtk.USRSymbolType.VARIABLE, 0.0, "Error text")

    symbolTable = cexprtk.Symbol_Table({})

    with self.assertRaises(cexprtk.ParseException):
      expression = cexprtk.Expression("x+y+z", symbolTable, callback)

  def testBadSymbolType(self):
    """Test that condition is correctly handled if bad USRSymbolType specified"""

    def callback(sym):
      return (True, 3, 0.0, "Error text")

    symbolTable = cexprtk.Symbol_Table({})

    with self.assertRaises(cexprtk.UnknownSymbolResolverException):
      expression = cexprtk.Expression("x+y+z", symbolTable, callback)


  def testUSRException(self):
    """Test when the unknown symbol resolver throws"""

    def callback(sym):
      return 1.0/0

    symbolTable = cexprtk.Symbol_Table({})

    with self.assertRaises(ZeroDivisionError):
      expression = cexprtk.Expression("x+y+z", symbolTable, callback)

