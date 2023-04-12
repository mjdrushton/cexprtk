import unittest
import math
import sys

import cexprtk

class ExpressionTestCase(unittest.TestCase):
  """Tests for the cexprtk.Expression class"""

  def testNoVariables(self):
    """Perform test with no variables"""
    st = cexprtk.Symbol_Table({},{})
    expression = cexprtk.Expression("2+2", st)
    v = expression.value()
    self.assertAlmostEqual(4.0, v)

    v = expression()
    self.assertAlmostEqual(4.0, v)

  def testWithVariables(self):
    """Perform a test with some variables"""

    st = cexprtk.Symbol_Table({'a' : 2, 'b' : 3},{})
    expression = cexprtk.Expression("(a+b) * 3", st)
    v = expression.value()
    self.assertAlmostEqual(15.0, v)

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
    self.assertAlmostEqual(15.0, v)

    st = expression.symbol_table
    st.variables['a'] = 3.0

    v = expression()
    self.assertAlmostEqual(18.0, v)

  def testReturnResults(self):
    """Test that basic return calls in expressions work."""
    st = cexprtk.Symbol_Table({}, {})
    exp = "var x[2] := {1, 2}; return [4, 'abc', x];"
    expression = cexprtk.Expression(exp, st)
    v = expression.value()

    results_list = expression.results()

    self.assertEqual(3, len(results_list))

    scalar_val = results_list[0]
    self.assertAlmostEqual(4.0, scalar_val)

    string_val = results_list[1]
    self.assertEqual('abc', string_val)

    vector_val = results_list[2]
    self.assertEqual(2, len(vector_val))
    self.assertAlmostEqual(1.0, vector_val[0])
    self.assertAlmostEqual(2.0, vector_val[1])

  def testResultsEmptyWithNoReturn(self):
    """Test that an expression has no results
    when it doesn't include a return statement"""
    st = cexprtk.Symbol_Table({},{})
    expression = cexprtk.Expression("2+2", st)
    v = expression.value()
    self.assertAlmostEqual(4.0, v)

    results_list = expression.results()
    self.assertEqual(0, len(results_list))


  def testStringResults(self):
    """Test an expression that uses string functions and returns string result"""

    st = cexprtk.Symbol_Table({}, {}, string_variables = {"b" : "bee"})
    expression = cexprtk.Expression("return [b + 'n']", st)
    expression.value()

    results = expression.results()
    assert len(results) == 1
    assert results[0] == "been"

  def test_String_If_Statement(self):
    st = cexprtk.Symbol_Table({}, string_variables={"x" : "one"})
    expression = cexprtk.Expression("if (x=='one') 1;else 10;", st)
    assert 1 == expression.value()

    assert st.string_variables["x"] == "one"
    st.string_variables["x"] = "two"
    assert st.string_variables["x"] == "two"
    assert 10 == expression.value()

    expression = cexprtk.Expression("if (x=='one') return [1];else return [10];", st)
    assert st.string_variables["x"] == "two"
    expression.value()
    assert 10 == expression.results()[0]

    st.string_variables["x"] = "one"
    assert st.string_variables["x"] == "one"
    expression.value()
    assert 1 == expression.results()[0]
 

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

    with self.assertRaises(cexprtk.VariableNameShadowException):
      cexprtk.Symbol_Table({"a" : 1.0, "b" : 2.0}, functions={'b': lambda x: x})

    with self.assertRaises(cexprtk.VariableNameShadowException):
      cexprtk.Symbol_Table({"a" : 1.0, "b" : 2.0}, string_variables={'b': 'bee'})

    with self.assertRaises(cexprtk.VariableNameShadowException):
      cexprtk.Symbol_Table({}, constants= {"a" : 1, "b" : 2}, functions= {"b" : lambda x: x} )

    with self.assertRaises(cexprtk.VariableNameShadowException):
      cexprtk.Symbol_Table({}, constants= {"a" : 1, "b" : 2}, string_variables = {"b" : "bee"} )

    with self.assertRaises(cexprtk.VariableNameShadowException):
      cexprtk.Symbol_Table({}, functions= {"b" : lambda x: x}, string_variables = {"b" : "bee"} )


    st = cexprtk.Symbol_Table({}, {'constant' : 2})
    with self.assertRaises(KeyError):
      st.variables["constant"] = 3

    st.variables["v"] = 3
    with self.assertRaises(KeyError):
      st.functions["v"] = lambda x: x

    with self.assertRaises(KeyError):
      st.string_variables["v"] = "vee"

    with self.assertRaises(KeyError):
      st.functions["constant"] = lambda x: x

    with self.assertRaises(KeyError):
      st.string_variables["constant"] = "vee"

    st.functions["f"] = lambda x: x
    with self.assertRaises(KeyError):
      st.string_variables["f"] = "vee"



  def testGetItem(self):
    """Test item access for Symbol_Table"""
    symTable = cexprtk.Symbol_Table({'x' : 10.0, 'y' : 20.0 }, {'a' : 1})

    with self.assertRaises(KeyError):
      v = symTable.variables['a']

    with self.assertRaises(KeyError):
      v = symTable.variables['z']

    assert 20.0 ==  symTable.variables['y']


  def testVariablesHasKey(self):
    """Test 'in' and 'has_key' for _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table(d, {'a' : 1})

    self.assertTrue('x' in symTable.variables)
    self.assertFalse('blah' in symTable.variables)
    self.assertFalse(1 in symTable.variables)

    self.assertTrue('x' in symTable.variables)
    self.assertFalse('z' in symTable.variables)


  def testVariablesKeys(self):
    """Test keys() method _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    assert ['x' == 'y','z'], sorted(symTable.variables.keys())
    assert ['x' == 'y','z'], sorted(symTable.variables.keys())
    assert ['x' == 'y','z'], sorted(symTable.variables)


  def testVariablesItems(self):
    """Test items() method _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    assert sorted(d.items()) ==  sorted(symTable.variables.items())


  def testVariablesLen(self):
    """Test len() for _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    assert 3 ==  len(symTable.variables)


  def testVariableInstantiation(self):
    """Test instantiation using variable dictionary and contents of variables dictionary"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table(dict(d), {'a' : 1})
    assert d ==  dict(symTable.variables)


  def testVariableAssignment(self):
    """Test assignment to variables property of Symbol_Table"""
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})
    assert 10.0 ==  symTable.variables['x']
    symTable.variables['x'] = 20.0
    assert 20.0 ==  symTable.variables['x']

    symTable.string_variables['b'] = "bee"
    assert "bee" == symTable.string_variables['b']

    symTable.functions['f'] = lambda x: x
    assert 'f' in symTable.functions

    st2 = cexprtk.Symbol_Table(d,{'a' : 1},  functions= {'f' : lambda x: x}, string_variables = {'s' : 'ess'}) 

    assert st2.variables['x'] == 10.0
    assert st2.constants['a'] == 1.0
    assert st2.functions['f'](1) == 1.0
    assert st2.string_variables['s'] == 'ess'

    st2.variables['x'] = 3.0
    # st2.functions['f'] = lambda x: 2*x
    st2.string_variables['s'] = 'blibble'

    assert st2.variables['x'] == 3.0
    assert st2.constants['a'] == 1.0
    assert st2.functions['f'](1) == 1.0
    assert st2.string_variables['s'] == 'blibble'

  def testVariableCreationThroughAssignment(self):
    """Test assignment to non-existent variable"""
    d = {'x' : 10.0}
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})
    assert ['x'] ==  symTable.variables.keys()
    assert ['a'] ==  symTable.constants.keys()
    assert [] ==  symTable.functions.keys()
    assert [] == symTable.string_variables.keys()
    with self.assertRaises(KeyError):
      y = symTable.variables['y']

    symTable.variables['y'] = 2.0
    assert ['x' ,  'y'] == sorted(symTable.variables.keys())
    assert ['a'] ==  symTable.constants.keys()
    assert [] ==  symTable.functions.keys()
    assert [] == symTable.string_variables.keys()
    assert 2.0 ==  symTable.variables['y']

    symTable.variables['y'] = 4.0
    assert ['x', 'y'] == sorted(symTable.variables.keys())
    assert ['a'] ==  symTable.constants.keys()
    assert [] ==  symTable.functions.keys()
    assert [] == symTable.string_variables.keys()
    assert 4.0 ==  symTable.variables['y']

    symTable.string_variables['b'] = 'bee'
    assert ['x', 'y'] == sorted(symTable.variables.keys())
    assert ['a'] ==  symTable.constants.keys()
    assert [] ==  symTable.functions.keys()
    assert ['b'] == symTable.string_variables.keys()
    assert 4.0 ==  symTable.variables['y']

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
    assert 10.0 ==  variables['x']
    symTable = None
    gc.collect()

    with self.assertRaises(ReferenceError):
      variables['x']

    with self.assertRaises(ReferenceError):
      variables['x'] = 20.0

    with self.assertRaises(ReferenceError):
      len(variables)

    with self.assertRaises(ReferenceError):
      list(variables.items())

    with self.assertRaises(ReferenceError):
      iter(variables.items())

    with self.assertRaises(ReferenceError):
      iter(variables.items())

    with self.assertRaises(ReferenceError):
      iter(variables.keys())

    with self.assertRaises(ReferenceError):
      iter(variables.values())

    with self.assertRaises(ReferenceError):
      list(variables.keys())

    with self.assertRaises(ReferenceError):
      list(variables.values())

    with self.assertRaises(ReferenceError):
      'x' in variables

    with self.assertRaises(ReferenceError):
      iter(variables)


class Symbol_TableConstantsTestCase(unittest.TestCase):
  """Tests for cexprtk._Symbol_Table_Constants"""

  def testAddConstantsFlag(self):
    """Test the Symbol_Table 'add_constants' flag"""
    symTable = cexprtk.Symbol_Table({},{}, add_constants = True)
    assert sorted(["pi", "epsilon", "inf"]) == sorted(symTable.constants.keys())

    symTable = cexprtk.Symbol_Table({},{}, add_constants = False)
    assert {} ==  dict(symTable.constants)


  def testGetItem(self):
    """Test item access for Symbol_Table"""
    symTable = cexprtk.Symbol_Table({'x' : 10.0, 'y' : 20.0 }, {'a' : 1})

    with self.assertRaises(KeyError):
      v = symTable.constants['x']

    with self.assertRaises(KeyError):
      v = symTable.constants['z']

    assert 1.0 ==  symTable.constants['a']

  def testConstantsHasKey(self):
    """Test 'in' and 'has_key' for _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    self.assertTrue('x' in symTable.constants)
    self.assertFalse('blah' in symTable.constants)
    self.assertFalse(1 in symTable.constants)

    self.assertTrue('x' in symTable.constants)
    self.assertFalse('z' in symTable.constants)


  def testConstantsKeys(self):
    """Test keys() method _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    assert ['x' , 'y','z'] == sorted(symTable.constants.keys())
    assert ['x' , 'y','z'] == sorted(symTable.constants.keys())
    assert ['x' , 'y','z'] == sorted(symTable.constants)


  def testConstantsItems(self):
    """Test items() method _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    assert sorted(d.items()) ==  sorted(symTable.constants.items())


  def testConstantsLen(self):
    """Test len() for _Symbol_Table_Constants"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, d)

    assert 3 ==  len(symTable.constants)


  def testVariableInstantiation(self):
    """Test instantiation using variable dictionary and contents of constants dictionary"""
    d = {'x' : 10.0, 'y' : 20.0 }
    symTable = cexprtk.Symbol_Table({'a' : 1}, dict(d))
    assert d ==  dict(symTable.constants)


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
    assert 10.0 ==  con['x']
    symTable = None
    gc.collect()

    with self.assertRaises(ReferenceError):
      con['x']

    with self.assertRaises(ReferenceError):
      len(con)

    with self.assertRaises(ReferenceError):
      list(con.items())

    with self.assertRaises(ReferenceError):
      iter(con.items())

    with self.assertRaises(ReferenceError):
      iter(con.items())

    with self.assertRaises(ReferenceError):
      iter(con.keys())

    with self.assertRaises(ReferenceError):
      iter(con.values())

    with self.assertRaises(ReferenceError):
      list(con.keys())

    with self.assertRaises(ReferenceError):
      list(con.values())

    with self.assertRaises(ReferenceError):
      'x' in con

    with self.assertRaises(ReferenceError):
      iter(con)

class Symbol_Table_String_VariablesTestCase(unittest.TestCase):
  """Tests for cexprtk._Symbol_Table_String_Variables"""


  def testGetItem(self):
    """Test item access for Symbol_Table"""
    symTable = cexprtk.Symbol_Table({'a' : 1}, string_variables = {'b' : 'bee'})

    with self.assertRaises(KeyError):
      v = symTable.string_variables['a']

    with self.assertRaises(KeyError):
      v = symTable.string_variables['z']

    assert 'bee' ==  symTable.string_variables['b']


  def testVariablesHasKey(self):
    """Test 'in' and 'has_key' for _Symbol_Table_String_Variables"""
    d = {'x' : 'ex', 'y' : 'why' }
    symTable = cexprtk.Symbol_Table({}, {'a' : 1}, string_variables=d)

    self.assertTrue('x' in symTable.string_variables)
    self.assertFalse('blah' in symTable.string_variables)
    self.assertFalse(1 in symTable.string_variables)

    self.assertTrue('x' in symTable.string_variables)
    self.assertFalse('z' in symTable.string_variables)


  def testVariablesKeys(self):
    """Test keys() method _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    assert ['x', 'y','z'] == sorted(symTable.variables.keys())
    assert ['x', 'y','z'] == sorted(symTable.variables.keys())
    assert ['x', 'y','z'] == sorted(symTable.variables)


  def testVariablesItems(self):
    """Test items() method _Symbol_Table_Variables"""
    d = {'x' : 10.0, 'y' : 20.0, 'z'  : 30.0 }
    symTable = cexprtk.Symbol_Table(d,{'a' : 1})

    assert sorted(d.items()) ==  sorted(symTable.variables.items())


  def testVariablesLen(self):
    """Test len() for _Symbol_Table_Variables"""
    d = {'x' : 'ex', 'y' : 'why', 'z'  : 'zed' }
    symTable = cexprtk.Symbol_Table({},{'a' : 1}, string_variables = d)
    assert 3 ==  len(symTable.string_variables)


