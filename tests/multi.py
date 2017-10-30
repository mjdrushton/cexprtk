
def evaluate_expression(expression):
      return expression()


class Worker(object):

  def __init__(self, expression):
    self.expression = expression

  def __call__(self, args):
    (rho, r) = args
    self.expression.symbol_table.variables['rho'] = rho
    self.expression.symbol_table.variables['r'] = r
    return self.expression()