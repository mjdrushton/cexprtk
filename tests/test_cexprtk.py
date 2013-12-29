import unittest
import math


import cexprtk

class CExprtkTestCase(unittest.TestCase):
  """Tests for cexprtk"""

  def testParseException(self):

    with self.assertRaises(cexprtk.ParseException):
      cexprtk.evaluate_expression("(1 + 1", {})


  def testCheckExpression(self):
    with self.assertRaises(cexprtk.ParseException):
      cexprtk.check_expression("(a + 1")

    with self.assertRaises(cexprtk.ParseException):
      cexprtk.check_expression("(a + log(1)+foo(bar))")
    cexprtk.check_expression("(a + exp(bar))")


    cexprtk.check_expression("(a + 1)")

    cexprtk.check_expression("log(a + 1)")
    cexprtk.check_expression("log(2)")



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

