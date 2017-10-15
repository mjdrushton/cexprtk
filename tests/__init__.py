from . import test_cexprtk
from . import test_cexprtk_functions

def suite():
  import unittest
  testloader = unittest.TestLoader()
  tests = testloader.loadTestsFromModule(test_cexprtk)
  tests.extend(testloader.loadTestsFromModule(test_cexprtk_functions))
  return tests