class CheckExpressionTestCase(unittest.TestCase):
  """Tests for cexprtk.check_expression"""

  def testCheckExpression(self):
    with self.assertRaises(cexprtk.ParseException):
      cexprtk.check_expression("(a + 1")

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
    self.assertAlmostEqual(3.57,
      cexprtk.evaluate_expression("A+B", {"A" : 1.23, "B" : 2.34}))

  def testSubtraction(self):
    self.assertAlmostEqual(
      -6.33,
      cexprtk.evaluate_expression('A - 12', {"A" : 5.67}))

  def testMultiplication(self):
    self.assertAlmostEqual(
      6.9741,
      cexprtk.evaluate_expression('A * B', {"A" : 1.23, "B": 5.67}))

  def testDivision(self):
    self.assertAlmostEqual(
      4.065040650406504,
      cexprtk.evaluate_expression('5/A', {"A" : 1.23 }))

  def testPower(self):
    self.assertAlmostEqual(
      8.0,
      cexprtk.evaluate_expression('2^A', {"A" : 3}))


  def testSqrt(self):
    expression ='5+sqrt(3-B)-0'
    self.assertAlmostEqual(
      math.sqrt(2)+5,
      cexprtk.evaluate_expression(expression, {"B" : 1}))


  def testNegativeNumber(self):
    self.assertAlmostEqual(-1.0,
      cexprtk.evaluate_expression("-1.0", {"A" : 1.0}))

    self.assertAlmostEqual(-1.0,
      cexprtk.evaluate_expression("-A", {"A" : 1.0}))

    self.assertAlmostEqual(2.0,
      cexprtk.evaluate_expression("1 - -1", {}))

    self.assertAlmostEqual(2.0,
      cexprtk.evaluate_expression("1--1", {}))

    self.assertAlmostEqual(2.0,
      cexprtk.evaluate_expression("A--1", {"A" : 1.0}))


  def testVariablesStartingInE(self):
    self.assertAlmostEqual(4.0,
      cexprtk.evaluate_expression("electroneg * 4", {"electroneg" : 1.0}))

    self.assertAlmostEqual(1e-3,
      cexprtk.evaluate_expression("1e-3", {"electroneg" : 1.0}))


  def testBooleanAnd(self):
    self.assertEqual(1,
      cexprtk.evaluate_expression("A and B", {"A" : 1.2, "B" : 1}))

    self.assertEqual(0,
      cexprtk.evaluate_expression("A and B", {"A" : 1.2, "B" : 0}))

  def testBooleanOr(self):
    self.assertEqual(1,
      cexprtk.evaluate_expression("A or B", {"A" : 1.2, "B" : 1}))

    self.assertEqual(1,
      cexprtk.evaluate_expression("A or B", {"A" : 1.2, "B" : 0}))

    self.assertEqual(0,
      cexprtk.evaluate_expression("A or B", {"A" : 0, "B" : 0}))


  def testBooleanNot(self):
    self.assertEqual(1,
      cexprtk.evaluate_expression("not(A)", {"A" : 0.0}) )


    self.assertEqual(0,
      cexprtk.evaluate_expression("not(A and B)", {"A": 1.2, "B" : 1}))

    self.assertEqual(0,
      cexprtk.evaluate_expression("not(abs(A))", {"A": 1.2, "B" : 1}))


  def testIf(self):
    self.assertEqual(2,
      cexprtk.evaluate_expression("if ( A>1 , 2, 3 )", {"A" : 3}))

    self.assertEqual(3,
      cexprtk.evaluate_expression("if ( not(A>2), 2, 3 )", {"A" : 3}))


  def testNestedFunction(self):
    expression = 'floor(if(abs(2)<0, 0.8, A))'
    expect = 1.0
    actual = cexprtk.evaluate_expression(expression, {'A':1.5})
    self.assertAlmostEqual(expect, actual)

    expression = 'floor(if(2<0, 0.8, if(ceil(A) > 1.9, -1.0, 3)))'
    expect = -1.0
    actual = cexprtk.evaluate_expression(expression, {'A':1.5})
    self.assertAlmostEqual(expect, actual)



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

    assert ['x' == 'y','z'], unknownSymbolResolver.callList
    assert 6.0 ==  expression()

    expectVariables = {'x' : 1.0, 'z' : 3.0}
    assert expectVariables ==  dict(list(symbolTable.variables.items()))

    expectConstants = {'y' : 2.0}
    assert expectConstants ==  dict(list(symbolTable.constants.items()))

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


