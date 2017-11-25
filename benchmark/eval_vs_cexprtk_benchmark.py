#!/usr/bin/python
import cexprtk
import math
import time

'''
To run this script perform the following:

pip install cexprtk
python eval_vs_cexprtk_benchmark.py
'''

expression_list = [
   'math.sin(x) + 1.0',
   '1.0 + 2.0 / 3.0',
   'x + 1.0',
   'x * y',
   '2.0 * x + 1.0',
   '2.0 * x + y / 3.0',
   '5.0 / (x + 1.0) * (1 - (x * 0.1) / 3.0)',
   '5.0 / (2.0 * x + y) * (1 - (y * x) / 3.0)',
   'abs(x + 1.0)',
   'abs(x + y)',
   'x + abs(x + 1.0) / 2.0',
   'x * abs(x + 1.0) / x',
   'x * abs(x + y) / y',
   'x * ((x + y) * (x - y)) / y'
]


def evaluate_expression(expression):
   print('Expression: ' + expression)
   rounds = 100000

   time_start = time.time()
   x = 1.0
   y = 3.3
   sum = 0.0
   for x in range(1, rounds + 1, 1):
       sum += eval(expression)
   time_end = time.time()
   total_time = time_end - time_start;
   print('[eval]    Total time: %6.3fsec\tRate: %12.3fevals/sec\tSum: %f' % (total_time, rounds / total_time, sum))

   time_start = time.time()
   symbol_table = cexprtk.Symbol_Table( {"x" : x,"y" : y }, add_constants = True)
   expr = cexprtk.Expression(expression, symbol_table)
   x = 1.0
   y = 3.3
   sum = 0.0
   for x in range(1, rounds + 1, 1):
      symbol_table.variables['x'] = x
      symbol_table.variables['y'] = y
      sum += expr()
   time_end = time.time()
   total_time = time_end - time_start;
   print('[cexprtk] Total time: %6.3fsec\tRate: %12.3fevals/sec\tSum: %f' % (total_time, rounds / total_time, sum))

   print('\n')



def main():
   for expression in expression_list:
      evaluate_expression(expression)


if __name__ == "__main__":
    main()

