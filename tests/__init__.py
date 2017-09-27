def suite():
  import unittest
  from . import test_cexprtk
  from . import test_cexprtk_functions
  testloader = unittest.TestLoader()
  tests = testloader.loadTestsFromModule(test_cexprtk)
  tests.extend(testloader.loadTestsFromModule(test_cexprtk_functions))
  return tests