@unittest.skipIf(sys.platform.startswith("win"), "test not supported under Windows")
class MultiProcessingTestCase(unittest.TestCase):
  """Test that Expressions can be used in parallel with multiprocessing"""

  def testWithoutSpecificSymbolTable(self):
    """Test for expression with no variables"""
    import multiprocessing
    from .multi import evaluate_expression
    expression = cexprtk.Expression("2+2", None)
    pool = multiprocessing.Pool(processes = 1)
    results = pool.map(evaluate_expression, [expression])
    assert 4 ==  results[0]

  def testMultiprocesses(self):
    """Test with multiple processes"""

    exprstr = "A * exp(rho / r ) - C/(r^6)"
    rvals = [ 1.0 + x/10.0 for x in range(100)]
    rhovals = [ 0.1, 0.2, 0.3]

    inputs = [ ]
    for rhoval in rhovals:
      for rval in rvals:
        inputs.append((rhoval, rval))

    import math
    def pfunc(rho, r):
      return 1000.0 * math.exp(rho / r) - 32.0/r**6

    expected = [ pfunc(rho,r) for (rho,r) in inputs]

    import multiprocessing
    from .multi import Worker
    expression = cexprtk.Expression(exprstr, 
      cexprtk.Symbol_Table({'rho' : 0, 'r' : 0}, {'A' : 1000.0, 'C' : 32.0}))

    pool = multiprocessing.Pool(4)
    results = pool.map(Worker(expression), inputs)
    
    assert len(expected) == len(results)
    for (e,a) in zip(expected, results):
      self.assertAlmostEqual(e,a)


