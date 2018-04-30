#! /usr/bin/env python

import math
import time

import cexprtk

def clamp(minimum, x, maximum):
  return max(minimum, min(x, maximum))

def if_func(tf, tval, fval):
  if tf:
    return tval
  else:
    return fval
# ("x / ((x + y) + (x - y)) / y",                                  , lambda x,y: x / ((x + y) + (x - y)) / y),

expression_list = [
  ("(y + x)"                                                       , lambda x,y: y + x),
  ("2 * (y + x)"                                                   , lambda x,y: 2 * (y + x)),
  ("(2 * y + 2 * x)"                                               , lambda x,y: (2 * y + 2 * x)),
  ("((1.23 * x^2) / y) - 123.123"                                  , lambda x,y: ((1.23 * x**2) / y) - 123.123),
  ("(y + x / y) * (x - y / x)"                                     , lambda x,y: (y + x / y) * (x - y / x) ),
  ("1 - ((x * y) + (y / x)) - 3"                                   , lambda x,y: 1 - ((x * y) + (y / x)) - 3),
  ("(5.5 + x) + (2 * x - 2 / 3 * y) * (x / 3 + y / 4) + (y + 7.7)" , lambda x,y: (5.5 + x) + (2 * x - 2 / 3 * y) * (x / 3 + y / 4) + (y + 7.7)),
  ("1.1x^1 + 2.2y^2 - 3.3x^3 + 4.4y^15 - 5.5x^23 + 6.6y^55"        , lambda x,y: 1.1*x**1 + 2.2*y**2 - 3.3*x**3 + 4.4*y**15 - 5.5*x**23 + 6.6*y**55),
  ("sin(2 * x) + cos(pi / y)"                                      , lambda x,y: math.sin(2 * x) + math.cos(math.pi / y)),
  ("1 - sin(2 * x) + cos(pi / y)"                                  , lambda x,y: 1 - math.sin(2 * x) + math.cos(math.pi / y)),
  ("sqrt(111.111 - sin(2 * x) + cos(pi / y) / 333.333)"            , lambda x,y: math.sqrt(111.111 - math.sin(2 * x) + math.cos(math.pi / y) / 333.333)),
  ("(x^2 / sin(2 * pi / y)) - x / 2"                               , lambda x,y: (x**2 / math.sin(2 * math.pi / y)) - x / 2),
  ("x + (cos(y - sin(2 / x * pi)) - sin(x - cos(2 * y / pi))) - y" , lambda x,y: x + (math.cos(y - math.sin(2 / x * math.pi)) - math.sin(x - math.cos(2 * y / math.pi))) - y),
  ("clamp(-1.0, sin(2 * pi * x) + cos(y / 2 * pi), +1.0)"          , lambda x,y: clamp(-1.0, math.sin(2 * math.pi * x) + math.cos(y / 2 * math.pi), +1.0)),
  # ("max(3.33, min(sqrt(1 - sin(2 * x) + cos(pi / y) / 3), 1.11))"  , lambda x,y: max(3.33, min(math.sqrt(1 - math.sin(2 * x) + math.cos(math.pi / y) / 3), 1.11))),
  ("if((y + (x * 2.2)) <= (x + y + 1.1), x - y, x * y) + 2 * pi / x", lambda x,y: if_func((y + (x * 2.2)) <= (x + y + 1.1), x - y, x * y) + 2 * math.pi /x ) ]

def run_benchmark(expression, f):
  lower_bound_x = -10.0
  lower_bound_y = -10.0
  upper_bound_x = +10.0
  upper_bound_y = +10.0

  delta = 0.0111

  x = lower_bound_x
  total = 0.0
  count = 0
  stime = time.time()
  while x <= upper_bound_x:
    y = lower_bound_y
    while y <= upper_bound_y:
      total += f(x,y)
      count += 1
      y += delta
    x += delta
  etime = time.time()

  native_t = (etime - stime)
  native_rate = count/float(native_t)

  symbol_table = cexprtk.Symbol_Table({'x' : 1.0, 'y' : 1.0}, add_constants = True)
  eval_expression = cexprtk.Expression(expression, symbol_table)
  v = symbol_table.variables

  x = lower_bound_x
  total = 0.0
  count = 0
  stime = time.time()
  while x <= upper_bound_x:
    y = lower_bound_y
    while y <= upper_bound_y:
      v['x'] = x
      v['y'] = y
      total += eval_expression.value()
      count += 1
      y += delta
    x += delta
  etime = time.time()

  cexprtk_t = (etime - stime)
  cexprtk_rate = count/float(cexprtk_t)

  print("Expression: {0}".format(expression))
  print("NATIVE_PYTHON: Total Time:%12.8f  Rate:%14.3f evals/sec" % (
    native_t,
    native_rate))

  print("CEXPRTK: Total Time:%12.8f  Rate:%14.3f evals/sec" % (
    cexprtk_t,
    cexprtk_rate))

def main():
  for e, f in expression_list:
    run_benchmark(e,f)

if __name__ == '__main__':
  main()