def unknownSymbolResolver(symbol):
    try:
      v = {'A' : 1, 'B' : 2, 'C' : 3}[symbol]
      return (True, cexprtk.USRSymbolType.VARIABLE, v, "")
    except KeyError:
      return (False, cexprtk.USRSymbolType.VARIABLE, 0.0, "Unknown ")


class PickleTestCase(unittest.TestCase):
  """Test pickling of the Expression and Symbol_Table classes"""  

  def testSymbolTablePickle(self):
    """Test pickling of the symbol table"""
    import pickle
    variables = {"A" : 1, "B" : 2, "C" : 3}
    constants = {"d" : 4, "e" : 5, "f" : 6}
    string_vars = {"g" : "aay", "h" : "aitch", "i" : "eiy"}
    symbolTable = cexprtk.Symbol_Table(variables, constants, False, {}, string_vars)

    assert constants ==  dict(symbolTable.constants)
    assert variables ==  dict(symbolTable.variables)
    assert string_vars == dict(symbolTable.string_variables)

    dumped = pickle.dumps(symbolTable)
    unpickled = pickle.loads(dumped)

    self.assertIsInstance(unpickled, cexprtk.Symbol_Table)

    assert constants ==  dict(unpickled.constants)
    assert variables ==  dict(unpickled.variables)
    assert string_vars == dict(unpickled.string_variables)

  def testExpressionPickle(self):
    """Pickling of an expression"""
    import pickle
    variables = {"A" : 1, "B" : 2, "C" : 3}
    constants = {"d" : 4, "e" : 5, "f" : 6}
    symbolTable = cexprtk.Symbol_Table(variables, constants, False)

    exprstr = "A+B+C+d+e+f"
    expression = cexprtk.Expression(exprstr, symbolTable)

    assert 21 ==  expression()

    dumped = pickle.dumps(expression)
    unpickled = pickle.loads(dumped)

    self.assertIsInstance(unpickled, cexprtk.Expression)

    assert constants ==  dict(unpickled.symbol_table.constants)
    assert variables ==  dict(unpickled.symbol_table.variables)

    assert 21 ==  unpickled()

  def testExpressionPickleWithUnknownSymbolResolver(self):
    """Pickling of an expression that has an unknown symbol resolver associated with it"""
    import pickle
    
    constants = {"d" : 4, "e" : 5, "f" : 6}
    symbolTable = cexprtk.Symbol_Table({}, constants, False)

    exprstr = "A+B+C+d+e+f"
    expression = cexprtk.Expression(exprstr, symbolTable, unknownSymbolResolver)

    assert 21 ==  expression()

    dumped = pickle.dumps(expression)
    unpickled = pickle.loads(dumped)

    self.assertIsInstance(unpickled, cexprtk.Expression)

    assert constants ==  dict(unpickled.symbol_table.constants)
    variables = {"A" : 1, "B" : 2, "C" : 3}
    assert variables ==  dict(unpickled.symbol_table.variables)

    assert 21 ==  unpickled()